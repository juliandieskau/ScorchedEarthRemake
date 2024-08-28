extends Node2D

### VARIABLES ###

# Arrays
var player_data = [] # Stored: name, color, stats like kills deaths wins (added from round_stats after every round) and shots hits, money, inventory, current_weapon
var round_data = [] # Stored: name, angle, power - round specific
var round_stats = [] # Stored: 0: name, 1: wins, 2:kills, 3:deaths, 4:hits, 5: money - round specific, add to player_data after round, reset to 0

# Counters
var rounds = 0
var player_amount = 2
var players_left = 2

# Players
var first_player = 0 # The current player when the game starts
var current_player = 0 # The player that currently can shoot

# Shoot
var shoot_angle = 0 # angle in degrees, used in round_data
var can_shoot = true # set false when bullet is in air or tanks are moving
var bullet_spawn = Vector2() # vector as position where in relation to the tank the bullet should appear to look the right way
var multiplier = 1

# Tracers
var bullet_in_air = false

# Ammunition
var air_strike = ""
var damage_amount = 10
var air_strike_damage = 10
var spawn_enola_gay = false
var enolaGay_in_air = false

# Environment
var window_width = 1280 # width of the window, used for player spawning

### GODOT FUNCTIONS ###

func _ready():
	select_map()
	set_variables()
	spawn_players()
	create_player_areas()
	add_tracers()
	set_up_ui()
	select_next_time()

func get_input(): # Get Input and process it
	var right = Input.is_action_pressed("right") # d - not - move tank right
	var left = Input.is_action_pressed("left") # a - not - move tank left
	var right_released = Input.is_action_just_released("right")
	var left_released = Input.is_action_just_released("left")
	var up = Input.is_action_pressed("up") # w - not - for jetpacks?
	var down = Input.is_action_just_pressed("down") # s - not - for parachutes?
	var clockw = Input.is_action_pressed("clockw") # > - used - increase shoot angle
	var counterw = Input.is_action_pressed("counterw") # < - used - decrease shoot angle
	var power_up = Input.is_action_pressed("power_up") # up - used - increse shoot power
	var power_down = Input.is_action_pressed("power_down") # down - used - decrease shoot power
	var shoot = Input.is_action_just_pressed("enter") # enter - used - commit all inputs and shoot the bullet
	var space = Input.is_action_just_pressed("space") # space - not - 
	var shift = Input.is_action_pressed("shift") # shift - used - increase the power 10 times faster
	var tab = Input.is_action_just_pressed("tab") # tab - used - change weapon type
	
	var mouseLeft = Input.is_action_pressed("mouse_left") # left mouse button - used - change angle of cannon
	var mouseRight = Input.is_action_pressed("mouse_right") # right mouse button - not - change power of cannon
	var mousePosition = get_viewport().get_mouse_position()
	
	# set Cannon-rotation to the mouse position
	var currentNode = get_node("/root/global").player_data[get_node("/root/global").current_player][0]
	if mouseLeft:
		get_node("/root/global").updateUIlabel = false
		var cannonPosition = position + get_node(currentNode).position
		var deltaX = mousePosition.x - cannonPosition.x
		var deltaY = mousePosition.y - cannonPosition.y
		restrict_cannon_angle(rad2deg(atan2(deltaY, deltaX)))
	if not mouseLeft:
		get_node("/root/global").updateUIlabel = true
	
	shoot_angle = round_data[current_player][2]
	if clockw:
		change_cannon_angle(1, shoot_angle)
	if counterw:
		change_cannon_angle(-1, shoot_angle)
	
	if shift:
		multiplier = 10
	if not shift:
		multiplier = 1
	
	if tab:
		if can_shoot:
			change_ammunition()
	
	if power_up:
		if can_shoot:
			change_cannon_power(multiplier)
	if power_down:
		if can_shoot:
			change_cannon_power(-multiplier)
	
	if get_node("/root/global").player_data[current_player][10] > 0.0:
		if can_shoot == true:
			if right:
				move_current_player(1)
				#print("move right")
			
			if left:
				move_current_player(-1)
				#print("move left")
	elif get_node("/root/global").player_data[current_player][10] <= 0.0:
		move_current_player(0)
	
	if right_released:
		move_current_player(0)
	
	if left_released:
		move_current_player(0)
	
	if can_shoot:
		flip_player(round_data[current_player][2], currentNode)
		bullet_spawn = Vector2(get_node(currentNode).position.x, get_node(currentNode).position.y - 2)
		get_node(currentNode).get_node("cannon").rotation = deg2rad(round_data[current_player][2])
	
	# Shoot
	if shoot:
		if can_shoot:
			shoot(get_node("/root/global").player_data[get_node("/root/global").current_player][2][get_node("/root/global").player_data[get_node("/root/global").current_player][3]][1]) # argument 0: bullet-type
			print("has shot!")
	
	# Call a damage function after hit
	if get_node("/root/global").bullet_hit == true:
		damage_player(damage_amount, get_node("/root/global").player_hit)
		pass
	
	if get_node("/root/global").bullet_left_screen == true:
		bullet_in_air = false
		get_node("/root/global").ammunitionEvent = 2
		get_node("/root/global").bullet_left_screen = false
	
	# Swap player after bullet excited screen or hit ground/ player
	if (get_node("/root/global").bullet_excited == true) or get_node("/root/global").bullet_hit == true:
		print("main - round_data: " + str(round_data))
		print("Main - bullet hit")
		bullet_in_air = false
		get_node("/root/global").bullet_excited = false
		get_node("/root/global").bullet_hit = false
		if get_node("/root/global").ammunitionEvent == 0:
			get_node("/root/global").ammunitionEvent = 2
#		if get_node("/root/global").bullet_ground_position == Vector2(): # when bullet hits ground its not blank, so it must be the hit-player`s position
#			get_node("/root/global").bullet_ground_position = get_node(get_node("/root/global").player_hit).position
		spawn_air_strike(air_strike)
		spawn_enolaGay()
	
	
	if get_node("/root/global").air_strike_hit == true:
		print("damage player: " + get_node("/root/global").player_hit)
		damage_player(air_strike_damage, get_node("/root/global").player_hit)
		get_node("/root/global").air_strike_hit = false
		get_node("/root/global").ammunitionEvent = 2
	
	# ammunition_event has to be "2" to let the game go
	# when there is no event to be launched it is set to 2 when the bullet lands
	# if there is an event, it is set to "2" after the event hit the ground
	go_on_game()

func _process(delta):
	get_input()
	var delta_var = delta # To stop dumb output
	update_player_areas() # Update the positions of the areas to the matching players one
	change_tracers()
	dropFatMan()
	quit_round()
	# If bullet hit player or world, put in global bullet_hit to true
	
	# If bullet excited screen, in global "bullet_excited" is true, so check that here to swap to next player


### BEGIN FUNCTIONS ###

func select_map(): # fixed
	randomize()
	var random_map = randi()%2
	var current_map
	print("player_amount - map: " + str(player_amount))
	var match_var = int(get_node("/root/global").player_amount)
	match match_var:
		2: 
			print("matched 2")
			match random_map:
				0: current_map = preload("res://worlds/two_world1.tscn").instance()
				1: current_map = preload("res://worlds/two_world2.tscn").instance()
			add_child(current_map)
		3:
			print("matched 3")
			match random_map:
				0: current_map = preload("res://worlds/two_world1.tscn").instance()
				1: current_map = preload("res://worlds/three_world1.tscn").instance()
			add_child(current_map)
		4:
			print("matched 4")
			match random_map:
				0: current_map = preload("res://worlds/two_world2.tscn").instance()
				1: current_map = preload("res://worlds/two_world1.tscn").instance()
			add_child(current_map)
		5:
			print("matched 5")
			match random_map:
				0: current_map = preload("res://worlds/five_world2.tscn").instance()
				1: current_map = preload("res://worlds/five_world1.tscn").instance()
			add_child(current_map)
		6:
			print("matched 6")
			match random_map:
				0: current_map = preload("res://worlds/five_world1.tscn").instance()
				1: current_map = preload("res://worlds/three_world1.tscn").instance()
			add_child(current_map)
		_:
			print("nothing matched")
	#print("current_map: " + str(current_map.name))

func spawn_players(): # fixed
	for i in range(player_amount):
		print("player_amount: ", player_amount)
		print("player: ", i)
		
		# Set the player
		var player = preload("res://tank/Player.tscn").instance()
		var player_number = i + 1
		print("player_number: ", player_number)
		
		# Set the players position
		var x_pos_factor = 2 * i + 1
		var player_x_position = x_pos_factor * (1.0/(player_amount * 2)) * window_width
		print("player_x_position: ", player_x_position)
		var player_spawn_position = Vector2(player_x_position, 100)
		player.position = player_spawn_position
		
		# Set the players color and name to global
		var needed_color = get_node("/root/global").player_data[i][1]
		get_node("/root/global").needed_color = needed_color
		
		# Set the name of the node to the entered name of the Player
		var player_name = get_node("/root/global").player_data[i][0]
		get_node("/root/global").player_name = player_name
		player.set_name(player_name)
		
		
		# Add player as child to Main-Scene
		add_child(player)

func set_variables(): # fixed
	# Pick the player amount for spawning reasons
	player_amount = get_node("/root/global").player_amount
	players_left = player_amount
	print("player_amount" + str(player_amount))
	# Pick random player as first one
	current_player = get_random_player()
	print(current_player)	
	# Mark the player who played first
	first_player = current_player
	# Pick the window width for spawning reasons
	window_width = get_viewport().size.x
	print("window_width: " + str(window_width))
	# Ask for player data
	player_data = get_node("/root/global").player_data
	#print("player_data: " + str(player_data))
	# Set round_data to the last player_data
	set_up_round_data()
	set_up_round_stats()

func set_up_ui(): # fixed
	# Update the global variables to this script ones
	get_node("/root/global").current_player = current_player
	get_node("/root/global").round_data = round_data
	
	# Instanciate the UI
	var userInterface = preload("res://UserInterface.tscn").instance()
	add_child(userInterface)

func get_random_player(): # fixed
	randomize()
	return randi()%int(player_amount)


### PROCESS FUNCTIONS ###

func shoot(ammunition): # fixed
	can_shoot = false
	air_strike = ""
	substract_ammunition()
	delete_tracer()
	# chose Bullet-type / create variable that stores path to every one
	var singleBullet = preload("res://ammunition/singleBullet.tscn").instance()
	var frenchBullet = preload("res://ammunition/frenchBullet.tscn").instance()
	var atomBullet = preload("res://ammunition/atomBullet.tscn").instance()
	var horseBullet = preload("res://ammunition/horseBullet.tscn").instance()
	var sniperBullet = preload("res://ammunition/sniperBullet.tscn").instance()
	# .
	# .
	# .
	var bullet
	match ammunition:
		"singleBullet": 
			bullet = singleBullet
			damage_amount = 10
			get_node("/root/global").explode = true
		"frenchBullet": 
			bullet = frenchBullet
			damage_amount = 0
			air_strike_damage = 15
			frenchBullet()
			air_strike = "Baguette"
			get_node("/root/global").ammunitionEvent = 1
		"atomBullet":
			bullet = atomBullet
			damage_amount = 0
			air_strike_damage = 50
			spawn_enola_gay = true
			get_node("/root/global").ammunitionEvent = 1
			print("enolaGay should spawn")
		"horseBullet":
			bullet = horseBullet
			damage_amount = 20
			get_node("/root/global").explode = true
		"sniperBullet":
			bullet = sniperBullet
			damage_amount = 50
	# instance chosen bulletType
	bullet.position = bullet_spawn
	bullet.angle = round_data[current_player][2]#shoot_angle
	bullet.shoot_speed = round_data[current_player][1]#shoot_power
	bullet.set_name("bullet" + round_data[current_player][0])
	print("speed: " + str(bullet.shoot_speed))
	print("winkel: " + str(bullet.angle))
	add_child(bullet)
	bullet_in_air = true

# Round functions
func check_if_dead():
	if round_data[current_player][3] <= 0:
		swap_to_next_player()
		print("this player is dead! swap to next")
	else:
		#hide_tracer()
		print("player still alive")

func swap_to_next_player():
	print("swap to next player")
	#update_round_data()
	var current_player_plus = current_player + 1
	if current_player_plus < player_amount:
		current_player += 1
	elif current_player_plus == player_amount:
		current_player = 0
	elif current_player == first_player:
		# start next round
		pass
	check_if_dead()
	print("after swap - current_player: " + str(current_player) + "  " + round_data[current_player][0])
	show_tracer()
	
	# paste round data in global round data
	get_node("/root/global").current_player = current_player
	get_node("/root/global").round_data = round_data
	get_node("/root/global").explode = false
	print("pasted players variables in script!")

func set_up_round_data():
	player_data = get_node("/root/global").player_data
	if round_data == []:
		for i in player_amount:
			var sub_number = i + 1
			round_data.append([player_data[i][0]])
			round_data[i].append(200) # Shoot power
			round_data[i].append(0) # Shoot angle
			round_data[i].append(100) # Player's health
			# round data looks like  [[player1, 200, 0, 100], [player2, 200, 0, 100], [player3, 200, 0, 100]]
		print("round_data: " + str(round_data))

func set_up_round_stats():
	round_stats = []
	for i in player_amount:
		round_stats.append([player_data[i][0]]) # 0: name
		round_stats[i].append(0) # 1: wins
		round_stats[i].append(0) # 2: kills
		round_stats[i].append(0) # 3: deaths
		round_stats[i].append(0) # 4: hits
		round_stats[i].append(0) # 5: money 
		round_stats[i].append(0) # 6: points
		# all to add at end of round
	print("round stats set")

func update_round_data():
	# Set global round_data to local one
	get_node("/root/global").round_data = round_data

func update_player_data(): #fixed
	# Do this after every full round when one player is left to save the points and money for shop
	get_node("/root/global").player_data = player_data

### INPUT FUNCTIONS ###
func change_cannon_power(amount):
	round_data[current_player][1] += amount * 0.33
	restrict_cannon_power(round_data[current_player][1])
	update_round_data()

func restrict_cannon_power(power):
	if power > 1000:
		power = 1000
	if power < 1:
		power = 1
	round_data[current_player][1] = power

func change_cannon_angle(amount, angle):
	get_node("/root/global").updateUIlabel = true
	angle += 0.33 * amount
	restrict_cannon_angle(angle)
	update_round_data()

func restrict_cannon_angle(angle):
	if angle < -180 or angle > 90:
		angle = -180
	elif angle > 0:
		angle = 0
	round_data[current_player][2] = angle

func flip_player(current_angle, node):
	if current_angle < -90:
		get_node(node).get_node("texture").flip_h = true
		get_node(node).get_node("cannon").position.x = -6.5
	elif current_angle > -90:
		get_node(node).get_node("texture").flip_h = false
		get_node(node).get_node("cannon").position.x = 6.5

func move_current_player(direction):
	get_node("/root/global").move_current_player = direction
	#print("direction: " + str(direction))
	pass

### HIT FUNCTIONS ###

func create_player_areas():
	for i in range(player_amount):
		var area = preload("res://bulletHit.tscn").instance()
		var node = get_node("/root/global").player_data[i][0]
		
		# Set the areas position to the players that it should match
		var area_pos = Vector2()
		area_pos = get_node(node).position
		
		# Set the areas name to the players one + Area
		var area_name = get_node("/root/global").player_data[i][0] + "Area"
		area.set_name(area_name)
		add_child(area)

func update_player_areas():
	for i in range(player_amount):
		if round_data[i][3] > 0:
			var areaNode = get_node("/root/global").player_data[i][0] + "Area"
			var playerNode = get_node("/root/global").player_data[i][0]
			get_node(areaNode).position = get_node(playerNode).position
		#print(str(player_data[i][0]) + " - playerNode position: " + str(get_node(playerNode).position) + " - areaNode position: " + str(get_node(areaNode).position))
	pass

func damage_player(amount, player):
	var hit_player = player
	var hit_player_int = 0
	# extract the players position in the array from the name
	for i in range(player_amount):
		if round_data[i][0] == hit_player:
			hit_player_int = i
	round_data[hit_player_int][3] -= amount
	if amount > 0:
		round_stats[current_player][4] += 1 # add 1 to the hits of player that has shot
	if round_data[hit_player_int][3] <= 0:
		die(hit_player_int)
		round_stats[hit_player_int][3] += 1 # add 1 to deaths of hit player
		round_stats[current_player][2] += 1 # add 1 to the kills of the current player
	get_node("/root/global").round_data = round_data
	

func go_on_game():
	if get_node("/root/global").ammunitionEvent == 2:
		hide_tracer()
		swap_to_next_player()
		can_shoot = true
		get_node("/root/global").ammunitionEvent = 0
		pass

func die(dead_player):
	get_node(round_data[dead_player][0]).queue_free()
	get_node(round_data[dead_player][0] + "Area").queue_free()
	get_node(round_data[dead_player][0] + "Tracer").queue_free()
	players_left -=1
	var die_sound = preload("res://audio/AudioPlayer.tscn").instance()
	die_sound.audio_num = 9
	add_child(die_sound)

### TRACER FUNCTIONS ###

func add_tracers():
	# Only add when it's the first shot of every player, after that just change
	for i in player_amount:
		var tracer = preload("res://ammunition/tracer.tscn").instance()
		var tracer_name = player_data[i][0] + "Tracer"
		tracer.set_name(tracer_name)
		tracer.points = []
		add_child(tracer)

func change_tracers():
	# first delete current dots for the current players one's
	# Then add the points every delta seconds while bullet is in air
	if bullet_in_air:
		var current_tracer = player_data[current_player][0] + "Tracer"
		var current_bullet = "bullet" + player_data[current_player][0]
		get_node(current_tracer).add_point(get_node(current_bullet).position)

func delete_tracer(): # begin of shoot
	# Only do this once before shooting but after "shoot" is pressed
	var current_tracer = player_data[current_player][0] + "Tracer"
	get_node(current_tracer).points = []
	print("deleted tracer: " + current_tracer)

func show_tracer(): # 
	# Show tracer after changing to the next player so it is his own
	if round_data[current_player][3] > 0:
		var current_tracer = player_data[current_player][0] + "Tracer"
		get_node(current_tracer).show()
	pass

func hide_tracer(): # when bullet hit sth
	# Hide tracers while changing to next player but before current_player is incremented
	var current_tracer = player_data[current_player][0] + "Tracer"
	get_node(current_tracer).hide()
	print("hide tracer: " + current_tracer)

### AMMUNITION FUNCTIONS ###

func change_ammunition():
	player_data = get_node("/root/global").player_data
	# 0: name; 1:color; 2:inventory; 3:last ammunition (number pointer)
	# inventory: [[999, "singleBullet"],[1, "frenchBullet"]]
	var inventory_array = player_data[current_player][2]
	var last_point = inventory_array.size() - 1
	var last_ammunition = player_data[current_player][3]
	print("inventory size: " + str(inventory_array.size()))
	print("last_point: " + str(last_point))
	print("last_ammunition: " + str(last_ammunition))
	var next_point = 0
	
	if last_ammunition < last_point:
		for i in range(inventory_array.size()):
			if last_ammunition + i + 1 < inventory_array.size():
				if inventory_array[last_ammunition + i + 1][0] > 0:
					next_point = last_ammunition + i + 1
					print("next_point: " + str(next_point))
					player_data[current_player][3] = next_point
					get_node("/root/global").player_data = player_data
					return
				else:
					pass
	else:
		next_point = 0
	
	player_data[current_player][3] = next_point
	print("next_point: " + str(next_point))
	get_node("/root/global").player_data = player_data
	pass

func substract_ammunition():
	var current_ammunition_amount = get_node("/root/global").player_data[get_node("/root/global").current_player][2][get_node("/root/global").player_data[get_node("/root/global").current_player][3]][0]
	current_ammunition_amount -= 1
	get_node("/root/global").player_data[get_node("/root/global").current_player][2][get_node("/root/global").player_data[get_node("/root/global").current_player][3]][0] = current_ammunition_amount
	if current_ammunition_amount == 0:
		change_ammunition()

func frenchBullet():
	#damage_player(5, round_data[current_player][0])
	var whiteFlag = preload("res://ammunition/whiteFlag.tscn").instance()
	whiteFlag.position = get_node(round_data[current_player][0]).position
	add_child(whiteFlag)

func japan():
	var whiteFlag = preload("res://ammunition/whiteFlag.tscn").instance()
	whiteFlag.position = get_node(get_node("/root/global").player_hit).position 
	add_child(whiteFlag)
	pass

func spawn_air_strike(type):
	print("spawn air-strike")
	if get_node("/root/global").bullet_ground_position != Vector2():
		print("bullet hit ground")
		var air_strike
		var nuke = ""
		match type:
			"": return
			"Baguette": 
				air_strike = preload("res://ammunition/Baguette.tscn").instance()
				get_node("/root/global").explode = true
			"fatMan": 
				air_strike = preload("res://ammunition/fatMan.tscn").instance()
				air_strike.position.y = 120
				japan()
				nuke = "Nuke"
		air_strike.position.x = get_node("/root/global").bullet_ground_position.x
		air_strike.set_name("airStrike" + nuke)
		add_child(air_strike)
		get_node("/root/global").bullet_ground_position = Vector2()

func spawn_enolaGay():
	if spawn_enola_gay == true:
		print("spawn enola gay")
		var enolaGay = preload("res://ammunition/enolaGay.tscn").instance()
		enolaGay.position = Vector2(window_width, 100)
		enolaGay.set_name("enolaGay")
		add_child(enolaGay)
		enolaGay_in_air = true
		spawn_enola_gay = false
		pass

func dropFatMan():
	if enolaGay_in_air == true:
		if get_node("enolaGay").position.x <= get_node("/root/global").bullet_ground_position.x:
			print("drop fat man")
			spawn_air_strike("fatMan")
			get_node("/root/global").bomb_fallen = true
			enolaGay_in_air = false
			print("bomb fallen!")

### SOUND FUNCTIONS ###

func select_next_time():
	randomize()
	var time = randi()%15 + 5
	$BackgroundTimer.wait_time = time
	$BackgroundTimer.start()

func _on_BackgroundTimer_timeout():
	play_background_audio()
	$WaitTimer.start()

func _on_WaitTimer_timeout():
	select_next_time()

func play_background_audio():
	var audioPlayer = preload("res://audio/AudioPlayer.tscn").instance()
	audioPlayer.audio_num = 10
	add_child(audioPlayer)

### END FUNCTIONS ###

func give_money():
	for i in player_amount:
		var money_add = 0
		money_add += 3000 * round_stats[i][1] # for wins
		money_add += 1000 * round_stats[i][2] # for kills
		money_add += 100 * round_stats[i][4] # for hits
		round_stats[i][5] = money_add
		var points_add = 0 #this isn't shown for players, just used for sorting after every round
		points_add += round_stats[i][4] # for hits (max 999)
		points_add += 1000 * round_stats[i][2] # for kills (max 999[000])
		points_add += 1000000 * round_stats[i][1] # for wins (no maximum)
		round_stats[i][6] = points_add
	pass

func add_round_stats():
	for i in player_amount:
		# player_data - # 0: name; 1:color; 2:inventory; 3:last ammunition (number pointer); 4: Wins; 5: Kills; 6: Deaths; 7: Hits; 8: Money
		# round_data - # 0: name, 1: wins, 2:kills, 3:deaths, 4:hits, 5: money
		player_data[i][4] += round_stats[i][1] # wins
		player_data[i][5] += round_stats[i][2] # kills
		player_data[i][6] += round_stats[i][3] # deaths
		player_data[i][7] += round_stats[i][4] # hits
		player_data[i][8] += round_stats[i][5] # money
		player_data[i][9] += round_stats[i][6] # points
	pass

func save():
	var save_dict = {
		player_data=player_data,
		player_amount=player_amount
	}
	return save_dict

func quit_round():
	if players_left == 1:
		round_stats[current_player][1] += 1 # add 1 to the wins of the current player
		# give players money
		give_money()
		# add the round stats to all
		add_round_stats()
		get_node("/root/global").save_game()
		get_node("/root/global").goto_scene("res://Statistics.tscn") # Change to anther menu between rounds here!
	else:
		pass
