extends Control

@onready var play_button: Button = $Panel/MarginContainer/VBoxContainer/PlayButton
@onready var tutorial_button: Button = $Panel/MarginContainer/VBoxContainer/TutorialButton
@onready var quit_button: Button = $Panel/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	tutorial_button.pressed.connect(_on_tutorial_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	Global.start_game()

func _on_tutorial_pressed() -> void:
	Global.load_tutorial()

func _on_quit_pressed() -> void:
	Global.quit_game()
