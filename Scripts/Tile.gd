extends StaticBody2D

const scene_break := preload("res://Scenes/BrickBroken.tscn")

var points = 10
const DIV_X := 4
const DIV_Y := 2
onready var original_position = self.global_position

func _ready():
	global_position = global_position - Vector2(0, rand_range(600.0, 1200.0))

func _physics_process(delta):
	var speed = delta * 800
	var diff = original_position - global_position
	if diff.length() < speed:
		global_position = original_position
	else:
		global_position += diff.normalized() * speed

func impact(frompos: Vector2):
	var sprite := $Sprite
	var w := 64.0/DIV_X
	var h := 32.0/DIV_Y
	for ix in range(DIV_X):
		for iy in range(DIV_Y):
			var rect := Rect2(ix*w, iy*h, w, h)
			var inst := scene_break.instance()
			get_parent().add_child(inst)
			inst.global_position = global_position + rect.position\
				- Vector2(32.0, 16.0) + Vector2(w, h)/2
			inst.set_region(rect)
			var speed = 5000.0 / (inst.global_position - frompos).length()
			inst.velocity = (inst.global_position - frompos).normalized() * speed +\
					Vector2(rand_range(-10.0, 10.0), rand_range(-10.0, 10.0))
			inst.modulate = self.modulate
	queue_free()
