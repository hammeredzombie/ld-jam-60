extends Node2D

@onready var _Door1: Area2D = $Door1
@onready var _Door2: Area2D = $Door2
@onready var _Door3: Area2D = $Door3
@onready var _Door4: Area2D = $Door4

const DOOR_OPEN_ANGLE: float = PI / 2.0
const DOOR_CLOSED_ANGLE: float = 0.0
const DOOR_OPEN_OFFSET: float = 11.0



func _ready() -> void:
	_Door1.input_event.connect(_on_toggle_door.bind(_Door1))
	_Door2.input_event.connect(_on_toggle_door.bind(_Door2))
	_Door3.input_event.connect(_on_toggle_door.bind(_Door3))
	_Door4.input_event.connect(_on_toggle_door.bind(_Door4))


func _process(_delta: float) -> void:
	pass


func open_door(door: Area2D) -> void:
	door.rotation = DOOR_OPEN_ANGLE
	match door.name:
		"Door1":
			door.position.x += DOOR_OPEN_OFFSET
			door.position.y += DOOR_OPEN_OFFSET
		"Door2":
			door.position.x += DOOR_OPEN_OFFSET
			door.position.y -= DOOR_OPEN_OFFSET
		"Door3":
			door.position.x += DOOR_OPEN_OFFSET
			door.position.y += DOOR_OPEN_OFFSET
		"Door4":
			door.position.x += DOOR_OPEN_OFFSET
			door.position.y -= DOOR_OPEN_OFFSET


func close_door(door: Area2D) -> void:
	door.rotation = DOOR_CLOSED_ANGLE
	match door.name:
		"Door1":
			door.position.x -= DOOR_OPEN_OFFSET
			door.position.y -= DOOR_OPEN_OFFSET
		"Door2":
			door.position.x -= DOOR_OPEN_OFFSET
			door.position.y += DOOR_OPEN_OFFSET
		"Door3":
			door.position.x -= DOOR_OPEN_OFFSET
			door.position.y -= DOOR_OPEN_OFFSET
		"Door4":
			door.position.x -= DOOR_OPEN_OFFSET
			door.position.y += DOOR_OPEN_OFFSET


func toggle_door(door: Area2D) -> void:
	if door.rotation == DOOR_CLOSED_ANGLE:
		open_door(door)
	else:
		close_door(door)

func _on_toggle_door(_viewport: Viewport, event: InputEvent, _shape_idx: int, door: Area2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_door(door)
