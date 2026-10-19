extends Node2D
class_name Printer

const PRINT_TIME: float = 5.0
const LOAD_PAPER := 'load paper'
const NO_JOBS := 'no jobs'


@onready var _PaperLoaded: Sprite2D = $PaperLoaded
@onready var _PaperPrinted: Sprite2D = $PaperPrinted
@onready var _LightRed: Sprite2D = $LightRed
@onready var _LightGreen: Sprite2D = $LightGreen
@onready var _Label: Label = $Control/Label
@onready var _Error: Label = $Error

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var printing: bool = false
var paper_loaded: bool = false
var paper_printed: bool = false
var _feeding: bool = false
var _paper_loaded_rest_position: Vector2
var _paper_loaded_rest_scale: Vector2

var jobs: int = 0

func _ready() -> void:
	rng.randomize()
	_paper_loaded_rest_position = _PaperLoaded.position
	_paper_loaded_rest_scale = _PaperLoaded.scale
	Global.job_sent_to_printer.connect(_on_job_sent_to_printer)


func _process(_delta: float) -> void:
	pass


func on_paper_loaded() -> void:
	if _feeding or paper_loaded:
		return
	paper_loaded = true
	_PaperLoaded.position = _paper_loaded_rest_position
	_PaperLoaded.scale = _paper_loaded_rest_scale
	_PaperLoaded.show()


func _on_paper_printed() -> void:
	paper_printed = true
	_flash_green_light()
	printing = false


func _play_feed_animation() -> void:
	paper_loaded = false
	_feeding = true
	_flash_green_light()
	var feed_tween = create_tween().set_parallel()
	feed_tween.tween_property(_PaperLoaded, "position:y", -13.6, PRINT_TIME)
	feed_tween.tween_property(_PaperLoaded, "scale:y", 0.02, PRINT_TIME)
	feed_tween.finished.connect(_play_print_animation)


func _play_print_animation() -> void:
	_feeding = false
	jobs -= 1
	_show_print_number(jobs)
	_flash_green_light()
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


func _on_job_sent_to_printer(_cubicle: Node) -> void:
	jobs += 1
	_show_print_number(jobs)


func _on_print_job_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if jobs > 0 and paper_loaded and not printing:
			print('print job')
			printing = true
			_play_feed_animation()
		else:
			_flash_red_light()
			if printing:
				return
			if jobs == 0:
				_Error.text = NO_JOBS
			elif not paper_loaded:
				_Error.text = LOAD_PAPER
			await get_tree().create_timer(1.0).timeout
			_Error.text = ''

func _show_print_number(num: int) -> void:
	_Label.text = str(num)


func _flash_red_light() -> void:
	_LightRed.hide()
	await get_tree().create_timer(0.5).timeout
	_LightRed.show()
	await get_tree().create_timer(0.5).timeout
	_LightRed.hide()
	await get_tree().create_timer(0.5).timeout
	_LightRed.show()
	await get_tree().create_timer(0.5).timeout
	_LightRed.hide()
	await get_tree().create_timer(0.5).timeout
	_LightRed.show()


func _flash_green_light() -> void:
	_LightGreen.hide()
	await get_tree().create_timer(0.5).timeout
	_LightGreen.show()
	await get_tree().create_timer(0.5).timeout
	_LightGreen.hide()
	await get_tree().create_timer(0.5).timeout
	_LightGreen.show()
	await get_tree().create_timer(0.5).timeout
	_LightGreen.hide()
	await get_tree().create_timer(0.5).timeout
	_LightGreen.show()
