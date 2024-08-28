extends KinematicBody2D

### VARIABLES ###

var fall_speed_x
var fall_speed_y
var rotation_speed

### GODOT FUNCTIONS ###

func _ready():
	$OverflowTimer.start()
	#print("to global pos: " + str())

func _physics_process(delta):
	position.x += fall_speed_x / 5
	position.y += fall_speed_y / 5
	$texture.rotation_degrees += 2 * rotation_speed

### TIMOUT FUNCTIONS ###

func _on_OverflowTimer_timeout():
	queue_free()

