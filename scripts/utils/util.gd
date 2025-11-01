extends Node

func encode_data(value, full_objects = false):
	return JSON.stringify(JSON.from_native(value, full_objects))

func decode_data(string, allow_objects = false):
	return JSON.to_native(JSON.parse_string(string), allow_objects)
