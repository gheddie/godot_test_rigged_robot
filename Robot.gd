class_name Robot
extends CharacterBody3D

const SPEED = 5.0
const CAMERA_TWEEN_SPEED = 0.75

enum MoveAction {WALK_FORWARD, WALK_BACKWARD, NONE}

@onready var animationTree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera3D

@onready var shoulderCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/ShoulderCameraPivot
@onready var backposCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosCameraPivot
@onready var frontposCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/FrontPosCameraPivot

var actualMoveAction: MoveAction

func _process(_delta: float) -> void:
	tweenCamera(_delta)
	
func tweenCamera(_delta: float) -> void:
	var attributes: CameraAttributeDescriptor = getCameraAttributes(actualMoveAction)	
	var cameraPositionTween = get_tree().create_tween()
	cameraPositionTween.tween_property(camera, "global_position", attributes.position, CAMERA_TWEEN_SPEED)	
	var cameraRotationTween = get_tree().create_tween()
	cameraRotationTween.tween_property(camera, "global_rotation_degrees", attributes.rotation, CAMERA_TWEEN_SPEED)	
	
func getCameraAttributes(moveAction: MoveAction) -> CameraAttributeDescriptor:
	match moveAction:
		MoveAction.WALK_FORWARD:
			return CameraAttributeDescriptor.new(backposCameraPivot.global_position, Vector3(0.0, -90.0, 0.0))
		MoveAction.WALK_BACKWARD:
			return CameraAttributeDescriptor.new(frontposCameraPivot.global_position, Vector3(0.0,90.0, 0.0))
		MoveAction.NONE:
			return CameraAttributeDescriptor.new(shoulderCameraPivot.global_position, Vector3(0.0, -90.0, 0.0))
	return null			
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	trackWalkAction()
	var input_dir := Input.get_vector("walkBackward", "walkForward", "ui_left", "ui_right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		walk(delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		idle()
	move_and_slide()
	
func trackWalkAction() -> void:
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
