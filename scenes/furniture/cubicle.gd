extends Node2D
class_name Cubicle

var USB_SCENE = preload("res://scenes/furniture/usb.tscn")

var has_usb: bool = true
var computer_on: bool = false
var _Worker: CharacterBody2D = null

@onready var _MonitorGlow: Sprite2D = $MonitorGlow
@onready var _Lamp: Node2D = $Lamp
@onready var _PictureFrame1: Sprite2D = $PictureFrame1
@onready var _PictureFrame2: Sprite2D = $PictureFrame2


func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	_Lamp.rotation = rng.randf_range(0, PI / 2)
	var picture = rng.randi_range(1, 2)
	if picture == 1:
		_PictureFrame1.show()
		_PictureFrame2.hide()
		_PictureFrame1.rotation = rng.randf_range(deg_to_rad(120), deg_to_rad(180))
	else:
		_PictureFrame1.hide()
		_PictureFrame2.show()
		_PictureFrame2.rotation = rng.randf_range(deg_to_rad(0), deg_to_rad(30))

	if has_usb:
		var usb = USB_SCENE.instantiate()
		var usb_position = rng.randi_range(1, 3)
		var usb_marker = get_node("Marker%s" % usb_position)
		usb.position = usb_marker.position
		add_child(usb)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_worker(worker: CharacterBody2D) -> void:
	_Worker = worker
	add_child(_Worker)
	_Worker.global_position = global_position
