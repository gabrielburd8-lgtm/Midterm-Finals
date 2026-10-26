extends CanvasLayer

@onready var resume_button: Button = $Panel/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = $Panel/MarginContainer/VBoxContainer/RestartButton
@onready var main_menu_button: Button = $Panel/MarginContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	visible = false

func show_pause() -> void:
	visible = true

func hide_pause() -> void:
	visible = false

func _on_resume_pressed() -> void:
	get_parent().toggle_pause()

func _on_restart_pressed() -> void:
	get_parent().reset_level()

func _on_main_menu_pressed() -> void:
	Global.load_main_menu()
