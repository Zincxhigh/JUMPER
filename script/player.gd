extends CharacterBody2D
@onready var animated_Sprite_2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound = $jumpsound
@onready var dyingsound = $dyingsound

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true
var can_move = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if !alive:
		return
	
	# animation
	if velocity.x > 1 or velocity.x < -1:
		animated_Sprite_2D.animation = "running"
	else:
		animated_Sprite_2D.animation = "idle"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_Sprite_2D.animation = "jumping"
	
	if can_move:
	# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumpsound.play()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if direction == 1:
			animated_Sprite_2D.flip_h = false
		elif direction == -1:
			animated_Sprite_2D.flip_h = true
	
func die() -> void:
	animated_Sprite_2D.animation = "dying"
	dyingsound.play()
	alive = false
