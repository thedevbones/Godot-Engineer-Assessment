extends Camera3D

@onready var head = get_parent() as Node3D
@onready var body = head.get_parent() as CharacterBody3D

var rotation_velocity := Vector2.ZERO
var camera_input := Vector2.ZERO
var sensitivity := 0.1
var smoothness := 20.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if not current:
		return
	if event is InputEventMouseMotion:
		camera_input = event.relative

func _process(delta: float) -> void:
	rotation_velocity = rotation_velocity.lerp(camera_input * sensitivity, smoothness * delta)
	body.rotate_y(deg_to_rad(-rotation_velocity.x))
	rotate_x(deg_to_rad(-rotation_velocity.y))
	rotation_degrees.x = clamp(rotation_degrees.x, -85, 85)
	camera_input = Vector2.ZERO
