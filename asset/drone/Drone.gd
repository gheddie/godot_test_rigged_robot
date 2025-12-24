class_name Drone
extends CharacterBody3D

const SPEED = 50.0
const TARGET_APPROACH_TRESHOLD = 10.0
const PROVOKE_DISTANCE = 250.0

@onready var camera: Camera3D = $Camera3D

enum DroneAction {CRUISE, ATTACK}

var navigationPath: NavigationPath
var provoked: bool = false
var targetPoint: Vector3

var action: DroneAction = DroneAction.CRUISE

func _ready() -> void:
	randomizeTarget()
	
func opponentInReach() -> bool:
	var opponentDistance = global_position.distance_to(GameSingletonInstance.player.global_position)
	print(opponentDistance)
	return opponentDistance <= PROVOKE_DISTANCE
		
func randomizeTarget() -> void:
	targetPoint = GameSingletonInstance.getRandomPoint()

func _process(delta: float) -> void:	
	"""
	if opponentInReach():
		targetPoint = GameSingletonInstance.player.global_position
	"""		
	var dist = global_position.distance_to(targetPoint)
	if dist <= TARGET_APPROACH_TRESHOLD:
		# action = DroneAction.CRUISE
		randomizeTarget()
	
func _physics_process(delta: float) -> void:
	moveAndTurnToTarget()	
		
	
func handleEnemyApproach() -> void:
	var dist = global_position.distance_to(GameSingletonInstance.player.global_position)
	if dist <= TARGET_APPROACH_TRESHOLD:
		action = DroneAction.CRUISE
		randomizeTarget()
	
func moveAndTurnToTarget() -> void:		
	var direction = global_position.direction_to(targetPoint)
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


func fire() -> void:
	print("fire...")
