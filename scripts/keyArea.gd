extends Area3D

@export var door : Node3D
@onready var physics_door = door.get_node("PhysicsDoor") as RigidBody3D
@onready var light = $AreaLight
@onready var sfx = $SFX

func _ready() -> void:
	light.light_color = Color.WHITE

func _on_body_entered(body: Node3D) -> void:
	print("Body entered key area: ", body.name)
	if not body.is_in_group("key"):
		return
	light.light_color = Color.GREEN
	physics_door.unlock()
	sfx.play()
	
func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("key"):
		return
	light.light_color = Color.WHITE
