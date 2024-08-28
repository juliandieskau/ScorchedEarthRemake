extends KinematicBody2D

### VARIABLES ###

# Player variables
var gravity = 50.0
var velocity = Vector2()

var angle = 0

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
	var needed_color = get_random_color()
	match needed_color:
		0: $texture.set_texture(grey_tank)
		1: $texture.set_texture(blue_tank)
		2: $texture.set_texture(green_tank)
		3: $texture.set_texture(orange_tank)
		4: $texture.set_texture(pink_tank)
		5: $texture.set_texture(yellow_tank)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y = gravity
	if is_on_floor():
		velocity.y = 0
	#print("player: " + name + ", velocity: " + str(velocity))
	move_and_slide(velocity, Vector2( 0, -2), false, 4, 0.8, true)
	
	get_node("cannon").rotation_degrees = angle

func _process(delta):
	var delta_var = delta # Stop dumb output

func get_random_color():
	randomize()
	var random_color = randi()%6
	return random_color
