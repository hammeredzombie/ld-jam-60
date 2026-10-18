extends CharacterBody2D

const CAMERA_ZOOM_MIN = 2.0
const CAMERA_ZOOM_MAX = 5.0
const CAMERA_ZOOM_STEP = 0.2


const RUN_SPEED = 200.0
const WALK_SPEED = 100.0

@onready var _Camera := $Camera2D


func _input(event: InputEvent) -> void:
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


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var sprinting := Input.is_action_pressed("sprint")
	var speed = RUN_SPEED if sprinting else WALK_SPEED
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

