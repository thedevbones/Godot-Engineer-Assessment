extends RigidBody3D

@export var hold_strength: float = 20.0
@export var max_speed: float = 10.0

@export var held_linear_damp: float = 10.0
@export var held_angular_damp: float = 10.0

@export var rotation_strength: float = 10.0

var _held := false
var _hold_point: Marker3D = null

var _original_linear_damp: float
var _original_angular_damp: float
var _original_gravity_scale: float

func _ready() -> void:
	_original_linear_damp = linear_damp
	_original_angular_damp = angular_damp
	_original_gravity_scale = gravity_scale

func interact(hold_point: Marker3D) -> void:
	if _held:
		_release()
	else:
		_grab(hold_point)

func _grab(hold_point: Marker3D) -> void:
	_held = true
	_hold_point = hold_point

	linear_damp = held_linear_damp
	angular_damp = held_angular_damp
	gravity_scale = 0.0
	can_sleep = false
	sleeping = false

func _release() -> void:
	_held = false
	_hold_point = null

	linear_damp = _original_linear_damp
	angular_damp = _original_angular_damp
	gravity_scale = _original_gravity_scale
	can_sleep = true

func _physics_process(delta: float) -> void:
	if not _held or _hold_point == null:
		return

	# Position
	var target_pos: Vector3 = _hold_point.global_position
	var to_target: Vector3 = target_pos - global_position

	var desired_vel: Vector3 = to_target * hold_strength
	if desired_vel.length() > max_speed:
		desired_vel = desired_vel.normalized() * max_speed

	linear_velocity = linear_velocity.lerp(desired_vel, 12.0 * delta)

	# Rotation
	var camera = _hold_point.get_parent() as Camera3D
	var to_player: Vector3 = (camera.global_position - global_position).normalized()

	# desired orientation looking at player
	var target_basis = Basis.looking_at(to_player, Vector3.UP)

	var current_quat = global_transform.basis.get_rotation_quaternion()
	var target_quat = target_basis.get_rotation_quaternion()

	var rotation_delta = target_quat * current_quat.inverse()

	var axis = rotation_delta.get_axis()
	var angle = rotation_delta.get_angle()

	if angle > 0.001:
		var desired_ang_vel = axis * angle * rotation_strength
		angular_velocity = angular_velocity.lerp(desired_ang_vel, 10.0 * delta)
	else:
		angular_velocity = angular_velocity.lerp(Vector3.ZERO, 10.0 * delta)