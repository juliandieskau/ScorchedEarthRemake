extends Node2D

### VARIABLES ###

# Global variables
var player_data = []
var currentPlayer = 0
var player_amount = 2

# Shop variables
var in_inventory = false
var on_ammunition = true

# Button variables
var ammunitionORitemsButton = false
var readyButton = false


### GODOT FUNCTIONS ###

func _ready():
	set_variables()
	show_player_info()


func _process(delta):
	get_input()
	var delta_var = delta

### READY FUNCTIONS ###

func set_variables():
	player_data = get_node("/root/global").player_data
	player_amount = get_node("/root/global").player_amount

### INPUT FUNCTIONS ###

func get_input():
	var tab = Input.is_action_just_pressed("tab") # Change between ammunition and items
	if ammunitionORitemsButton:
		tab = true
	var ready = Input.is_action_just_pressed("ready") # change to next player
	if readyButton:
		ready = true
	var up = Input.is_action_just_pressed("power_up") # go one item up in the list
	var down = Input.is_action_just_pressed("power_down") # go one item down in the list
	
	if tab:
		if on_ammunition == true:
			on_ammunition = false
			$ItemsLeft/Ammunition.hide()
			$ItemsLeft/Items.show()
		elif on_ammunition == false:
			on_ammunition = true
			$ItemsLeft/Items.hide()
			$ItemsLeft/Ammunition.show()
		ammunitionORitemsButton = false
	
	if ready:
		print("ready")
		if currentPlayer < ( player_amount - 1 ):
			currentPlayer += 1
			nextPlayer()
			readyButton = false
		else:
			go_on_game()
	

func _on_AmmunitionOrItem_pressed():
	ammunitionORitemsButton = true

func _on_Ready_pressed():
	readyButton = true

### PROCESS FUNCTIONS ###

func nextPlayer():
	$ItemsLeft/Items.hide()
	$ItemsLeft/Ammunition.show()
	show_player_info()

func show_player_info():
	# PLAYER NAME
	get_node("InfoRight/currentPlayer").text = player_data[currentPlayer][0]
	# PLAYER COLOR
	var tank_color = player_data[currentPlayer][1]
	var color_path
	match tank_color:
		"green": color_path = preload("res://tank/green_tank.png")
		"grey": color_path = preload("res://tank/grey_tank.png")
		"blue": color_path = preload("res://tank/blue_tank.png")
		"orange": color_path = preload("res://tank/orange_tank.png")
		"pink": color_path = preload("res://tank/pink_tank.png")
		"yellow": color_path = preload("res://tank/yellow_tank.png")
	get_node("InfoRight/tankColor").texture = color_path
	# PLAYER MONEY
	update_player_money()
	# Amounts of the currently possessed items
	update_item_amounts()

func update_player_money():
	var player_money = player_data[currentPlayer][8]
	get_node("InfoRight/currentMoney").text = str(player_money) + "$"
	pass

func update_item_amounts(): # just locally for the labels
	$ItemsLeft/Ammunition/horseBullet/Amount.text = str(player_data[currentPlayer][2][3][0])
	$ItemsLeft/Ammunition/frenchBullet/Amount.text = str(player_data[currentPlayer][2][1][0])
	$ItemsLeft/Ammunition/sniperBullet/Amount.text = str(player_data[currentPlayer][2][4][0])
	$ItemsLeft/Ammunition/atomBullet/Amount.text = str(player_data[currentPlayer][2][2][0])
	
	$ItemsLeft/Items/fuelCanister/Amount.text = str(player_data[currentPlayer][10])
	pass

func purchase_item(amount, item):
	if player_data[currentPlayer][8] >= amount:
		player_data[currentPlayer][8] -= amount
		match item:
			"horseBullet": player_data[currentPlayer][2][3][0] += 1
			"frenchBullet": player_data[currentPlayer][2][1][0] += 1
			"sniperBullet": player_data[currentPlayer][2][4][0] += 1
			"atomBullet": player_data[currentPlayer][2][2][0] += 1
			"fuelCanister": player_data[currentPlayer][10] += 100
		update_item_amounts()
		update_player_money()
		get_node("/root/global").player_data = player_data
	else:
		$InfoRight/notEnoughMoney.show()
		$InfoRight/noMoneyTimer.start()
	

func go_on_game():
	get_node("/root/global").save_game()
	get_node("/root/global").goto_scene("res://Main.tscn")
	pass

### BUTTON FUNCTIONS ###

func _on_horseBullet_pressed():
	purchase_item(1300, "horseBullet")

func _on_frenchBullet_pressed():
	purchase_item(1700, "frenchBullet")

func _on_sniperBullet_pressed():
	purchase_item(5300, "sniperBullet")

func _on_atomBullet_pressed():
	purchase_item(5700, "atomBullet")

func _on_fuelCanister_pressed():
	purchase_item(1500, "fuelCanister")

func _on_noMoneyTimer_timeout():
	$InfoRight/notEnoughMoney.hide()

func save():
	var save_dict = {
		player_data=player_data,
		player_amount=player_amount
	}
	return save_dict


