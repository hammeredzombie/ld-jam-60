extends Node2D
class_name Cubicle

var USB_SCENE = preload("res://scenes/usb.tscn")
var PAPER_SCENE = preload("res://scenes/paper.tscn")

var has_usb: bool
var has_document: bool
var computer_on: bool = false
var _Worker: CharacterBody2D = null
var is_player: bool = false

@onready var _MonitorGlow: Sprite2D = $MonitorGlow
@onready var _Lamp: Node2D = $Lamp
@onready var _PictureFrame1: Sprite2D = $PictureFrame1
@onready var _PictureFrame2: Sprite2D = $PictureFrame2
@onready var _PaperSprite: Sprite2D = $Paper
@onready var _UsbSprite: Sprite2D = $Usb

var _Usb: Node2D = null
var _Paper: Node2D = null


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

	Global.item_dropped.connect(_on_item_dropped)


func _process(_delta: float) -> void:
	pass


func spawn_worker(worker: CharacterBody2D) -> void:
	_Worker = worker
	add_child(_Worker)
	_Worker.global_position = global_position


func _on_computer_input_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if computer_on:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			emit_signal("job_sent_to_printer", self)


func _on_item_dropped(item: String) -> void:
	if _Worker is Player and item == "paper_printed":
		Global.secret_collected.emit()
	if item == "paper":
		_PaperSprite.show()
	elif item == "usb":
		_UsbSprite.show()


func on_document_picked_up() -> void:
	_Paper.queue_free()


func on_usb_picked_up() -> void:
	_Usb.queue_free()
