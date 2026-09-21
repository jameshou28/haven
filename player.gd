extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_LIGHT = 3.0
const DRAIN_RATE = 0.05

@onready var light: PointLight2D = $PointLight2D
var light_amount := MAX_LIGHT

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	light_amount -= DRAIN_RATE * delta
	light.texture_scale = max(light_amount, 0.0)
	
	if light_amount <= 0.0:
		get_tree().reload_current_scene()

func add_light(amount: float) -> void:
	light_amount = min(light_amount + amount, MAX_LIGHT)
	
