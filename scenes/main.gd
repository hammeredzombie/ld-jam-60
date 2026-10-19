extends Node2D


@onready var _Office: Node2D = $Office
@onready var _Tutorial: CanvasLayer = $Tutorial
@onready var _Backdrop: ColorRect = $Tutorial/Backdrop
@onready var _Video: VideoStreamPlayer = $Tutorial/Video
@onready var _Button: Button = $Tutorial/Start

var _waiting_for_texture := false


func _ready() -> void:
	_Tutorial.process_mode = Node.PROCESS_MODE_ALWAYS
	_Office.hide()
	_fit_video()
	get_viewport().size_changed.connect(_fit_video)
	get_tree().paused = true


func _fit_video() -> void:
	var video_size := _Video_size()
	if video_size.x <= 0.0 or video_size.y <= 0.0:
		if not _waiting_for_texture:
			_waiting_for_texture = true
			get_tree().process_frame.connect(_fit_when_ready, CONNECT_ONE_SHOT)
		return

	var view_size := get_viewport().get_visible_rect().size
	var fitted_scale := minf(view_size.x / video_size.x, view_size.y / video_size.y)
	var fitted := video_size * fitted_scale
	_Video.scale = Vector2.ONE
	_Video.position = (view_size - fitted) * 0.5
	_Video.size = fitted


func _fit_when_ready() -> void:
	_waiting_for_texture = false
	_fit_video()


func _Video_size() -> Vector2:
	var texture := _Video.get_video_texture()
	if texture == null:
		return Vector2.ZERO
	return texture.get_size()


func _on_video_stream_player_finished() -> void:
	_Video.hide()
	_Backdrop.hide()
	_Office.show()
	_Button.show()
	_Button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	get_tree().paused = false
	_Tutorial.queue_free()
