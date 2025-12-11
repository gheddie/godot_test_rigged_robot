class_name Robot
extends CharacterBody3D

const SPEED = 25.0
const JUMP_VELOCITY = 4.5

@onready var animationTree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

func walk(_delta: float) -> void:
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/walk"] = true	
	
func idle() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/walk"] = false	
