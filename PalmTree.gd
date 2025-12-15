class_name PalmTree
extends StaticBody3D

@onready var animationPlayer: AnimationPlayer = $PalmTree/AnimationPlayer

func _ready() -> void:
	animationPlayer.play("swing")
