extends Area2D

### VARIABLES ###

var nothing_here

### GODOT FUNCTIONS ###

func _ready():
	pass 

### AREA FUNCTIONS ###

func _on_bulletHit_body_entered(body):
	if body.name == "airStrike":
		print("airstrike hit bulletHit")
		get_node("/root/global").air_strike_hit = true
		get_node("/root/global").player_hit = name.trim_suffix("Area")
		if get_node("/root/global").explode == true:
			explooooosion(body.position)
		body.queue_free()
		pass
	elif body.name == "airStrikeNuke":
		print("nuke hit bulletHit")
		nukeThis(body.position)
		body.queue_free()
	elif (body.name + "Area") != ("bullet" + name):
		print("!= true") # If the area is not matching to the player shooting
		if (body.name.begins_with("bullet")):
			print(str(body.name) + " entered")
			print(name + " hit")
			get_node("/root/global").bullet_hit = true # Send to main that bullet hit its area
			get_node("/root/global").bullet_ground_position = body.position
			print("bullet ground position: " + str(get_node("/root/global").bullet_ground_position))
			var nameWO = name.trim_suffix("Area")
			get_node("/root/global").player_hit = nameWO
			print("name of hit person: " + nameWO)
			if get_node("/root/global").explode == true:
				explooooosion(body.position)
			
			body.queue_free()
	else:
		print("hit area, name: " + body.name)

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