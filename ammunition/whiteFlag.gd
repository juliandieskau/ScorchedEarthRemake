extends Sprite

var swing_right = true

func _ready():
	$flagTimer.start()

func _process(delta):
	swing_flag()
	if rotation_degrees >= 30:
		swing_right = false
	elif rotation_degrees <= -30:
		swing_right = true

func swing_flag():
	if swing_right == true:
		rotation_degrees += 2
		scale.x = 0.5
	elif swing_right == false:
		rotation_degrees -= 2
		scale.x = -0.5

func _on_flagTimer_timeout():
	queue_free()
