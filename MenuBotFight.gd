extends Node2D

### VARIABLES ###

var can_shoot = true
var current_bot = 1

### GODOT FUNCTIONS ###

func _ready():
	get_node("/root/global").can_shoot = true

func _process(delta):
	if get_node("/root/global").can_shoot == true:
		shoot(current_bot)

### SHOOT FUNCTIONS ###

func shoot(bot): # fixed
	get_node("/root/global").can_shoot = false
	if current_bot == 1:
		current_bot = 2
	elif current_bot == 2:
		current_bot = 1
	
	# chose Bullet-type / create variable that stores path to every one
	var bullet = preload("res://bullet.tscn").instance()
	var angle = -get_random_angle()
	bullet.angle = angle
	match bot:
		1: 
			bullet.position = $Bot1/bullet_spawn.position + $Bot1.position
			get_node("Bot1").angle = angle
		2: 
			bullet.position = $Bot2/bullet_spawn.position + $Bot2.position
			get_node("Bot2").angle = angle
	bullet.shoot_speed = get_random_speed()
	bullet.set_name("bullet")
	print("speed: " + str(bullet.shoot_speed))
	print("winkel: " + str(bullet.angle))
	add_child(bullet)

func get_random_angle():
	randomize()
	return randi()%160 + 10

func get_random_speed():
	randomize()
	return randi()%400 + 100

