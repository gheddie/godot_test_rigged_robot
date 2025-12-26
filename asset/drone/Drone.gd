class_name Drone
extends CharacterBody3D

# const SPEED = 50.0
const SPEED = 10.0

const TARGET_APPROACH_TRESHOLD = 10.0
const ATTACK_DISTANCE = 100.0

@onready var camera: Camera3D = $Camera3D

enum DroneAction {CRUISE, ATTACK}

var navigationPath: NavigationPath
var provoked: bool = false
var targetPoint: Vector3

var action: DroneAction = DroneAction.CRUISE

@onready var stateLabel: Label = $GridContainer/StateLabel

@onready var fireTimer: Timer = $FireTimer

@onready var weapon1: DroneWeapon = $Weapon1
@onready var weapon2: DroneWeapon = $Weapon2

func _ready() -> void:
	randomizeTarget()
	
func opponentInAttackDistance() -> bool:
	var opponentDistance = global_position.distance_to(GameSingletonInstance.player.global_position)
	print(opponentDistance)
	return opponentDistance <= ATTACK_DISTANCE
		
func randomizeTarget() -> void:
	targetPoint = GameSingletonInstance.getRandomPoint()

func _process(delta: float) -> void:
	checkFireTimer()
	updateStateLabel()
	if action == DroneAction.ATTACK:
		if opponentInAttackDistance():
			print(str("dist to player (PEW PEW) --> ", str(global_position.distance_to(GameSingletonInstance.player.global_position))))
		else:
			print(str("dist to player --> ", str(global_position.distance_to(GameSingletonInstance.player.global_position))))
	"""
	if opponentInReach():
		targetPoint = GameSingletonInstance.player.global_position
	"""		
	var dist = global_position.distance_to(targetPoint)
	if dist <= TARGET_APPROACH_TRESHOLD:
		action = DroneAction.CRUISE
		randomizeTarget()
		
func checkFireTimer() -> void:
	if fireTimer.is_stopped():
		fireTimer.start()
		
func updateStateLabel() -> void:
	match action:
		DroneAction.CRUISE:
			stateLabel.text = "cruising"
		DroneAction.ATTACK:
			stateLabel.text = "attacking"
	
func _physics_process(delta: float) -> void:
	if action == DroneAction.ATTACK:
		var directionToPlayer = global_position.direction_to(GameSingletonInstance.player.global_position)
		# print(str("dir to player --> ", str(directionToPlayer)))
		# tween rotation to player
		# create_tween().tween_property(self, "global_rotation", directionToPlayer, 5.0)
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
	weapon1.fire()
	weapon2.fire()

func attack() -> void:
	print("attack...")
	action = DroneAction.ATTACK
	targetPoint = GameSingletonInstance.getPlayerPosition()


func onFireTimer() -> void:
	if action == DroneAction.ATTACK && opponentInAttackDistance():
		fire()
