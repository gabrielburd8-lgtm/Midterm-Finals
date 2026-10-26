extends Control

@onready var play_button: Button = $Panel/MarginContainer/VBoxContainer/PlayButton
@onready var menu_button: Button = $Panel/MarginContainer/VBoxContainer/MenuButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func _on_play_pressed() -> void:
	Global.start_game()

func _on_menu_pressed() -> void:
	Global.load_main_menu()
