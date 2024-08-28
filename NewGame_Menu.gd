extends Node2D

### VARIABLES ###

var player_amount = 2
var current_player = 1
var player_data = []
var player_data_position = 0

### GODOT FUNCTIONS ###

func _ready():
	player_amount = $"/root/global".player_amount
	for i in player_amount:
		# Show the amount of players at the bottom
		var sub_number = i + 1
		var player_var = "Player" + str(sub_number)
		print(player_var)
		get_node("ready_Players/" + str(player_var)).show()
		
		# fill a inventory-array to append to player_data
		# warning! bullet_type has to match the name of its scene!!!!
		var inventory = [[999, "singleBullet"],[0, "frenchBullet"],[0, "atomBullet"],[0, "horseBullet"],[0, "sniperBullet"]] # list all types of bullets, singleBullet big amount, rest nothing
		
		# fill the player_data with blank info for all players
		player_data.append(["Player" + str(sub_number), "grey", inventory, 0, 0, 0, 0, 0, 0, 0, 100.0]) # 0: name; 1:color; 2:inventory; 3:last ammunition (number pointer); 4: Wins; 5: Kills; 6: Deaths; 7: Hits; 8: Money; 9: points for sorting; 10: tank fuel
#	print("current player: ", current_player)
	print(player_data)

### BUTTON CONTROLS ###

func _on_ready_Button_pressed():
	if current_player == player_amount:
		get_node("/root/global").player_data = player_data
		get_node("/root/global").save_game()
		get_node("/root/global").goto_scene("res://Main.tscn")
	if current_player < player_amount:
		current_player += 1
		player_data_position = current_player - 1 
	print("current player: ", current_player)
	print(player_data)

func _on_grey_Button_pressed():
	player_data[player_data_position][1] = "grey"
	var grey_tank = preload("res://tank/grey_tank.png")
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("playerTank_color" + str(current_player)).set_texture(grey_tank)
#	print(player_data)

func _on_blue_Button_pressed():
	player_data[player_data_position][1] = "blue"
	var blue_tank = preload("res://tank/blue_tank.png")
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("playerTank_color" + str(current_player)).set_texture(blue_tank)
#	print(player_data)

func _on_green_Button_pressed():
	player_data[player_data_position][1] = "green"
	var green_tank = preload("res://tank/green_tank.png")
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("playerTank_color" + str(current_player)).set_texture(green_tank)
#	print(player_data)

func _on_orange_Button_pressed():
	player_data[player_data_position][1] = "orange"
	var orange_tank = preload("res://tank/orange_tank.png")
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("playerTank_color" + str(current_player)).set_texture(orange_tank)
#	print(player_data)

func _on_pink_Button_pressed():
	player_data[player_data_position][1] = "pink"
	var pink_tank = preload("res://tank/pink_tank.png")
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("playerTank_color" + str(current_player)).set_texture(pink_tank)
#	print(player_data)

func _on_yellow_Button_pressed():
	player_data[player_data_position][1] = "yellow"
	var yellow_tank = preload("res://tank/yellow_tank.png")
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("playerTank_color" + str(current_player)).set_texture(yellow_tank)
#	print(player_data)

### PROCESS FUNCTIONS ###

func _on_PlayerName_Enter_text_changed(new_text):
	player_data[current_player - 1][0] = new_text
	get_node("ready_Players").get_node("Player" + str(current_player)).get_node("Player" + str(current_player) + "_Label").text = new_text

### SAVE FUNCTIONS ### 

func save():
	var save_dict = {
		player_data=player_data,
		player_amount=player_amount
	}
	return save_dict