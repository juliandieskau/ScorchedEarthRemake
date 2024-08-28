extends AudioStreamPlayer

### VARIABLES ###

var audio_num = 0

### FUNCTIONS ###

func _ready():
	load_sound()
	play_sound()

func load_sound():
	var sound = ""
	match audio_num:
		0: 
			sound = preload("res://audio/atomic_bomb.wav")
		1: 
			sound = preload("res://audio/bomb.wav")
		2: 
			sound = preload("res://audio/driving.wav")
		3: 
			sound = preload("res://audio/missile.wav")
			volume_db = -20
			$Timer.wait_time = 14
			$Timer.start()
		4: 
			sound = preload("res://audio/plane_squadron.wav")
		5: 
			sound = preload("res://audio/sniper shot.wav")
		6: 
			sound = preload("res://audio/sniper2.wav")
		7: 
			sound = preload("res://audio/sonic_boom.wav")
		8: 
			sound = preload("res://audio/x-plosion.wav")
		9:
			sound = preload("res://audio/ghast_death.wav")
			volume_db = 5
			$Timer.wait_time = 5
			$Timer.start()
		10: 
			sound = preload("res://audio/gun_battle.wav")
			volume_db = -40
			$Timer.wait_time = 18
			$Timer.start()
	stream = sound

func play_sound():
	playing = true
	pass

func _on_Timer_timeout():
	queue_free()
