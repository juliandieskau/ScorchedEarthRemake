extends KinematicBody2D

var a = 400
var normal_speed = 200
var velocity = Vector2()
var bomb_fallen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	bomb_fallen = get_node("/root/global").bomb_fallen
	if bomb_fallen == true:
		#print("enola fly faster!")
		velocity.x = -a 
		velocity.y += 0
		velocity = move_and_slide(velocity, Vector2(0, -1))
	elif bomb_fallen == false:
		velocity.y = 0
		velocity.x = -normal_speed
		velocity = move_and_slide(velocity, Vector2(0, -1))
	if position.x < -100:
		$AudioStreamPlayer2D.volume_db -= 0.5
	
	if position.x < -500:
		queue_free()