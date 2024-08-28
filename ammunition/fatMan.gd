extends KinematicBody2D

var gravity = 200
var velocity = Vector2()
var fat_rotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = 0
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if fat_rotation < 90:
		fat_rotation += 1
		rotation_degrees = -fat_rotation