class_name Bullet
extends CharacterBody3D

const SPEED = 5000.0

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0.0, 0.0, -SPEED) * delta
