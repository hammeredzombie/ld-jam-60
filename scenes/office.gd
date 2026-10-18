extends Node2D

var COWORKER_SCENE = preload("res://scenes/coworker.tscn")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var _Player: CharacterBody2D = $Player
@onready var _Cubicles: Node = $Cubicles

func _ready() -> void:
	rng.randomize()
	var player_cubicle_index = rng.randi_range(1, $Cubicles.get_child_count())
	for index in range(1, _Cubicles.get_child_count() + 1):
		var cubicle = _Cubicles.get_node("Cubicle%s" % index)
		if cubicle is not Cubicle:
			push_error("Cubicle%s is not a Cubicle" % index)
		if index != player_cubicle_index:
			var worker = COWORKER_SCENE.instantiate()
			cubicle.spawn_worker(worker)
		else:
			cubicle._Worker = _Player

func _process(delta: float) -> void:
	pass
