extends Area2D

@export var damage := 1
@export var knockback_force := 250

func _on_body_entered(body):
	if body.is_in_group("player"):
		var dir = (body.global_position - global_position).normalized()
		body.take_damage(damage, dir * knockback_force)
