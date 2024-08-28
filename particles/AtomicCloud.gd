extends Sprite

var damaged_players = []
var timer_running = false

func _ready():
	$AnimationPlayer.play("atomicCloud")
	$Timer.start()

func _process(delta):
	var delta_var = delta
	if not damaged_players.empty():
		if timer_running == false:
			#print("damaged players isn't empty!")
			$DamageTimer.start()
			timer_running = true

func _on_Timer_timeout():
	queue_free()

func _on_Area2D_area_entered(area):
	print(area.name + " area entered atomicCloud")
	if area.name.ends_with("Area"):
		print("area ends with Area")
		damaged_players.append(area.name.trim_suffix("Area"))
		print("")
		print("damaged_players: " + str(damaged_players))

func _on_DamageTimer_timeout():
	print("damage timer timeout")
	get_node("/root/global").air_strike_hit = true
	get_node("/root/global").player_hit = damaged_players[0]
	print("damaged player: " + get_node("/root/global").player_hit)
	damaged_players.remove(0)
	timer_running = false
