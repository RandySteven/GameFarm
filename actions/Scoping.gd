extends Action
class_name Scoping

func _ready() -> void:
	# You already inherit curr_items from Action
	if curr_items.has(ConstItem.Items.SCOPE) and curr_items[ConstItem.Items.SCOPE]:
		return
	return

func scoping():
	
	pass
