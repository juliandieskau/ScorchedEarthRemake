extends Node

### VARIABLES ###

# Saving
var current_scene = null
const SAVE_PATH = "res://save.json"
# to save
var player_amount = 2
var player_data = []

# Player
var needed_color = "grey"
var player_name = "Player1"
var current_player = 0
var move_current_player = 0

# Bullet
var bullet_hit = false
var player_hit = ""
var bullet_excited = false
var bullet_left_screen = false
var bullet_ground_position = Vector2()
var air_strike_hit = false
var bomb_fallen = false
var ammunitionEvent = 0  # 0: shot without event; 1: event launched or in future; 2: event ended, go on then reset to 0

# Round
var updateUIlabel = false
var round_data = []

# Particles
var particle_amount = 0

# Menu bots
var can_shoot = true

# Sound
var baguette_land_y = 0
var explode = false
var nukeIncoming = false

### GODOT FUNCTIONS ###

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	print(current_scene)

### SAVE FUNCTIONS ###

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()
	
	# Load new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func save_game():
	var save_file = File.new()
	var save_dict = {}
	# Get all the data to save 
	var nodes_to_save = get_tree().get_nodes_in_group("SaveFiles")
	print("Nodes to save: ", nodes_to_save)
	
	for node in nodes_to_save:
		var node_data = node.call("save")
		save_file.store_line(to_json(node_data))
		save_dict[node.get_path()] = node.save()
		print(node.get_path())
		print(save_dict)
		pass
	
	# Create a file
	save_file.open(SAVE_PATH, File.WRITE)
	
	# Serialize the data dictionary to JSON
	save_file.store_line(to_json((save_dict)))
	
	# Write the JSON to the file and save to disk
	save_file.close()
	print("Game saved!")
	pass

#func save():
#	var save_dict = {
#		player_amount=player_amount,
#		player_data=player_data
#	}
#	return save_dict
