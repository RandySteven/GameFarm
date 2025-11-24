class_name MainMenu extends Node

@onready var saved_list_panel = $CanvasLayer/SavedListPanel
@onready var slot_container = $CanvasLayer/SavedListPanel/MarginContainer/VBoxContainer/ScrollContainer/SlotContainer
@onready var title_label = $CanvasLayer/SavedListPanel/MarginContainer/VBoxContainer/TitleLabel
@onready var confirm_panel = $CanvasLayer/ConfirmFormPanel
@onready var confirm_label = $CanvasLayer/ConfirmFormPanel/MarginContainer/VBoxContainer/Label
@onready var confirm_yes_button = $CanvasLayer/ConfirmFormPanel/MarginContainer/VBoxContainer/HBoxContainer/YesButton
@onready var confirm_no_button = $CanvasLayer/ConfirmFormPanel/MarginContainer/VBoxContainer/HBoxContainer/NoButton
@onready var cancel_button = $CanvasLayer/SavedListPanel/MarginContainer/VBoxContainer/CancelButton

var saved_slot_obj = {}
var selected_slot: int = -1
var is_new_game_mode: bool = false
var slot_buttons: Array[Button] = []

func _ready():
	display_saved_list_panel(false)
	display_confirm_panel(false)
	load_save_file()
	_setup_confirm_buttons()

func _setup_confirm_buttons():
	if confirm_yes_button:
		confirm_yes_button.pressed.connect(_on_confirm_yes)
	if confirm_no_button:
		confirm_no_button.pressed.connect(_on_confirm_no)

func _on_new_game_button_pressed() -> void:
	is_new_game_mode = true
	load_save_file()
	display_saved_list_panel(true)
	populate_save_slots()

func _on_load_game_button_pressed() -> void:
	is_new_game_mode = false
	load_save_file()
	display_saved_list_panel(true)
	populate_save_slots()

func _on_setting_button_pressed() -> void:
	print("setting")

func _on_exit_button_pressed() -> void:
	get_tree().quit(0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if confirm_panel and confirm_panel.visible:
				_on_confirm_no()
				get_viewport().set_input_as_handled()
			elif saved_list_panel and saved_list_panel.visible:
				_on_cancel_button_pressed()
				get_viewport().set_input_as_handled()

func _on_cancel_button_pressed() -> void:
	display_saved_list_panel(false)
	selected_slot = -1

func _on_confirm_yes() -> void:
	display_confirm_panel(false)
	if selected_slot >= 0:
		if is_new_game_mode:
			create_new_save(selected_slot)
		else:
			load_existing_save(selected_slot)
	# Reset confirm button text and visibility
	if confirm_no_button:
		confirm_no_button.text = "No"
	if confirm_yes_button:
		confirm_yes_button.visible = true

func _on_confirm_no() -> void:
	display_confirm_panel(false)
	selected_slot = -1
	# Reset confirm button text and visibility
	if confirm_no_button:
		confirm_no_button.text = "No"
	if confirm_yes_button:
		confirm_yes_button.visible = true

func display_saved_list_panel(is_display: bool):
	if saved_list_panel:
		saved_list_panel.visible = is_display
		get_tree().paused = is_display
		if not is_display:
			selected_slot = -1

func display_confirm_panel(is_display: bool):
	if confirm_panel:
		confirm_panel.visible = is_display

func populate_save_slots():
	if not slot_container:
		return
	
	# Update title based on mode
	if title_label:
		if is_new_game_mode:
			title_label.text = "Select Save Slot - New Game"
		else:
			title_label.text = "Select Save Slot - Load Game"
	
	# Clear existing buttons
	for button in slot_buttons:
		if is_instance_valid(button):
			button.queue_free()
	slot_buttons.clear()
	
	var max_slots = saved_slot_obj.get("max_slot", 10)
	
	for i in range(max_slots):
		var slot_data = get_slot_data(i)
		var slot_button = create_slot_button(i, slot_data)
		slot_container.add_child(slot_button)
		slot_buttons.append(slot_button)

func create_slot_button(slot_index: int, slot_data: Dictionary) -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(600, 80)
	button.text = format_slot_text(slot_index, slot_data)
	
	# Style empty vs filled slots
	if slot_data.is_empty:
		button.modulate = Color(0.7, 0.7, 0.7, 1.0)
	else:
		button.modulate = Color.WHITE
	
	# Connect signal
	button.pressed.connect(_on_slot_selected.bind(slot_index))
	
	return button

func format_slot_text(slot_index: int, slot_data: Dictionary) -> String:
	var slot_num = slot_index + 1
	if slot_data.is_empty:
		return "Slot %d - Empty Slot" % slot_num
	else:
		var character_name = slot_data.get("character_name", "Unknown")
		var farm_name = slot_data.get("farm_name", "Unknown Farm")
		var save_date = slot_data.get("save_date", "Unknown Date")
		return "Slot %d - %s | Farm: %s | Saved: %s" % [slot_num, character_name, farm_name, save_date]

func get_slot_data(slot_index: int) -> Dictionary:
	var slot_file_name = "user://save_game_farm_slot_%d.dat" % slot_index
	if not FileAccess.file_exists(slot_file_name):
		return {"is_empty": true}
	
	var file = FileAccess.open(slot_file_name, FileAccess.READ)
	if file == null:
		return {"is_empty": true}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		return {"is_empty": true}
	
	var data = json.get_data()
	if data.is_empty:
		return {"is_empty": true}
	
	data["is_empty"] = false
	return data

func _on_slot_selected(slot_index: int):
	selected_slot = slot_index
	var slot_data = get_slot_data(slot_index)
	
	if is_new_game_mode:
		# New game - check if slot is occupied
		if not slot_data.is_empty:
			# Show confirmation for overwrite
			confirm_label.text = "Slot %d already has a save file.\nOverwrite existing save?" % (slot_index + 1)
			# Reset button states
			if confirm_yes_button:
				confirm_yes_button.visible = true
			if confirm_no_button:
				confirm_no_button.text = "No"
			display_confirm_panel(true)
		else:
			# Empty slot, proceed directly
			create_new_save(slot_index)
	else:
		# Load game - check if slot has data
		if slot_data.is_empty:
			# Show error message
			confirm_label.text = "Slot %d is empty.\nCannot load this save." % (slot_index + 1)
			if confirm_yes_button:
				confirm_yes_button.visible = false
			if confirm_no_button:
				confirm_no_button.text = "OK"
			display_confirm_panel(true)
		else:
			# Load the save
			load_existing_save(slot_index)

func create_new_save(slot: int):
	var slot_file_name = "user://save_game_farm_slot_%d.dat" % slot
	var save_data = {
		"slot": slot,
		"character_name": "",
		"farm_name": "",
		"save_date": Time.get_datetime_string_from_system(),
		"game_data": {}
	}
	
	var file = FileAccess.open(slot_file_name, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data)
		file.store_string(json_string)
		file.close()
	
	# Store selected slot for character creation
	# You can use an autoload singleton or global variable to pass this
	# For now, we'll use a simple approach
	display_saved_list_panel(false)
	get_tree().change_scene_to_file("res://scenes/create_character_menu.tscn")

func load_existing_save(slot: int):
	var slot_file_name = "user://save_game_farm_slot_%d.dat" % slot
	var file = FileAccess.open(slot_file_name, FileAccess.READ)
	
	if file == null:
		push_error("Failed to load save file: " + slot_file_name)
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("Failed to parse save file")
		return
	
	var save_data = json.get_data()
	display_saved_list_panel(false)
	
	# Load the game scene with save data
	# You'll need to implement the actual game loading logic here
	print("Loading save slot %d: %s" % [slot, save_data.get("character_name", "Unknown")])
	# Example: get_tree().change_scene_to_file("res://scenes/player_farm.tscn")
	
func load_save_file():
	var saved_slot_json_file = FileAccess.open("res://assets/json/saves/save_slots.json", FileAccess.READ)
	
	if saved_slot_json_file == null:
		push_error("failed to load saved_slot_json")
		# Create default structure
		saved_slot_obj = {"max_slot": 10, "slots": []}
		return

	var json_str = saved_slot_json_file.get_as_text()
	saved_slot_json_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_str)

	if parse_result != OK:
		push_error("json format is not correct")
		saved_slot_obj = {"max_slot": 10, "slots": []}
		return
	
	saved_slot_obj = json.get_data()
	
	# Ensure max_slot exists
	if not saved_slot_obj.has("max_slot"):
		saved_slot_obj["max_slot"] = 10
