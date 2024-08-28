extends Sprite

var time = 0

func _ready():
	$AnimationPlayer.play("exploschion")
	$Timer.start()
	

func _process(delta):
	time += delta
	if time >= 2:
		$AudioStreamPlayer2D.volume_db -= 0.3

func _on_Timer_timeout():
	queue_free()
