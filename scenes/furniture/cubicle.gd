extends Node2D


@export var has_usb: bool = true

@onready var _Desktop: Sprite2D = $Desktop
@onready var _Monitor: Sprite2D = $Monitor
@onready var _MonitorGlow: Sprite2D = $MonitorGlow
@onready var _Lamp: Node2D = $Lamp
@onready var _Marker1: Marker2D = $Marker1
@onready var _Marker2: Marker2D = $Marker2
@onready var _Marker3: Marker2D = $Marker3
@onready var _PictureFrame1: Sprite2D = $PictureFrame1
@onready var _PictureFrame2: Sprite2D = $PictureFrame2
# Called when the node enters the scene tree for the first time.
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
