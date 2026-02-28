extends Area3D

@export var force_field : StaticBody3D
@onready var light = $AreaLight
@onready var sfx = $SFX

func _ready() -> void:
	light.light_color = Color.WHITE

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("box"):
		return
	light.light_color = Color.PURPLE
	force_field.collision_layer = 0
	force_field.hide()
	sfx.pitch_scale = 1.0
	sfx.play()

func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("box"):
		return
	light.light_color = Color.WHITE
	force_field.collision_layer = 3
	force_field.show()
	sfx.pitch_scale = 0.8
	sfx.play()