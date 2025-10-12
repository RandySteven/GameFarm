extends Node


class_name Action

const ConstItem = preload("res://enums/Items.gd")

var curr_items = {
	ConstItem.Items.WATERING_CAN: true,
	ConstItem.Items.SICKLE: false,
	ConstItem.Items.AXE: false,
	ConstItem.Items.HAMMER: false,
	ConstItem.Items.SCOPE: false
}

func set_items(item) -> void:
	if (curr_items[item]) :
		return
	curr_items[item] = true
