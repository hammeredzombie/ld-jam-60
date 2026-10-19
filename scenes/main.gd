extends Node2D


@onready var _Control: Control = $Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Control.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print('start')
	get_tree().paused = false
	_Control.queue_free()
