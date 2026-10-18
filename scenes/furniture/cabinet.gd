extends Node2D

const DRAWER_CLOSED_POS_X := 9.0
const DRAWER_OPEN_POS_X := 25.0

func _ready() -> void:
	for node: Node2D in get_children():
		if node is Area2D:
			node.input_event.connect(_on_drawer_toggle.bind(node))

func _process(_delta: float) -> void:
	pass

func toggle_drawer(index: int) -> void:
	var drawer: Sprite2D = get_node("Drawer" + str(index))
	if drawer.position.x == DRAWER_CLOSED_POS_X:
		drawer.position.x = DRAWER_OPEN_POS_X
	else:
		drawer.position.x = DRAWER_CLOSED_POS_X

func _on_drawer_toggle(_viewport: Node, event: InputEvent, _shape_idx: int, drawer: Area2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var drawer_name := drawer.name as String
		toggle_drawer(drawer_name[-1].to_int())