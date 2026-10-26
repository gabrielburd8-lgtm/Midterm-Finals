extends CanvasLayer

@onready var level_label: Label = $Panel/LevelLabel
@onready var instructions_label: Label = $Panel/InstructionsLabel

func set_level_text(level_number: int, level_name: String) -> void:
	level_label.text = "LEVEL %d / %d — %s" % [level_number, Global.LEVEL_COUNT, level_name]

func set_instruction_text(text: String) -> void:
	instructions_label.text = text
