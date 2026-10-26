extends Node2D

const LEVELS := [
	{
		"name": "Warm Up",
		"spawn": Vector2(120, 540),
		"goal": Vector2(1120, 150),
		"platforms": [
			Rect2(0, 660, 1280, 60),
			Rect2(120, 530, 220, 22),
			Rect2(430, 470, 220, 22),
			Rect2(740, 390, 220, 22),
			Rect2(1040, 290, 180, 22),
		],
		"hazards": [
			Rect2(340, 660, 90, 18),
			Rect2(660, 660, 100, 18),
		],
	},
	{
		"name": "Low Orbit",
		"spawn": Vector2(90, 550),
		"goal": Vector2(1090, 170),
		"platforms": [
			Rect2(0, 660, 1280, 60),
			Rect2(170, 560, 180, 22),
			Rect2(430, 490, 160, 22),
			Rect2(710, 440, 180, 22),
			Rect2(960, 330, 180, 22),
			Rect2(560, 250, 180, 22),
		],
		"hazards": [
			Rect2(355, 660, 105, 18),
			Rect2(600, 660, 95, 18),
			Rect2(875, 660, 110, 18),
		],
	},
	{
		"name": "Switchback",
		"spawn": Vector2(120, 600),
		"goal": Vector2(1090, 200),
		"platforms": [
			Rect2(0, 660, 1280, 60),
			Rect2(130, 610, 180, 22),
			Rect2(400, 520, 180, 22),
			Rect2(700, 620, 220, 22),
			Rect2(970, 510, 180, 22),
			Rect2(760, 340, 160, 22),
			Rect2(470, 220, 150, 22),
		],
		"hazards": [
			Rect2(310, 660, 105, 18),
			Rect2(590, 660, 100, 18),
			Rect2(900, 660, 120, 18),
		],
	},
	{
		"name": "Gravity Maze",
		"spawn": Vector2(120, 610),
		"goal": Vector2(1120, 120),
		"platforms": [
			Rect2(0, 660, 1280, 60),
			Rect2(120, 590, 150, 22),
			Rect2(330, 520, 170, 22),
			Rect2(690, 510, 160, 22),
			Rect2(910, 400, 160, 22),
			Rect2(650, 250, 170, 22),
			Rect2(980, 200, 140, 22),
			Rect2(300, 170, 150, 22),
		],
		"hazards": [
			Rect2(270, 660, 150, 18),
			Rect2(540, 660, 120, 18),
			Rect2(850, 660, 130, 18),
		],
	},
	{
		"name": "Final Shift",
		"spawn": Vector2(100, 610),
		"goal": Vector2(1150, 120),
		"platforms": [
			Rect2(0, 660, 1280, 60),
			Rect2(120, 590, 150, 22),
			Rect2(360, 520, 150, 22),
			Rect2(580, 430, 140, 22),
			Rect2(795, 340, 150, 22),
			Rect2(1015, 260, 160, 22),
			Rect2(830, 170, 180, 22),
			Rect2(490, 180, 180, 22),
			Rect2(240, 260, 140, 22),
		],
		"hazards": [
			Rect2(260, 660, 100, 18),
			Rect2(500, 660, 110, 18),
			Rect2(750, 660, 100, 18),
			Rect2(950, 660, 100, 18),
		],
	},
]

@onready var world: Node2D = $World
@onready var hud: CanvasLayer = $HUD
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var level_complete: CanvasLayer = $LevelComplete
@onready var camera_2d: Camera2D = $Camera2D

var ball: RigidBody2D
var level_index: int
var level_data: Dictionary
var completed := false
var paused := false
var ball_scene: PackedScene = preload("res://scenes/Ball.tscn")

func _ready() -> void:
	level_index = Global.current_level_index
	level_data = LEVELS[level_index]
	build_background()
	build_level_geometry()
	spawn_ball()
	hud.set_level_text(level_index + 1, level_data["name"])
	hud.set_instruction_text("Move with A/D or arrow keys. Press Space to flip gravity. Press R to reset.")
	pause_menu.hide_pause()
	level_complete.hide_complete()
	get_tree().paused = false
	camera_2d.position = Vector2(640, 360)
	camera_2d.make_current()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			toggle_pause()
		elif event.keycode == KEY_R:
			reset_level()

func build_background() -> void:
	var background = Polygon2D.new()
	background.color = Color(0.04, 0.10, 0.18, 1.0)
	background.polygon = PackedVector2Array([
		Vector2(0, 0),
		Vector2(1280, 0),
		Vector2(1280, 720),
		Vector2(0, 720),
	])
	world.add_child(background)

func build_level_geometry() -> void:
	for platform in level_data["platforms"]:
		create_platform(platform)
	for hazard in level_data["hazards"]:
		create_hazard(hazard)
	create_goal(level_data["goal"])

func create_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	body.add_child(shape)
	var polygon := Polygon2D.new()
	polygon.color = Color(0.18, 0.42, 0.62, 1.0)
	polygon.polygon = PackedVector2Array([
		Vector2(-rect.size.x / 2.0, -rect.size.y / 2.0),
		Vector2(rect.size.x / 2.0, -rect.size.y / 2.0),
		Vector2(rect.size.x / 2.0, rect.size.y / 2.0),
		Vector2(-rect.size.x / 2.0, rect.size.y / 2.0),
	])
	body.add_child(polygon)
	body.position = rect.position + rect.size / 2.0
	world.add_child(body)

func create_hazard(rect: Rect2) -> void:
	var hazard := Area2D.new()
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	hazard.add_child(shape)
	var polygon := Polygon2D.new()
	polygon.color = Color(0.93, 0.28, 0.30, 1.0)
	polygon.polygon = PackedVector2Array([
		Vector2(-rect.size.x / 2.0, -rect.size.y / 2.0),
		Vector2(rect.size.x / 2.0, -rect.size.y / 2.0),
		Vector2(rect.size.x / 2.0, rect.size.y / 2.0),
		Vector2(-rect.size.x / 2.0, rect.size.y / 2.0),
	])
	hazard.add_child(polygon)
	hazard.position = rect.position + rect.size / 2.0
	hazard.body_entered.connect(_on_hazard_body_entered)
	world.add_child(hazard)

func create_goal(position: Vector2) -> void:
	var goal := Area2D.new()
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = Vector2(48, 48)
	shape.shape = box
	goal.add_child(shape)
	goal.position = position
	var polygon := Polygon2D.new()
	polygon.color = Color(0.85, 0.93, 0.42, 1.0)
	polygon.polygon = PackedVector2Array([
		Vector2(-24, -24),
		Vector2(24, -24),
		Vector2(24, 24),
		Vector2(-24, 24),
	])
	goal.add_child(polygon)
	goal.body_entered.connect(_on_goal_body_entered)
	world.add_child(goal)

func spawn_ball() -> void:
	if ball != null:
		ball.queue_free()
	ball = ball_scene.instantiate()
	ball.position = level_data["spawn"]
	world.add_child(ball)
	ball.linear_velocity = Vector2.ZERO

func _on_hazard_body_entered(body: Node) -> void:
	if body == ball:
		reset_level()

func _on_goal_body_entered(body: Node) -> void:
	if body == ball and not completed:
		complete_level()

func complete_level() -> void:
	completed = true
	ball.linear_velocity = Vector2.ZERO
	ball.set_physics_process(false)
	if level_index >= Global.LEVEL_COUNT - 1:
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
		return
	level_complete.show_complete(level_index + 1)
	level_complete.visible = true
	get_tree().paused = true

func toggle_pause() -> void:
	if completed:
		return
	paused = !paused
	get_tree().paused = paused
	if paused:
		pause_menu.show_pause()
	else:
		pause_menu.hide_pause()

func reset_level() -> void:
	if completed:
		return
	spawn_ball()
	get_tree().paused = false
	paused = false
	pause_menu.hide_pause()

func next_level() -> void:
	if completed:
		Global.current_level_index = min(Global.current_level_index + 1, Global.LEVEL_COUNT - 1)
		Global.load_level(Global.current_level_index)
		return
	Global.current_level_index = min(Global.current_level_index + 1, Global.LEVEL_COUNT - 1)
	Global.load_level(Global.current_level_index)
