extends Node2D

var player_amount = 2
var player_data = []

func _ready():
	player_amount = get_node("/root/global").player_amount
	player_data = get_node("/root/global").player_data # 0: name; 1:color; 2:inventory; 3:last ammunition (number pointer); 4: Wins; 5: Kills; 6: Deaths; 7: Hits; 8: Money; 9: points for sorting
	sort_statistic_lines()
	
	add_StatisitcFields()

func add_StatisitcFields():
	for i in player_amount:
		# Only have to set the y-coordinate
		var y_pos = (i * 45) + ((270 - (45 * player_amount)) / (player_amount + 1))
		var new_line_position = Vector2($LineField.rect_position.x, $LineField.rect_position.y + y_pos)
		
		var new_line = preload("res://StatisticLine.tscn").instance()
		new_line.set_name("PlayerLine" + str(i + 1))
		new_line.get_node("Name").text = player_data[i][0]
		new_line.get_node("Wins").text = str(player_data[i][4])
		new_line.get_node("Kills").text = str(player_data[i][5])
		new_line.get_node("Deaths").text = str(player_data[i][6])
		new_line.get_node("Hits").text = str(player_data[i][7])
		new_line.get_node("Money").text = str(player_data[i][8])
		new_line.rect_position = new_line_position
		add_child(new_line)
		pass
	pass

func _process(delta):
	var mouse_left = Input.is_action_pressed("mouse_left")
	if mouse_left:
		get_node("/root/global").goto_scene("res://Shop.tscn")
	pass


class PointSorter:
	static func sort(a, b):
		if a[9] > b[9]:
			return true
		return false


func sort_statistic_lines():
	player_data.sort_custom(PointSorter, "sort")
	# this isnt updated in the game, just changing the order of the players in the array locally to display in that order