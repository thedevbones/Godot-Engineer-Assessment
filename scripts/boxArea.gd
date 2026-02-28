extends Area3D

@onready var light = $AreaLight

func _ready() -> void:
	light.light_color = Color.WHITE

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("box"):
		return
	light.light_color = Color.PURPLE

func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("box"):
		return
	light.light_color = Color.WHITE
