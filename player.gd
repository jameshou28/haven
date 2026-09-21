extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_LIGHT = 3.0
const DRAIN_RATE = 0.05
const MAX_FALL_SPEED = 700.0


@onready var light: PointLight2D = $PointLight2D
@onready var win_label: Label = $"../CanvasLayer/WinLabel"
@onready var tiles: TileMapLayer = $"../TileMapLayer"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)

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
	
	#light_amount -= DRAIN_RATE * delta
	light.texture_scale -= DRAIN_RATE * delta
	#light.texture_scale = max(light_amount, 0.0)
	
	if light.texture_scale <= 0.0 or position.y > 2000:
		get_tree().reload_current_scene()
		
	var cell := tiles.local_to_map(tiles.to_local(global_position))
	print(cell)
	if cell.y >= 19:
		win_label.visible = true
		set_physics_process(false)

#func add_light(amount: float) -> void:
	#light_amount = min(light_amount + amount, MAX_LIGHT)
	
