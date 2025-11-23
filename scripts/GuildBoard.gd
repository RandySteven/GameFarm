class_name GuildBoard extends Node

@onready var area2D = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var quest_panel = $CanvasLayer/QuestPanel
@onready var quest_label = $CanvasLayer/QuestPanel/VBoxContainer/QuestLabel

var player_in_range: bool = false
var quests: Array = []
var is_panel_visible: bool = false

func _ready():
	_load_quests()
	_hide_quest_panel()
	if $CanvasLayer:
		$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and is_panel_visible:
			_hide_quest_panel()
			get_viewport().set_input_as_handled()
		elif player_in_range and event.keycode == KEY_ENTER:
			_on_enter_pressed()
			get_viewport().set_input_as_handled()

func _load_quests() -> void:
	var file = FileAccess.open("res://assets/json/quests.json", FileAccess.READ)
	if file == null:
		push_error("Failed to load quests.json")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("Failed to parse quests.json: " + json.get_error_message())
		return
	
	quests = json.get_data()
	print("Loaded ", quests.size(), " quests")

func _on_enter_pressed() -> void:
	if is_panel_visible:
		_hide_quest_panel()
	else:
		_show_quest_panel()

func _show_quest_panel() -> void:
	if quest_panel:
		_display_quests()
		quest_panel.visible = true
		is_panel_visible = true
		get_tree().paused = true

func _hide_quest_panel() -> void:
	if quest_panel:
		quest_panel.visible = false
		is_panel_visible = false
		get_tree().paused = false

func _display_quests() -> void:
	if not quest_label:
		return
	
	var quest_text = "=== GUILD BOARD QUESTS ===\n\n"
	
	if quests.is_empty():
		quest_text += "No quests available at this time.\n"
	else:
		for i in range(quests.size()):
			var quest = quests[i]
			var quest_name = quest.get("name", "Unknown Quest")
			var quest_reward = quest.get("reward", "No reward")
			var status = quest.get("status", "TO DO")
			quest_text += _quest_string(quest_name, quest_reward, status)
	
	quest_text += "\nPress ESC to close"
	quest_label.text = quest_text

func _quest_string(quest_name : String, quest_reward : String, status : String) -> String:
	var quest_str = ""
	quest_str = "Quest: %s\n" % quest_name
	quest_str = "  Reward: %s\n\n" % quest_reward
	quest_str = "Status: %s\n\n" % status
	return quest_str

func _on_area_2d_body_entered(body):
	print("masuk ke range ", body)
	if body is Player:
		player_in_range = true

func _on_area_2d_body_exited(body):
	print("keluar dari range ", body)
	if body is Player:
		player_in_range = false
		if is_panel_visible:
			_hide_quest_panel()
