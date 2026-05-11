extends Area2D

@export var player: CharacterBody2D
@export var camera: Camera2D

var base_speed := 40.0
var acceleration := 0.09
var max_speed := 300.0

var max_progress := 0.0
var start_x := 0.0


func _ready():
	start_x = player.global_position.x



func _physics_process(delta):

	if player == null:
		return

	var progress = player.global_position.x - start_x

	if progress > max_progress:
		max_progress = progress

	var speed = base_speed + max_progress * acceleration
	speed = clamp(speed, base_speed, max_speed)
	print("velocidade:", speed)

	global_position.x += speed * delta

	if camera:
		camera.limit_left = int(global_position.x - 15)
		if camera.global_position.x < global_position.x:
			camera.reset_smoothing()
	
