extends Node2D

### VARIABLES ###

var useless_position = Vector2()

### GODOT FUNCTIONS ###

func _ready():
	pass 

### AREA FUNCTIONS ###

func _on_Area2D_body_entered(body):
	#print("body entered world, name: " + body.name)
	var body_name = body.name
	for i in get_node("/root/global").player_amount:
		var player_name = get_node("/root/global").player_data[i][0]
		body_name = body_name.trim_suffix(player_name)
		#print("player_name [i]: " + player_name)
		#print("body_name: " + body_name)
	if body_name.ends_with("bullet"):
		print(body_name + " entered")
		print(name + " hit")
		get_node("/root/global").bullet_excited = true # Send to main that bullet hit its area
		get_node("/root/global").bullet_ground_position = body.position
		get_node("/root/global").baguette_land_y = body.position.y
		body.queue_free()
		if get_node("/root/global").explode == true:
			explooooosion(body.position)
	elif body_name == "airStrike":
		get_node("/root/global").ammunitionEvent = 2
		body.queue_free()
		if get_node("/root/global").explode == true:
			explooooosion(body.position)
		pass
	elif body.name == "airStrikeNuke":
		print("nuke hit World")
		get_node("/root/global").ammunitionEvent = 2
		nukeThis(body.position)
		body.queue_free()

func explooooosion(pos):
	var explosion = preload("res://particles/Explosion.tscn").instance()
	explosion.position = pos
	get_parent().add_child(explosion)
	get_node("/root/global").explode = false

func nukeThis(pos):
	var nuke = preload("res://particles/AtomicCloud.tscn").instance()
	nuke.position = pos
	get_parent().add_child(nuke)
	get_node("/root/global").nukeIncoming = false