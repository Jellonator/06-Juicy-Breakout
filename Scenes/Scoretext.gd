extends Node2D

func set_amount(score: int):
	$Label.text = str(score)

const COLORS := [Color.white, Color.yellow]
var color_i := 0
var color_t := 0.0
var life := 1.0

func _physics_process(delta):
	color_t -= delta * 15.0
	if color_t <= 0.0:
		color_t += 1.0
		color_i = (color_i + 1) % COLORS.size()
		modulate = COLORS[color_i]
	life -= delta
	if life <= 0.0:
		queue_free()
	self.position += Vector2(0, -16) * delta
