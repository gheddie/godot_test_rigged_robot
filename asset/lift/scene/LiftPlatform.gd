class_name LiftPlatform
extends StaticBody3D

const TRIGGER_DISTANCE = 5.0
const INVOKE_TRIGGER = 150

var invokementValue: int = 0

func _process(delta: float) -> void:
	var distance: float = global_position.distance_to(PlayerAccessInstance.player.global_position)
	# print(distance)
	if distance <= TRIGGER_DISTANCE:
		invokementValue += 1.0
	else:
		if invokementValue >= 0.0:
			invokementValue -= 1.0	
	print(invokementValue)
	if invokementValue >= INVOKE_TRIGGER:
		pass 
