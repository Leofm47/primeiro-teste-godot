extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var health = 3  # vida do jogador

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var sprite = $AnimatedSprite2D
	if velocity.length() > 0:
		sprite.animation = "walk"
		sprite.play()
		
		# Virar sprite conforme direção
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	else:
		sprite.stop()
		
		
func take_damage(amount):
	health -= amount
	print("Vida:", health)
	if health <= 0:
		die()
		
func die():
	if health <= 0:
		print("Player morreu!")
		# Reinicie a cena ou mande pro checkpoint
		get_tree().reload_current_scene()
