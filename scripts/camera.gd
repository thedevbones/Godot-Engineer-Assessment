extends Camera3D

@onready var head = get_parent() as Node3D
@onready var body = head.get_parent() as CharacterBody3D
@onready var raycast = $RayCast3D
@onready var hold_point = $HoldPoint
@onready var pickup_sfx = $Pickup

var held_object: Node = null
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
	if Input.is_action_just_pressed("interact"):
		interact()

func _process(delta: float) -> void:
	rotation_velocity = rotation_velocity.lerp(camera_input * sensitivity, smoothness * delta)
	body.rotate_y(deg_to_rad(-rotation_velocity.x))
	rotate_x(deg_to_rad(-rotation_velocity.y))
	rotation_degrees.x = clamp(rotation_degrees.x, -85, 85)
	camera_input = Vector2.ZERO

func interact() -> void:
	raycast.force_raycast_update()
	if held_object:
		held_object.interact(hold_point)
		held_object = null
		play_sfx(0.9)
		return
	if not raycast.is_colliding():
		return
	var collider := raycast.get_collider() as Node
	if not collider.has_method("interact"):
		return
	collider.interact(hold_point)
	play_sfx(1.0)
	pickup_sfx.play()
	held_object = collider

func play_sfx(pitch: float) -> void:
	pickup_sfx.pitch_scale = pitch
	pickup_sfx