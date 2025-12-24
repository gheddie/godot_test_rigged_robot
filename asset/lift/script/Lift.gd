class_name Lift
extends CharacterBody3D

const VERTICAL_SPEED = 500.0
const INVOKE_TRESHOLD = 150.0

@onready var platform: StaticBody3D = $LiftPlatform

enum LiftAction {MOVE_UP, MOVE_DOWN, NONE}

var invokeLevel: int = 0

var action: LiftAction = LiftAction.NONE

func _physics_process(delta: float) -> void:
	match action:
		LiftAction.MOVE_DOWN:
			platform.global_position.y -= VERTICAL_SPEED * delta
	
func _process(delta: float) -> void:
	if platform.global_position.distance_to(GameSingletonInstance.player.global_position) < 5.0:
		invokeLevel += 1
	else:
		if invokeLevel > 0:
			invokeLevel -= 1
	print(invokeLevel)
	if invokeLevel >= INVOKE_TRESHOLD:
		action = LiftAction.MOVE_DOWN
		pass
