extends CharacterBody2D

# ===== CONFIG =====
const SPEED := 100.0
const JUMP_VELOCITY := -300.0
const KNOCKBACK_DURATION := 0.2
const INVINCIBLE_DURATION := 0.4

# ===== ESTADO =====
var health := 3
var invincible := false
var knockback_time := 0.0

@onready var sprite := $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo (bloqueado durante knockback)
	if knockback_time <= 0 and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal (bloqueado durante knockback)
	if knockback_time > 0:
		knockback_time -= delta
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()

# ===== DANO =====
func take_damage(amount: int, knockback: Vector2) -> void:
	if invincible:
		return

	invincible = true
	health -= amount

	velocity = knockback
	knockback_time = KNOCKBACK_DURATION

	if health <= 0:
		die()
		return

	await get_tree().create_timer(INVINCIBLE_DURATION).timeout
	invincible = false

# ===== MORTE =====
func die():
	print("Player morreu")

	# Remove colisão pra ele cair
	$CollisionShape2D.queue_free()

	# Opcional: animação de morte
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("death")

	# Espera cair um pouco
	await get_tree().create_timer(1.0).timeout

	# Recarrega a fase
	get_tree().reload_current_scene()
	

# ===== ANIMAÇÃO =====
func update_animation():
	if velocity.x != 0:
		sprite.animation = "walk"
		sprite.play()
		sprite.flip_h = velocity.x < 0
	else:
		sprite.stop()
