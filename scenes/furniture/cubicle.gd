extends Node2D
class_name Cubicle

const USB_SCENE = preload("res://scenes/usb.tscn")
const PAPER_SCENE = preload("res://scenes/paper.tscn")
const BOUNDS := 56.0


@onready var _MonitorGlow: Sprite2D = $MonitorGlow
@onready var _Lamp: Node2D = $Lamp
@onready var _PictureFrame1: Sprite2D = $PictureFrame1
@onready var _PictureFrame2: Sprite2D = $PictureFrame2
# @onready var _PaperSprite: Sprite2D = $PaperPrinted
@onready var _PrintSent: Label = $PrintSent
var _Worker: CharacterBody2D = null

var _Usb: Node2D = null
var _Paper: Node2D = null

var has_usb: bool
var has_document: bool
var computer_on: bool = false
var is_player: bool = false
var print_sent: bool = false

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	_Lamp.rotation = rng.randf_range(0, PI / 2)
	var picture = rng.randi_range(1, 2)
	if picture == 1:
		_PictureFrame1.show()
		_PictureFrame2.hide()
		_PictureFrame1.rotation = rng.randf_range(deg_to_rad(120), deg_to_rad(180))
	else:
		_PictureFrame1.hide()
		_PictureFrame2.show()
		_PictureFrame2.rotation = rng.randf_range(deg_to_rad(0), deg_to_rad(30))

	has_usb = rng.randi_range(0, 1) == 1
	if has_usb:
		var usb = USB_SCENE.instantiate()
		var usb_position = rng.randi_range(1, 3)
		var usb_marker = get_node("Marker%s" % usb_position)
		usb.position = usb_marker.position
		add_child(usb)
		_Usb = usb

	has_document = rng.randi_range(0, 1) == 1
	if has_document:
		var paper = PAPER_SCENE.instantiate()
		add_child(paper)
		paper.position = Vector2(39,-34)
		_Paper = paper

	computer_on = rng.randi_range(0, 1) == 1
	if computer_on:
		_MonitorGlow.show()
	else:
		_MonitorGlow.hide()

	_PrintSent.rotation = -rotation
	Global.item_dropped.connect(_on_item_dropped)


func _process(_delta: float) -> void:
	pass


func spawn_worker(worker: CharacterBody2D) -> void:
	_Worker = worker
	add_child(_Worker)
	_Worker.global_position = global_position


func contains_point(world_position: Vector2) -> bool:
	var local_position := to_local(world_position)
	return absf(local_position.x) <= BOUNDS and absf(local_position.y) <= BOUNDS


func _on_computer_input_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if _Worker is Player:
			return
		if _Worker.state == Coworker.WorkerState.IDLE:
			Global.lose.emit()
			return
		if computer_on:
			if not print_sent:
				Global.job_sent_to_printer.emit(self)
				_PrintSent.show()
				await get_tree().create_timer(2).timeout
				_PrintSent.hide()
				print_sent = true
		else:
			computer_on = true
			_MonitorGlow.show()


func _on_item_dropped(item: String) -> void:
	if _Worker is Player and (item == "paper_printed" or item == "usb"):
		Global.secret_submitted.emit()


func on_document_picked_up() -> void:
	_check_if_lose()
	if _Paper == null:
		return
	var area := _Paper.get_node_or_null("Area2D") as Area2D
	if area:
		area.input_pickable = false
	_Paper.queue_free()
	_Paper = null


func on_usb_picked_up() -> void:
	_check_if_lose()
	_Usb.queue_free()


func _on_collect_secret_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if _Worker is Player:
			var player := _Worker as Player
			if player.holding_item == "paper_printed" or player.holding_item == "usb":
				player._item_dropped()
				get_viewport().set_input_as_handled()


func _check_if_lose() -> void:
	if _Worker.state == Coworker.WorkerState.IDLE:
		Global.lose.emit()
