class_name NPCSingleton extends Node

var npc_data : Dictionary = {}

func _load_npc_data(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)

	if not file:
		return
	var json_string = file.get_as_text()
	var parsed_result = JSON.parse_string(json_string)

	if parsed_result is Dictionary:
		npc_data = parsed_result
		print("NPC data loaded successfully.")
	else:
		push_error("JSON Parse Error: NPC data file is malformed.")
		
	pass

func get_npc(npc_name : String) -> Dictionary:
	if npc_data.has(npc_name):
		return npc_data[npc_name]
	return {}
