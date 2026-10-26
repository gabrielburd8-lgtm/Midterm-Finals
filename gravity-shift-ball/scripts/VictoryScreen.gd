extends Control

@onready var play_again_button: Button = $Panel/MarginContainer/VBoxContainer/PlayAgainButton
@onready var main_menu_button: Button = $Panel/MarginContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _on_play_again_pressed() -> void:
	Global.start_game()

func _on_main_menu_pressed() -> void:
	Global.load_main_menu()
