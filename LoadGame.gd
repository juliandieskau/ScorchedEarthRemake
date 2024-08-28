extends Node

### VARIABLES

var SAVE_PATH = "res://save.json"

### GODOT FUNCTIONS ###

func _ready():
	load_game()
	get_node("/root/global").goto_scene("res://Menu.tscn")
	pass

### LOAD FUNCTIONS ###

func load_game():
	print("loading game. . .")
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return # Error! We don't have a save to load.
	print("file exists")
	
	# We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting savable objects.
	var save_nodes = get_tree().get_nodes_in_group("SaveFiles")
	for i in save_nodes:
		i.queue_free()
	
	#parse the file data
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = parse_json(save_file.get_as_text())
	print(data)
	
	
	# load the data into persistent nodes
	for node_path in data.keys():
		#var node = get_node(node_path)
		var node = get_node("/root/global")
		print(node_path)
		print(node)
		
		for attribute in data[node_path]:
#			if attribute == "pos":
#				node.set_pos(Vector2(data[node_path]['pos']['x'], data[node_path]['pos']['y']))
#			else:
			node.set(attribute, data[node_path][attribute])
			#print("data: ", data)
