class_name DroneWeapon
extends Node3D

@onready var trigger: Node3D = $Trigger

var bullet: PackedScene = preload("res://asset/bullet/Bullet.tscn")	

func fire() -> void:
	var bulletInstance = bullet.instantiate()
	bulletInstance.position = trigger.global_position
	bulletInstance.transform.basis = trigger.global_transform.basis
	get_tree().get_current_scene().add_child(bulletInstance)	
