class_name FollowPathDrone
extends CharacterBody3D

var camera: Camera3D

func initCamera() -> void:
	camera = $Drone/Camera3D
