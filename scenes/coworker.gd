extends CharacterBody2D
class_name Coworker

enum WorkerState {
	IDLE,
	MOVING,
	WORKING
}

const SPEED := 100.0
const WORK_TIME_MIN := 3
const WORK_TIME_MAX := 5
const ARRIVE_DISTANCE := 40.0

var state: WorkerState = WorkerState.IDLE
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _Target: Node2D = null
@onready var _NavAgent: NavigationAgent2D = $NavigationAgent2D
@onready var _Timer: Timer = $Timer
@onready var _Sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	rng.randomize()
	_Timer.one_shot = true
	_Sprite.self_modulate = Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), 1)

func _physics_process(_delta: float) -> void:
	if _Target == null or state != WorkerState.MOVING:
		return

	if NavigationServer2D.map_get_iteration_id(_NavAgent.get_navigation_map()) == 0:
		return

	if _NavAgent.is_navigation_finished():
		target_reached()
		return

	var next_path_position := _NavAgent.get_next_path_position()
	var direction := global_position.direction_to(next_path_position)
	if direction.is_zero_approx():
		return

	velocity = direction * SPEED
	move_and_slide()
	if get_slide_collision_count() > 0 and global_position.distance_to(_NavAgent.target_position) <= ARRIVE_DISTANCE:
		target_reached()


func set_target(target: Node2D) -> void:
	_Timer.stop()
	_Target = target
	_NavAgent.target_position = target.global_position
	state = WorkerState.MOVING


func target_reached() -> void:
	velocity = Vector2.ZERO
	if _Target != null and _Target.is_ancestor_of(self):
		state = WorkerState.IDLE
		_Target = null
	else:
		state = WorkerState.WORKING
		_Timer.start(rng.randf_range(WORK_TIME_MIN, WORK_TIME_MAX))


func _on_timer_timeout() -> void:
	var home := get_parent() as Node2D
	if home:
		set_target(home)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and state == WorkerState.MOVING:
		if _player_is_safe_at_cubicle(body as Player):
			return
		Global.lose.emit()


func _player_is_safe_at_cubicle(player: Player) -> bool:
	var cubicle := _Target as Cubicle
	return cubicle != null and cubicle.is_player and cubicle.contains_point(player.global_position)
