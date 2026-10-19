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
var _Player: Player
var _DetectDebug: Polygon2D
@onready var _NavAgent: NavigationAgent2D = $NavigationAgent2D
@onready var _Timer: Timer = $Timer
@onready var _Sprite: Sprite2D = $Sprite2D
@onready var _DetectArea: Area2D = $Area2D
@onready var _DetectShape: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	rng.randomize()
	_Timer.one_shot = true
	_Sprite.self_modulate = Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), 1)
	_setup_detect_debug()

func _physics_process(_delta: float) -> void:
	_update_detect_debug()
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
		if _Target.name ==	'Door':
			self.hide()
		_Timer.start(rng.randf_range(WORK_TIME_MIN, WORK_TIME_MAX))


func _on_timer_timeout() -> void:
	self.show()
	set_target(get_parent())


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and state == WorkerState.MOVING:
		if _player_is_safe_at_cubicle(body as Player):
			return
		Global.lose.emit()


func _setup_detect_debug() -> void:
	_DetectShape.hide()
	var circle := _DetectShape.shape as CircleShape2D
	var radius := circle.radius if circle else 30.0
	_DetectDebug = Polygon2D.new()
	_DetectDebug.color = _DetectShape.debug_color
	_DetectDebug.polygon = _circle_points(radius)
	_DetectArea.add_child(_DetectDebug)
	_DetectDebug.hide()


func _circle_points(radius: float) -> PackedVector2Array:
	var count := 40
	var points := PackedVector2Array()
	points.resize(count)
	for i in count:
		points[i] = Vector2.from_angle(TAU * float(i) / float(count)) * radius
	return points


func _update_detect_debug() -> void:
	_DetectDebug.visible = state == WorkerState.MOVING and _player_can_be_detected()


func _player_can_be_detected() -> bool:
	var player := _get_player()
	return player != null and not _player_is_safe_at_cubicle(player)


func _get_player() -> Player:
	if is_instance_valid(_Player):
		return _Player
	var scene := get_tree().current_scene
	if scene:
		var found := scene.find_child("Player", true, false)
		if found is Player:
			_Player = found
	return _Player


func _player_is_safe_at_cubicle(player: Player) -> bool:
	var cubicle := _Target as Cubicle
	return cubicle != null and cubicle.is_player and cubicle.contains_point(player.global_position)
