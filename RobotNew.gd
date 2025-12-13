class_name RobotNew
extends CharacterBody3D

const SPEED = 12.0
const TURN_TRESHOLD = 0.01

var mouseMotion := Vector2.ZERO

@onready var animationTree: AnimationTree = $AnimationTree
@onready var backPosCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosCameraPivot
@onready var camera: Camera3D = $Camera3D

@onready var backPosLeftCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosLeftCameraPivot
@onready var backPosRightCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosRightCameraPivot

enum MoveActionNew {WALK, NONE, TURN}

var actualMoveAction: MoveActionNew = MoveActionNew.NONE

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.global_position = backPosRightCameraPivot.global_position
	
func handle_rotation() -> bool:
	var abs_rotation: float = abs(mouseMotion.x)
	if abs(mouseMotion.x) > TURN_TRESHOLD:
		rotation.y += mouseMotion.x
		return true
	else:
		return false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouseMotion = -event.relative * 0.001		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var detectedMoveAction: MoveActionNew
	handle_rotation()
	"""
	if handle_rotation():
		detectedMoveAction = MoveActionNew.TURN
		return
	"""
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_dir := Input.get_vector("walkBackward", "walkForward", "ui_left", "ui_right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		detectedMoveAction = MoveActionNew.WALK
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		detectedMoveAction = MoveActionNew.NONE
	move_and_slide()
	applyMoveAction(detectedMoveAction)

func applyMoveAction(action: MoveActionNew) -> void:
	print(str("applying move action --> ", str(MoveActionNew.find_key(action))))
	match action:
		MoveActionNew.WALK:
			walk()
		MoveActionNew.TURN:
			tipple()
		MoveActionNew.NONE:
			idle()

func walk() -> void:
	# print("new robot walking...")
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/tipple"] = false
	animationTree["parameters/conditions/walk"] = true
	
func idle() -> void:
	# print("new robot idling...")
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/tipple"] = false
	animationTree["parameters/conditions/walk"] = false

func tipple() -> void:
	# print("new robot tippling...")
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/tipple"] = true
	animationTree["parameters/conditions/walk"] = false
