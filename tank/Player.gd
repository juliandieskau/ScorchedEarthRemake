extends KinematicBody2D

### VARIABLES ###

# Player variables
var gravity = 10.0
var velocity = Vector2()
var max_speed = 50
var current_speed = 0
var minus_fuel = 0.7

var last_position_x = 0
var engine_playing = false

### GODOT FUNCTIONS ###

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the color of the tank
	var grey_tank = preload("res://tank/grey_tank.png")
	var blue_tank = preload("res://tank/blue_tank.png")
	var green_tank = preload("res://tank/green_tank.png")
	var orange_tank = preload("res://tank/orange_tank.png")
	var pink_tank = preload("res://tank/pink_tank.png")
	var yellow_tank = preload("res://tank/yellow_tank.png")
	var needed_color = get_node("/root/global").needed_color
	match needed_color:
		"grey": $texture.set_texture(grey_tank)
		"blue": $texture.set_texture(blue_tank)
		"green": $texture.set_texture(green_tank)
		"orange": $texture.set_texture(orange_tank)
		"pink": $texture.set_texture(pink_tank)
		"yellow": $texture.set_texture(yellow_tank)
	
	# Set the text of the name-tag to the Players name
	var player_name = get_node("/root/global").player_name
	$Label.text = player_name
	last_position_x = position.x

func _physics_process(delta):
	update_player_speed()
	if not is_on_floor():
		velocity.y += gravity
	if is_on_floor():
		velocity.y = gravity
	velocity.x = current_speed
	if velocity.x == 0:
		$AudioStreamPlayer2D.playing = false
		engine_playing = false
		$Particles2D.emitting = false
	if round(last_position_x) != round(position.x):
#		print("last_position: " + str(last_position_x))
#		print("position_x: " + str(position.x))
		substract_fuel(minus_fuel)
		last_position_x = position.x
	#print("player: " + name + ", velocity: " + str(velocity))
	move_and_slide(velocity, Vector2( 0, -2), false, 4, 0.8, true)

func _process(delta):
	var delta_var = delta # Stop dumb output
	update_health()

func update_health():
	var health = 100
	var number = 0
	for i in get_node("/root/global").player_amount:
		if get_node("/root/global").round_data[i][0] == name:
			number = i
	health = get_node("/root/global").round_data[number][3]
	$healthBar.value = health
	$healthLabel.text = str(health)

func update_player_speed():
	# Just move if current player is the one the script is from
	var player_name = name
	#print("player_name: " + player_name)
	var current_player = get_node("/root/global").current_player
	var current_player_name = get_node("/root/global").player_data[current_player][0]
	#print("current_player_name: " + current_player_name)
	if current_player_name == player_name:
		current_speed = max_speed * get_node("/root/global").move_current_player # -1 for left, 0 standing, 1 for right
	else:
		current_speed = 0

func substract_fuel(amount):
	var current_player = get_node("/root/global").current_player
	get_node("/root/global").player_data[current_player][10] -= amount
	if engine_playing == false:
		$AudioStreamPlayer2D.playing = true
		engine_playing = true
		$Particles2D.emitting = true
	pass