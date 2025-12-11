class_name Robot
extends CharacterBody3D

const SPEED = 25.0

@onready var animationTree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera3D

@onready var alteredCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/AlteredCameraPivot
@onready var backposCameraPivot: Node3D = $TestRiggedRobot/Armature/Skeleton3D/spine/Body/BackposCameraPivot

var walking: bool = false

func _process(_delta: float) -> void:
	moveCamera(_delta)
	
func moveCamera(_delta: float) -> void:
	var desiredCamPos = Vector3.ZERO
	if walking:
		desiredCamPos = backposCameraPivot.global_position
	else:
		desiredCamPos = alteredCameraPivot.global_position
	if !camera.global_position == desiredCamPos:
		var direction = camera.global_position.direction_to(desiredCamPos)
		var distance = camera.global_position.distance_to(desiredCamPos)
		var cameraTween = get_tree().create_tween()
		cameraTween.tween_property(camera, "global_position", desiredCamPos, 1.0)
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
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

func walk(_delta: float) -> void:
	walking = true
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/walk"] = true	
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/walk"] = false	
