extends RigidBody3D

@export var hold_strength: float = 100.0
@export var max_speed: float = 10.0
@export var held_linear_damp: float = 10.0
@export var held_angular_damp: float = 10.0
@export var rotation_strength: float = 100.0

var _held := false
var _hold_point: Marker3D = null
var _camera: Camera3D = null

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
	_camera = hold_point.get_parent() as Camera3D

	linear_damp = held_linear_damp
	angular_damp = held_angular_damp
	gravity_scale = 0.0
	can_sleep = false
	sleeping = false

func _release() -> void:
	_held = false
	_hold_point = null
	_camera = null
	linear_damp = _original_linear_damp
	angular_damp = _original_angular_damp
	gravity_scale = _original_gravity_scale
	can_sleep = true

func _physics_process(delta: float) -> void:
	if not _held or _hold_point == null:
		return

	# Position
	var target_position: Vector3 = _hold_point.global_position
	var to_target: Vector3 = target_position - global_position

	var desired_velocity: Vector3 = to_target * hold_strength
	desired_velocity -= linear_velocity * 6.0 

	if desired_velocity.length() > max_speed:
		desired_velocity = desired_velocity.normalized() * max_speed

	linear_velocity = linear_velocity.lerp(desired_velocity, 12.0 * delta)

	# Rotation
	var target_rotation: Basis = Basis.looking_at(_camera.global_transform.origin - global_transform.origin, Vector3.UP)
	var to_target_rotation: Basis = target_rotation * global_transform.basis.inverse()
	var desired_angular_velocity: Vector3 = to_target_rotation.get_euler() * rotation_strength

	angular_velocity = angular_velocity.lerp(desired_angular_velocity, 12.0 * delta)