extends Area2D

@export var damage := 1
@export var knockback_force := 250

@onready var fire1 = get_node_or_null("fire1")
@onready var fire2 = get_node_or_null("fire2")

func _ready():
	if fire1:
		fire1.play("fire")
	if fire2:
		fire2.play("fire")

func _on_body_entered(body):
	if body.is_in_group("player"):
		var dir = (body.global_position - global_position).normalized()
		body.take_damage(damage, dir * knockback_force)
