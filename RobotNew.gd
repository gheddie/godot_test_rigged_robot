class_name RobotNew
extends CharacterBody3D

const SPEED = 12.0

var mouseMotion := Vector2.ZERO

@onready var animationTree: AnimationTree = $AnimationTree
@onready var backPosCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosCameraPivot
@onready var camera: Camera3D = $Camera3D

@onready var backPosLeftCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosLeftCameraPivot
@onready var backPosRightCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackPosRightCameraPivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# camera.global_position = backPosCameraPivot.global_position
	camera.global_position = backPosRightCameraPivot.global_position
	
func handle_rotation() -> void:
	rotation.y += mouseMotion.x
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouseMotion = -event.relative * 0.001		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	handle_rotation()
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_dir := Input.get_vector("walkBackward", "walkForward", "ui_left", "ui_right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		walk()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		idle()
	move_and_slide()

func walk() -> void:
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/walk"] = true	
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/walk"] = false	
