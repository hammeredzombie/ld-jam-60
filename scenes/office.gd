extends Node2D

const COWORKER_SCENE = preload("res://scenes/coworker.tscn")
const TIMER_MIN_TIME = 10.0
const TIMER_MAX_TIME = 20.0

const TARGETS := [
	'PRINTER',
	'PLAYER',
	'KITCHEN',
	'DOOR',
	'FRONT_DESK',
	'COWORKER'
]

@onready var _Player: CharacterBody2D = $Player
@onready var _Timer: Timer = $Timer
@onready var _Printer: Node2D = $PrinterStation/Printer
@onready var _Kitchen: Node2D = $Kitchen
@onready var _Door: Node2D = $Door
@onready var _FrontDesk: Node2D = $FrontDesk
var _PlayerCubicle: Node2D


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _Cubicles: Array[Node]
var active_worker_index: int = 0

func _ready() -> void:
	_bake_navigation()
	rng.randomize()
	_Cubicles = $Cubicles.get_children()
	var player_cubicle_index = rng.randi_range(0, _Cubicles.size() - 1)
	for index in range(_Cubicles.size()):
		var cubicle = _Cubicles[index]
		if cubicle is not Cubicle:
			push_error("Cubicle%s is not a Cubicle" % str(index + 1))
		if index != player_cubicle_index:
			var worker = COWORKER_SCENE.instantiate()
			cubicle.spawn_worker(worker)
		else:
			_PlayerCubicle = cubicle
			cubicle._Worker = _Player
			cubicle.is_player = true
	_Cubicles.shuffle()
	if not _Timer.timeout.is_connected(_on_timer_timeout):
		_Timer.timeout.connect(_on_timer_timeout)
	_set_worker_target()

func _bake_navigation() -> void:
	var region: NavigationRegion2D = $NavigationRegion2D
	var polygon := region.navigation_polygon.duplicate()
	polygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	var source_geometry := NavigationMeshSourceGeometryData2D.new()
	NavigationServer2D.parse_source_geometry_data(polygon, source_geometry, self)
	NavigationServer2D.bake_from_source_geometry_data(polygon, source_geometry)
	region.navigation_polygon = polygon


func _process(_delta: float) -> void:
	pass
	

func _on_timer_timeout() -> void:
	_set_worker_target()


func _set_worker_target() -> void:
	var attempts := _Cubicles.size()
	while attempts > 0:
		var worker: CharacterBody2D = _Cubicles[active_worker_index]._Worker
		active_worker_index = (active_worker_index + 1) % _Cubicles.size()
		attempts -= 1
		if worker == null or worker is Player:
			continue
		var target := _get_random_target()
		if target:
			worker.set_target(target)
		break
	_Timer.start(rng.randf_range(TIMER_MIN_TIME, TIMER_MAX_TIME))


func _get_random_target() -> Node2D:
	var target_type = TARGETS[rng.randi_range(0, TARGETS.size() - 1)]
	match target_type:
		'PRINTER':
			return _Printer
		'PLAYER':
			return _PlayerCubicle
		'KITCHEN':
			return _Kitchen
		'DOOR':
			return _Door
		'FRONT_DESK':
			return _FrontDesk
		'COWORKER':
			return _Cubicles[rng.randi_range(0, _Cubicles.size() - 1)]
		_:
			push_error("Invalid target type: %s" % target_type)
			return null		


func _on_load_paper_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_Printer.on_paper_loaded()
