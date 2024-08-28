extends Node2D

### VARIABLES ###

var player_amount = 2

### GODOT FUNCTIONS ###

func _ready():
	$player_amount_label.text = "2 players"
	$player_amount_label.hide()
	$amount_down.hide()
	$amount_up.hide()
	$start_new_game.hide()
	$controlsContainer.hide()

### BUTTON CONTROLS ###

func _on_new_game_pressed():
	get_node("/root/global").player_amount = player_amount
	$player_amount_label.show()
	$amount_down.show()
	$amount_up.show()
	$start_new_game.show()
	$new_game.hide()
	$load_game.hide()
	$controlsContainer.hide()


func _on_start_new_game_pressed():
	get_node("/root/global").save_game()
	get_node("/root/global").goto_scene("res://NewGame_Menu.tscn")


func _on_load_game_pressed():
	var file2Check = File.new()
	var doFileExists = file2Check.file_exists("res://save.json")
	if doFileExists:
		var load_game = preload("res://LoadGame.tscn").instance()
		add_child(load_game)
		get_node("/root/global").goto_scene("res://Statistics.tscn")
	else:
		$yeet.show()


func _on_amount_up_pressed():
	if player_amount < 6:
		player_amount += 1
	$player_amount_label.text = str(player_amount) + " players"
	get_node("/root/global").player_amount = player_amount
	print("player_amount = " + str(player_amount))


func _on_amount_down_pressed():
	if player_amount > 2:
		player_amount -= 1
	$player_amount_label.text = str(player_amount) + " players"
	get_node("/root/global").player_amount = player_amount
	print("player_amount = " + str(player_amount))


func _on_Button_pressed():
	$yeet.hide()


func _on_controls_pressed():
	$controlsContainer.show()


func _on_Close_pressed():
	$controlsContainer.hide()
