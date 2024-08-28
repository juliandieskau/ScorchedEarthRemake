extends KinematicBody2D

### VARIABLES ###

var useless

### GODOT FUNCTIONS ###

func _ready():
	pass 

### AREA FUNCTIONS ###

func _on_Area2D_body_entered(body):
	var body_name = body.name
	for i in get_node("/root/global").player_amount:
		var player_name = get_node("/root/global").player_data[i][0]
		body_name = body_name.trim_suffix(player_name)
		print("player_name [i]: " + player_name)
		print("body_name: " + body_name)
	if body_name.ends_with("bullet"):
		print(body_name + " entered")
		print(name + " hit")
		get_node("/root/global").bullet_excited = true # Send to main that bullet hit its area
		get_node("/root/global").bullet_ground_position = body.position
		body.queue_free()
	elif body_name == "airStrike":
		get_node("/root/global").ammunitionEvent = 2
		body.queue_free()
		pass
