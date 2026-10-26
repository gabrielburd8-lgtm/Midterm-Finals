extends Node

const LEVEL_COUNT := 5
var current_level_index := 0

func start_game() -> void:
	current_level_index = 0
	load_level(current_level_index)

func load_level(index: int) -> void:
	current_level_index = clamp(index, 0, LEVEL_COUNT - 1)
	get_tree().change_scene_to_file("res://scenes/Level.tscn")

func load_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func load_tutorial() -> void:
	get_tree().change_scene_to_file("res://scenes/Tutorial.tscn")

func quit_game() -> void:
	get_tree().quit()
