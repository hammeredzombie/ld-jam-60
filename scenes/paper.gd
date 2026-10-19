extends Node2D


func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var cubicle := get_parent() as Cubicle
		if cubicle and cubicle._Worker is Player:
			var player := cubicle._Worker as Player
			if player.holding_item == "paper_printed" or player.holding_item == "usb":
				player._item_dropped()
				get_viewport().set_input_as_handled()
				return
		Global.document_picked_up.emit(cubicle)
		get_viewport().set_input_as_handled()
