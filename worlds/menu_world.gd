extends Node2D

### VARIABLES ###

var useless

### GODOT FUNCTIONS ###

func _ready():
	pass 

### AREA FUNCTIONS ###

func _on_Area2D_body_entered(body):
	#print("body entered world, name: " + body.name)
	var body_name = body.name
	if body_name == "bullet":
		print(body_name + " entered")
		print(name + " hit")
		get_node("/root/global").can_shoot = true
		body.queue_free()