extends Node2D


@export var light_on: bool = true:
	set(value):
		light_on = value
		_LampLight.visible = light_on

@onready var _LampLight: Sprite2D = $LampLight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		light_on = !light_on
