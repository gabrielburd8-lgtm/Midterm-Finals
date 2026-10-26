extends CanvasLayer

@onready var next_button: Button = $Panel/MarginContainer/VBoxContainer/NextButton
@onready var main_menu_button: Button = $Panel/MarginContainer/VBoxContainer/MainMenuButton
@onready var level_label: Label = $Panel/LevelLabel

func _ready() -> void:
	next_button.pressed.connect(_on_next_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	visible = false

func show_complete(level_number: int) -> void:
	level_label.text = "Level %d Complete!" % level_number
	visible = true

func hide_complete() -> void:
	visible = false

func _on_next_pressed() -> void:
	get_parent().next_level()

func _on_main_menu_pressed() -> void:
	Global.load_main_menu()
