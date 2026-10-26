extends RigidBody2D

const MAX_SPEED := 420.0
const MOVE_FORCE := 2200.0
const DRAG := 1900.0
const GRAVITY_STRENGTH := 1200.0

var gravity_dir := Vector2.DOWN
var space_pressed_last := false

func _ready() -> void:
	gravity_scale = 0.0
	linear_damp = 0.2
	angular_damp = 4.0
	lock_rotation = true
	mass = 1.2
	_build_ball_shape()

func _physics_process(delta: float) -> void:
	var left := Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)
	var right := Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)
	var move_direction := int(right) - int(left)
	if move_direction != 0:
		linear_velocity.x = move_toward(linear_velocity.x, move_direction * MAX_SPEED, MOVE_FORCE * delta)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0.0, DRAG * delta)
	linear_velocity += gravity_dir * GRAVITY_STRENGTH * delta
	linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)
	linear_velocity.y = clamp(linear_velocity.y, -MAX_SPEED, MAX_SPEED)
	var space_pressed := Input.is_physical_key_pressed(KEY_SPACE)
	if space_pressed and not space_pressed_last:
		toggle_gravity()
	space_pressed_last = space_pressed

func toggle_gravity() -> void:
	gravity_dir *= -1.0

func _build_ball_shape() -> void:
	var points: PackedVector2Array = []
	for i in range(24):
		var angle := TAU * float(i) / 24.0
		points.append(Vector2(cos(angle) * 18.0, sin(angle) * 18.0))
	$Polygon2D.polygon = points
