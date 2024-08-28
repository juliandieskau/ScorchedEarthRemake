extends Node2D

### VARIABLES ###

var particle_amount = 0

### GODOT FUNCTIONS ###

func _ready():
	$ParticleTimer.start()

func process(delta):
	var amount = get_node("/root/global").particle_amount
	particle_amount = amount

### PARTICLE FUNCTIONS ###

func get_random_spawnposition():
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y
	randomize()
	var x = randi()%int(width)
	var y = randi()%int(height)
	return Vector2(x, y)

func _on_ParticleTimer_timeout():
	if particle_amount < 10:
		var particle = preload("res://MenuBackground/particle.tscn").instance()
		particle.set_name("Particle" + str(particle_amount))
		particle.position = get_random_spawnposition()
		particle.fall_speed_x = get_random_speed()
		particle.fall_speed_y = get_random_speed()
		add_child(particle)
		print("particle amount: " + str(particle_amount))
		$ParticleTimer.start()
		get_node("/root/global").particle_amount += 1

func get_random_speed():
	randomize()
	var random_number = randi()%40 + 5
	random_number = float(random_number / 10)
	randomize()
	var bool_number = randi()%2
	
	if bool_number == 0:
		pass
	elif bool_number == 1:
		random_number = -random_number
	
	return random_number

### AREA FUNCTIONS ###

func _on_Area2D_body_exited(body):
	get_node("/root/global").particle_amount -= 1
	body.queue_free()
