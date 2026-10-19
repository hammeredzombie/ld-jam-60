extends Node2D
class_name Printer

const PRINT_TIME: float = 5.0

@onready var _PaperLoaded: Sprite2D = $PaperLoaded
@onready var _PaperPrinted: Sprite2D = $PaperPrinted

var paper_loaded: bool = false
var paper_printed: bool = false


func _ready() -> void:
	on_paper_loaded()
	_play_feed_animation() # Replace with function body.


func _process(_delta: float) -> void:
	pass


func on_paper_loaded() -> void:
	paper_loaded = true
	_PaperLoaded.show()


func _on_paper_printed() -> void:
	paper_printed = true


func _play_feed_animation() -> void:
	
	_PaperLoaded.show()
	var feed_tween = create_tween().set_parallel()
	feed_tween.tween_property(_PaperLoaded, "position:y", -13.6, PRINT_TIME)
	feed_tween.tween_property(_PaperLoaded, "scale:y", 0.02, PRINT_TIME)
	feed_tween.finished.connect(_play_print_animation)


func _play_print_animation() -> void:	
	_PaperLoaded.hide()
	var print_tween = create_tween().set_parallel()
	_PaperPrinted.position.y = 12.2
	_PaperPrinted.scale.y = 0.01
	_PaperPrinted.show()
	print_tween.tween_property(_PaperPrinted, "position:y", 21, PRINT_TIME)
	print_tween.tween_property(_PaperPrinted, "scale:y", 0.45, PRINT_TIME)
	print_tween.finished.connect(_on_paper_printed)
	

func _on_collect_document_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if paper_printed:
			Global.document_picked_up.emit(self)


func on_document_picked_up() -> void:
	_PaperPrinted.hide()
	paper_printed = false