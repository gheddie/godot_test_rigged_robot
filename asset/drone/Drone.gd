class_name Drone
extends CharacterBody3D

# const SPEED = 25.0
const SPEED = 50.0

@onready var camera: Camera3D = $Camera3D

var navigationSequence: NavigationSequence

func _process(delta: float) -> void:
	print("distance -> ", str(navigationSequence.evaluateTargetDistance(self)), " --> to point --> ", str(navigationSequence.nextPointToApproach))
	var direction = global_position.direction_to(navigationSequence.getActualPoint())
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)		
	move_and_slide()

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	look_at(global_position + adjusted_direction, Vector3.UP, true)
