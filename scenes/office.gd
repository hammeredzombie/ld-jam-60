extends Node2D

var COWORKER_SCENE = preload("res://scenes/coworker.tscn")


@onready var _Player: CharacterBody2D = $Player
@onready var _Timer: Timer = $Timer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var worker_order: Array[int]
var _Cubicles: Array[Node]


func _ready() -> void:
	rng.randomize()
	_Cubicles = $Cubicles.get_children()
	var player_cubicle_index = rng.randi_range(0, _Cubicles.size())
	for index in range(_Cubicles.size()):
		var cubicle = _Cubicles[index]
		if cubicle is not Cubicle:
			push_error("Cubicle%s is not a Cubicle" % str(index + 1))
		if index != player_cubicle_index:
			var worker = COWORKER_SCENE.instantiate()
			cubicle.spawn_worker(worker)
		else:
			cubicle._Worker = _Player
			cubicle.is_player = true
	_Cubicles.shuffle()


func _process(_delta: float) -> void:
	pass
	
