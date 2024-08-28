extends KinematicBody2D

### VARIABLES ###

var fall_speed_x
var fall_speed_y

var line_data = [["", Vector2()],["", Vector2()],["", Vector2()]] # name of body, position of body

### GODOT FUNCTIONS ###

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	check_visibility()
	position.x += fall_speed_x / 5
	position.y += fall_speed_y / 5
	
	check_line_data()

### LINE FUNCTIONS ###

func check_line_data():
	for i in line_data.size():
		if line_data[i][0] != "":
			#print("set_line()")
			set_line(i + 1, line_data[i][1]) 

func set_line(line, node_position):
	get_node("Line" + str(line)).points = [to_local(node_position), to_local(position)]
	print("Line"+ str(line) + " points: " + str(get_node("Line" + str(line)).points))

func clear_line(line):
	print("clear line")
	get_node("Line" + str(line)).points = []

### AREA FUNCTIONS ###

func _on_Area2D_body_entered(body):
	var add_body1 = false
	var add_body2 = false
	
	var i_var = 0
	
	for i in line_data.size():
		if line_data[i][0] == "":
			#print("add_body1 = true")
			add_body1 = true
			i_var = i
	
	if add_body1:
		for a in body.line_data.size():
			if body.line_data[a][0] != name:
				#print("add_body2 = true")
				add_body2 = true
	
	if add_body2:
		line_data[i_var][0] = body.name
		line_data[i_var][1] = body.position
		pass

func _on_Area2D_body_exited(body):
	for i in line_data.size():
		if line_data[i][0] == body.name:
			line_data[i][0] = ""
			line_data[i][1] = Vector2()
			clear_line(i + 1)
			return

func check_visibility():
	if position.x < 0 or position.x > 1280 or position.y > 720 or position.y < 0:
		queue_free()