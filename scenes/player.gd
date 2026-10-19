extends CharacterBody2D
class_name Player

const CAMERA_ZOOM_MIN = 2.0
const CAMERA_ZOOM_MAX = 5.0
const CAMERA_ZOOM_STEP = 0.2

const RUN_SPEED = 200.0
const WALK_SPEED = 100.0
const INTERACT_DISTANCE = 64.0

@onready var _Camera := $Camera2D
@onready var _Paper: Sprite2D = $Paper
@onready var _Usb: Sprite2D = $Usb
@onready var _PaperPrinted: Sprite2D = $PaperPrinted
@onready var _Score: Label = $Control/Score
@onready var _Lost: Label = $Control/Lost
@onready var _Restart: Button = $Control/Button

var score: int = 0

var holding_item: String = ''

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if global_position.distance_to(get_global_mouse_position()) > INTERACT_DISTANCE:
			get_viewport().set_input_as_handled()
			return
	if event is InputEventMouseButton:
		if event.is_action_pressed("zoom_in"):
			_Camera.zoom.x -= CAMERA_ZOOM_STEP
			_Camera.zoom.y -= CAMERA_ZOOM_STEP
			_Camera.zoom.x = clamp(_Camera.zoom.x, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
			_Camera.zoom.y = clamp(_Camera.zoom.y, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
		elif event.is_action_pressed("zoom_out"):
			_Camera.zoom.x += CAMERA_ZOOM_STEP
			_Camera.zoom.y += CAMERA_ZOOM_STEP
			_Camera.zoom.x = clamp(_Camera.zoom.x, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)
			_Camera.zoom.y = clamp(_Camera.zoom.y, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)


func _ready() -> void:
	_Restart.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	input_pickable = false
	Global.document_picked_up.connect(_on_document_picked_up)
	Global.usb_picked_up.connect(_on_usb_picked_up)
	Global.secret_submitted.connect(_on_secret_submitted)
	Global.lose.connect(_on_lose)


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var sprinting := Input.is_action_pressed("sprint")
	var speed = RUN_SPEED if sprinting else WALK_SPEED
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()


func _on_document_picked_up(station: Node) -> void:
	if holding_item != '':
		return
	holding_item = 'paper_printed'
	_PaperPrinted.show()
	station.on_document_picked_up()


func _on_usb_picked_up(cubicle: Node) -> void:
	if holding_item != '':
		return
	holding_item = 'usb'
	_Usb.show()
	cubicle.on_usb_picked_up()


func _item_dropped() -> void:
	if holding_item == '':
		return
	var item := holding_item
	holding_item = ''
	_Paper.hide()
	_Usb.hide()
	_PaperPrinted.hide()
	Global.item_dropped.emit(item)


func _on_secret_submitted() -> void:
	_item_dropped()
	_on_score_changed()


func _on_score_changed() -> void:
	score += 1
	_Score.text = str(score)


func _on_lose() -> void:
	_Lost.show()
	_Restart.show()
	_Restart.pressed.connect(_on_button_pressed)
	get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
