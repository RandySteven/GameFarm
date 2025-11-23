extends Node

func encode_data(value, full_objects = false):
	return JSON.stringify(JSON.from_native(value, full_objects))

func decode_data(string, allow_objects = false):
	return JSON.to_native(JSON.parse_string(string), allow_objects)

func save_game_data(data : Dictionary, file_path : String = "user://save_data.json"):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data)
		file.store_line(json_string)
		file.close()
	else:
		push_error("Failed to save")
		
func load_game_data(file_path : String = "user://save_data.json"):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file and FileAccess.file_exists(file_path):
		var loaded_data = file.get_var()
		file.close()
		return loaded_data
	else:
		push_error("Failed to load data")
		return {}

func save_config(config_data: Dictionary, file_path: String):
	var config_file = ConfigFile.new()
	for section in config_data.keys():
		for key in config_data[section].keys():
			config_file.set_value(section, key, config_data[section][key])
	var error = config_file.save(file_path)
	if error != OK:
		print("Error saving config file: ", error)
		
func load_config(file_path: String) -> Dictionary:
	var config_file = ConfigFile.new()
	var error = config_file.load(file_path)
	if error == OK:
		var loaded_data = {}
		for section in config_file.get_sections():
			loaded_data[section] = {}
			for key in config_file.get_section_keys(section):
				loaded_data[section][key] = config_file.get_value(section, key)
		return loaded_data
	else:
		print("Error loading config file or file not found: ", error)
		return {}

func save_resource(resource: Resource, file_path: String):
	var error = ResourceSaver.save(resource, file_path)
	if error != OK:
		print("Error saving resource: ", error)

func load_resource(file_path: String) -> Resource:
	if ResourceLoader.exists(file_path):
		return ResourceLoader.load(file_path)
	else:
		print("Resource file not found: ", file_path)
		return null
