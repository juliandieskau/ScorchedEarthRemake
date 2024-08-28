extends Node2D

### VARIABLES ###

# Shooting
var shoot_power = 0
var shoot_angle = 0

# Player
var current_player = 0
var current_weapon = 0

# Weapons
var bullet_types = ["single Bullet"]

### GODOT FUNCTIONS ###

func _ready():
	get_global_variables()
	print("round_data: " + str(get_node("/root/global").round_data))

func _process(delta):
	update_variables()
	set_cannon_angle()
	set_power()
	set_ammunition_type()
	update_fuel()
	var delta_var = delta

### READY FUNCTIONS ###

func get_global_variables():
	current_player = get_node("/root/global").current_player
	print("ui current_player: ", str(current_player))
	var p_name = get_node("/root/global").player_data[current_player][0]
	$Top/PlayerName.text = p_name
	var w_name = bullet_types[0]
	$Top/WeaponLabel.text = w_name

### PROCESS FUNCTIONS ###

func update_variables():
	current_player = get_node("/root/global").current_player
	var p_name = get_node("/root/global").player_data[current_player][0]
	$Top/PlayerName.text = p_name
	var w_name = bullet_types[0]
	$Top/WeaponLabel.text = w_name

func set_cannon_angle():
	var updateUIlabel = get_node("/root/global").updateUIlabel
	if updateUIlabel == true:
		var angle_deg = -int(round(get_node("/root/global").round_data[current_player][2]))
		get_node("Bottom/AngleLabel").text = "Angle: " + str(angle_deg)

func set_power():
	var power_ui = int(round(get_node("/root/global").round_data[current_player][1]))
	get_node("Bottom/PowerLabel").text = "Power: " + str(power_ui)

func set_ammunition_type():
	var ammunition_type = get_node("/root/global").player_data[get_node("/root/global").current_player][2][get_node("/root/global").player_data[get_node("/root/global").current_player][3]][1]
	var ammunition_amount = get_node("/root/global").player_data[get_node("/root/global").current_player][2][get_node("/root/global").player_data[get_node("/root/global").current_player][3]][0]
	get_node("Top/WeaponLabel").text = ammunition_type + ": " + str(ammunition_amount)

func update_fuel():
	var current_player = get_node("/root/global").current_player
	var fuel_ui = get_node("/root/global").player_data[current_player][10]
	if fuel_ui < 0:
		fuel_ui = 0
	get_node("Bottom/FuelLabel").text = "Fuel: " + str(round(fuel_ui))