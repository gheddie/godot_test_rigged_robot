class_name RobotNew
extends CharacterBody3D

# const SPEED = 3.0
const SPEED = 50.0

const TURN_TRESHOLD = 0.01
const TURN_SPEED = 75.0
const CAMERA_TWEEN_SPEED = 0.75
const JUMP_VELOCITY = 5.0

var mouseMotion := Vector2.ZERO

@onready var animationTree: AnimationTree = $AnimationTree
@onready var backPosCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosCameraPivot
@onready var camera: Camera3D = $Camera3D

@onready var backPosRightCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosRightCameraPivot
@onready var rightShoulderCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/RightShoulderCameraPivot

enum MoveActionNew {WALK, NONE, TURN}

var actualMoveAction: MoveActionNew = MoveActionNew.NONE

var navigationSequence: NavigationSequence

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func handle_rotation(_delta: float) -> bool:
	var abs_rotation: float = abs(mouseMotion.x)
	if abs(mouseMotion.x) > TURN_TRESHOLD:
		rotation.y += mouseMotion.x * _delta * TURN_SPEED
		return true
	else:
		return false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouseMotion = -event.relative * 0.001		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func _process(_delta: float) -> void:
	tweenCamera(_delta)
	# print("distance -> ", str(navigationSequence.evaluateTargetDistance(self)), " --> to point --> ", str(navigationSequence.nextPointToApproach))
	# print("angle -> ", str(navigationSequence.evaluateTargetAngle(self)))
	# print("---------")
	
func tweenCamera(_delta: float) -> void:
	var tweenTarget: Node3D
	if actualMoveAction == MoveActionNew.WALK:
		# print("shoulder...")
		tweenTarget = backPosRightCameraPivot
	else:
		# print("back...")
		tweenTarget = rightShoulderCameraPivot
	if camera.global_position != tweenTarget.global_position:
		var cameraPositionTween = get_tree().create_tween()
		cameraPositionTween.tween_property(camera, "global_position", tweenTarget.global_position, CAMERA_TWEEN_SPEED)	

func _physics_process(delta: float) -> void:
	handle_rotation(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("walkBackward", "walkForward", "ui_left", "ui_right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		actualMoveAction = MoveActionNew.WALK
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		actualMoveAction = MoveActionNew.NONE
	move_and_slide()
	applyMoveAction(actualMoveAction)

func applyMoveAction(action: MoveActionNew) -> void:
	match action:
		MoveActionNew.WALK:
			walk()
		MoveActionNew.TURN:
			tipple()
		MoveActionNew.NONE:
			idle()

func walk() -> void:
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/tipple"] = false
	animationTree["parameters/conditions/walk"] = true
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/tipple"] = false
	animationTree["parameters/conditions/walk"] = false

func tipple() -> void:
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/tipple"] = true
	animationTree["parameters/conditions/walk"] = false
