extends Node2D

func _ready():
	$IdleTimer.start()

func _on_IdleTimer_timeout():
	$ParticleTimer.start()
	pass

func get_random_spawnposition():
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y
	randomize()
	var x = randi()%int(width)
	var y = randi()%int(height)
	return Vector2(x, y)

func _on_ParticleTimer_timeout():
	var particle = preload("res://Stars/particle2.tscn").instance()
	particle.position = get_random_spawnposition()
	particle.fall_speed_x = get_random_speed()
	particle.fall_speed_y = get_random_speed()
	particle.rotation_speed = get_random_speed()
	add_child(particle)

func get_random_speed():
	randomize()
	var random_number = randi()%10 + 5
	randomize()
	var bool_number = randi()%2
	
	if bool_number == 0:
		pass
	elif bool_number == 1:
		random_number = -random_number
	
	return random_number
