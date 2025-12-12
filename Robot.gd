class_name Robot
extends CharacterBody3D

const SPEED = 25.0

enum WalkAction {FORWARD, BACKWARD, NONE}

@onready var animationTree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera3D

@onready var shoulderCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/ShoulderCameraPivot
@onready var backposCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosCameraPivot
@onready var frontposCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/FrontPosCameraPivot

var walking: bool = false
var actualWalkAction: WalkAction

func _ready() -> void:
	print(str("shoulderCameraPivot.rotation.y --> ", str(rad_to_deg(shoulderCameraPivot.rotation.y))))
	print(str("backposCameraPivot.rotation.y --> ", str(rad_to_deg(backposCameraPivot.rotation.y))))
	print(str("frontposCameraPivot.rotation.y --> ", str(rad_to_deg(frontposCameraPivot.rotation.y))))
	
func _process(_delta: float) -> void:
	tweenCamera(_delta)
	
func tweenCamera(_delta: float) -> void:
	
	var desiredCamPos = Vector3.ZERO
	var desiredCamRotation: float = 0.0
	
	match actualWalkAction:
		WalkAction.FORWARD:
			print(str(WalkAction.FORWARD))
		WalkAction.BACKWARD:
			print(str(WalkAction.BACKWARD))
		WalkAction.NONE:
			print(str(WalkAction.NONE))
	
	if walking:
		desiredCamPos = backposCameraPivot.global_position
		desiredCamRotation = -90.0
	else:
		desiredCamPos = shoulderCameraPivot.global_position
		desiredCamRotation = -90.0
		
	var cameraTween = get_tree().create_tween()
	cameraTween.tween_property(camera, "global_position", desiredCamPos, 1.0)
	cameraTween.tween_property(camera, "rotation_degrees", desiredCamRotation, 1.0)
		
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
		walking = false
	move_and_slide()
	
func trackWalkAction() -> void:
	if Input.is_action_pressed("walkForward"):
		actualWalkAction = WalkAction.FORWARD
	elif Input.is_action_pressed("walkBackward"):
		actualWalkAction = WalkAction.BACKWARD
	else:
		actualWalkAction = WalkAction.NONE

func walk(_delta: float) -> void:
	walking = true
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/walk"] = true	
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/walk"] = false	
