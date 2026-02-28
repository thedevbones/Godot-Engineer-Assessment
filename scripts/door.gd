# heavily modifed version of https://www.youtube.com/watch?v=QrfMWdMe7pg
extends "res://scripts/grabbable.gd"

@export var hinge : HingeJoint3D
@export var swing_strength: float = 1000.0
var unlocked := false

func interact(hold_point: Marker3D) -> void:
	if not unlocked:
		return
	if _held:
		_release()
	else:
		_grab(hold_point)

func unlock() -> void:
	unlocked = true
	
func _physics_process(delta: float) -> void:
	if not _held:
		return
	var forceDirection = _hold_point.global_transform.origin - global_transform.origin
	forceDirection = forceDirection.normalized() * swing_strength
 
	apply_central_force(forceDirection * delta)
