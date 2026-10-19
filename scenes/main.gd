extends Node2D


@onready var _Control: Control = $Control
@onready var _Button: Button = $Control/Button
@onready var _VideoStreamPlayer: VideoStreamPlayer = $Control/VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Control.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_video_stream_player_finished() -> void:
	_VideoStreamPlayer.hide()
	_Button.show()
	_Button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	get_tree().paused = false
	_Control.queue_free()
