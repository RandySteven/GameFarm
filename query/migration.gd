extends Node

@export var create_player_table = "
	CREATE TABLE IF NOT EXISTS player (
		id INT PRIMARY KEY,
		name TEXT NOT NULL,
		stamina INT DEFAULT 10
	)
"

@export var create_item_table = "
	CREATE TABLE IF NOT EXISTS items (
		id INT PRIMARY KEY,
		name TEXT NOT NULL,
		buy_price INT NOT NULL,
		sell_price INT NOT NULL
	)
"

@export var create_npc_table = "
	CREATE TABLE IF NOT EXISTS npcs (
		id INT PRIMARY KEY,
		name TEXT NOT NULL,
		birthday_date INT NOT NULL,
		birthday_season TEXT NOT NULL,
		relation_level INT DEFAULT 0
	)
"

@export var create_event_table = "
	CREATE TABLE IF NOT EXISTS events (
		id INT PRIMARY KEY,
	)
"
