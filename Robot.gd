class_name Robot
extends CharacterBody3D

const WALK_SPEED = 50.0
const CAMERA_TWEEN_SPEED = 0.75

enum MoveAction {WALK_FORWARD, WALK_BACKWARD, NONE, TURN_LEFT, TURN_RIGHT}

@onready var animationTree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera3D

@onready var rightShoulderCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/RightShoulderCameraPivot
@onready var leftShoulderCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/LeftShoulderCameraPivot
@onready var backPosCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosCameraPivot
@onready var frontPosCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/FrontPosCameraPivot

@onready var topPosCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/TopPosCameraPivot

var mouse_motion := Vector2.ZERO

var actualMoveAction: MoveAction

var verticalCharacterRotation: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * 0.001		
			if mouse_motion.x >= 0.0:
				actualMoveAction = MoveAction.TURN_RIGHT
			else:
				actualMoveAction = MoveAction.TURN_LEFT
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
	tweenCamera(_delta)
	
func tweenCamera(_delta: float) -> void:
	var attributes: CameraAttributeDescriptor = getCameraAttributes(actualMoveAction)	
	if attributes == null:
		return
	var cameraPositionTween = get_tree().create_tween()
	cameraPositionTween.tween_property(camera, "global_position", attributes.position, CAMERA_TWEEN_SPEED)	
	var cameraRotationTween = get_tree().create_tween()
	cameraRotationTween.tween_property(camera, "global_rotation_degrees", attributes.rotation, CAMERA_TWEEN_SPEED)	
	
func getCameraAttributes(moveAction: MoveAction) -> CameraAttributeDescriptor:
	match moveAction:
		MoveAction.WALK_FORWARD:
			# print("MoveAction.WALK_FORWARD")
			var tmp_y: float = rotation_degrees.y-90.0
			print(str("@@@ --> ", str(tmp_y)))
			return CameraAttributeDescriptor.new(backPosCameraPivot.global_position, Vector3(0.0, tmp_y, 0.0))
		MoveAction.WALK_BACKWARD:
			# print("MoveAction.WALK_BACKWARD")
			var tmp_y: float = rotation_degrees.y+90.0
			print(str("@@@ WALK_BACKWARD --> ", str(tmp_y)))
			return CameraAttributeDescriptor.new(frontPosCameraPivot.global_position, Vector3(0.0, tmp_y, 0.0))
		MoveAction.NONE:
			# print("MoveAction.NONE")
			var tmp_y: float = rotation_degrees.y-90.0
			print(str("@@@ NONE --> ", str(tmp_y)))
			return CameraAttributeDescriptor.new(rightShoulderCameraPivot.global_position, Vector3(0.0, tmp_y, 0.0))
		MoveAction.TURN_RIGHT:
			# print("MoveAction.TURN_RIGHT")
			return null
		MoveAction.TURN_LEFT:
			# print("MoveAction.TURN_LEFT")
			return null
	return null
		
func _physics_process(delta: float) -> void:
	handle_rotation()
	if not is_on_floor():
		velocity += get_gravity() * delta
	trackWalkActionFromInput()
	var input_dir := Input.get_vector("walkBackward", "walkForward", "ui_left", "ui_right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * WALK_SPEED
		velocity.z = direction.z * WALK_SPEED
		walk(delta)
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)
		idle()
	move_and_slide()
	
func handle_rotation() -> void:
	# print(str("handle_rotation --> ", str(mouse_motion.x)))
	rotation.y += mouse_motion.x	
	# print(str("handle_rotation --> ", str(rotation.y)))
	# print(str("handle_rotation --> ", str(rad_to_deg(rotation.y))))	
	# ---
	var adjustedRotation: float = verticalCharacterRotation + rad_to_deg(mouse_motion.x)
	if adjustedRotation != verticalCharacterRotation:
		verticalCharacterRotation = adjustedRotation
		print(str("vertical character rotation --> ", str(verticalCharacterRotation)))
	
func trackWalkActionFromInput() -> void:
	if Input.is_action_pressed("walkForward"):
		actualMoveAction = MoveAction.WALK_FORWARD
	elif Input.is_action_pressed("walkBackward"):
		actualMoveAction = MoveAction.WALK_BACKWARD
	else:
		actualMoveAction = MoveAction.NONE		

func walk(_delta: float) -> void:
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/walk"] = true	
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/walk"] = false	
