extends CharacterBody2D

enum WorkerState {
	IDLE,
	MOVING,
	WORKING
}

const SPEED := 100.0
const WORK_TIME_MIN := 10
const WORK_TIME_MAX := 20

var state: WorkerState = WorkerState.IDLE
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _Target: Node = null
@onready var _NavAgent: NavigationAgent2D = $NavigationAgent2D
@onready var _Timer: Timer = $Timer


func _ready() -> void:
	rng.randomize()


func _physics_process(delta: float) -> void:
	if _Target == null or state != WorkerState.MOVING:
		return

	if !_NavAgent.is_target_reached():
		var nav_point_direction = to_local(_NavAgent.get_next_path_position()).normalized()
		velocity = nav_point_direction * SPEED * delta
		move_and_slide()
	else:
		target_reached()


func set_target(target: Node) -> void:
	_Target = target
	_NavAgent.target_position = _Target.position
	state = WorkerState.MOVING


func target_reached() -> void:
	if _Target.is_ancestor_of(self):
		state = WorkerState.IDLE
		_Target = null
	else:
		state = WorkerState.WORKING
		_Timer.start(rng.randi_range(WORK_TIME_MIN, WORK_TIME_MAX))


func _on_timer_timeout() -> void:
	set_target(get_parent())
