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
var dead := false

@onready var sprite := $Pivot/AnimatedSprite2D
@onready var pivot := $Pivot


func _physics_process(delta: float) -> void:

	# comportamento quando morto
	if dead:
		if not is_on_floor():
			velocity += get_gravity() * delta

		move_and_slide()
		return

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if knockback_time <= 0 and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
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

	if invincible or dead:
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

	if dead:
		return

	dead = true

	print("Player morreu")

	# impulso para cima
	velocity = Vector2(0, -200)

	# desativa colisão
	$CollisionShape2D.set_deferred("disabled", true)

	sprite.stop()
	sprite.play("death")

	# espera animação/momento dramático
	await get_tree().create_timer(1.3).timeout

	# reinicia fase
	get_tree().reload_current_scene()


# ===== ANIMAÇÃO =====
func update_animation():

	if velocity.x != 0:
		sprite.animation = "walk"
		sprite.play()

		if velocity.x < 0:
			pivot.scale.x = -1
		elif velocity.x > 0:
			pivot.scale.x = 1
	else:
		sprite.stop()
