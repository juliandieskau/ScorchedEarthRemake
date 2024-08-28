extends KinematicBody2D

### VARIABLES ###

var shoot_speed = 200
var shoot_factor = 3
var gravity = 50
var angle = 0

var velocity = Vector2()
var negative = -1
var pew = 0

#var explosion = false

### GODOT FUNCTIONS ###

func _ready():
	pew = 0

func get_input():
	velocity.x = 0
	var angle_rad = deg2rad(angle)
	#print(angle_rad)
	var y_speed = sin(angle_rad) * shoot_speed * negative / shoot_factor
	var x_speed = -cos(angle_rad) * shoot_speed / shoot_factor
	
	if pew == 0:
		velocity.y -= y_speed
		pew += 1
	velocity.x -= x_speed

func _process(delta):
	get_input()
	check_visibility()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

### PROCESS FUNCTIONS ###

func check_visibility():
	if position.x < 0 or position.x > 1280 or position.y > 720:
		get_node("/root/global").bullet_left_screen = true
		queue_free()
	pass