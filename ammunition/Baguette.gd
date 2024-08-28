extends KinematicBody2D

var gravity = 300
var velocity = Vector2()

var explosion = true

# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = - 1550 + get_node("/root/global").baguette_land_y
	var baguette_sound = preload("res://audio/AudioPlayer.tscn").instance()
	baguette_sound.audio_num = 3
	get_parent().add_child(baguette_sound)
	

func _physics_process(delta):
	velocity.x = 0
	velocity.y = gravity
	velocity = move_and_slide(velocity, Vector2(0, -1))
	pass