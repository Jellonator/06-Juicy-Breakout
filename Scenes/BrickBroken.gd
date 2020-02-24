extends Node2D

var velocity := Vector2()
var angular_velocty := 0.0

func _ready():
	angular_velocty = rand_range(-PI/2, PI/2)

func _physics_process(delta):
	position += velocity * delta
	velocity += Vector2(0, 1600) * delta
	if global_position.y > 1000:
		queue_free()
	rotation += angular_velocty * delta

func set_region(region: Rect2):
	$Sprite.region_enabled = true
	$Sprite.region_rect = region
