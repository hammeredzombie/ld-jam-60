extends CharacterBody2D


const SPEED = 300.0

@export var _Goal: Node = null:
	set(value):
		_Goal = value
		_NavAgent.target_position = _Goal.position

@onready var _NavAgent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	_NavAgent.target_position = _Goal.position


func _physics_process(delta: float) -> void:
	if !_NavAgent.is_target_reached():
		var nav_point_direction = to_local(_NavAgent.get_next_path_position()).normalized()
		velocity = nav_point_direction * SPEED * delta
		move_and_slide()
