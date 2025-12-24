class_name LiftPlatform
extends StaticBody3D

const TRIGGER_DISTANCE = 5.0
const INVOKE_TRIGGER = 250

var invokementValue: int = 0

var lift: StackedLift

func _process(delta: float) -> void:
	lift.onProcess(delta)
	var distance: float = global_position.distance_to(GameSingletonInstance.player.global_position)
	if distance <= TRIGGER_DISTANCE and !lift.isMoving():
		invokementValue += 1.0
	else:
		if invokementValue >= 0.0:
			invokementValue -= 1.0	
	if invokementValue >= INVOKE_TRIGGER:
		lift.platformInvoked()

func rise(_delta: float) -> void:
	print("rising...")
	global_position.y += lift.verticalSpeed * _delta
	lift.platformMoved(global_position)
	pass
	
func fall(_delta: float) -> void:
	print("falling...")
	global_position.y -= lift.verticalSpeed * _delta
	lift.platformMoved(global_position)
	pass
