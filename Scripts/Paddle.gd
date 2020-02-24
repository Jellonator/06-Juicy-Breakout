extends KinematicBody2D

const WIDTH := 144.0
const scene_ball := preload("res://Scenes/Ball.tscn")
var ball: RigidBody2D
onready var node_position := $Position2D
onready var node_eyes := $Gfx/eyebase
onready var node_pupil1 := $Gfx/eyebase/pupil
onready var node_pupil2 := $Gfx/eyebase/pupil2
onready var node_gfx := $Gfx

const LOOK_BALL := 0
const LOOK_LEFT := 1
const LOOK_RIGHT := 2
const LOOK_INTO_SOUL := 3

const LOOK_RADIUS := 6.0

var looking := LOOK_LEFT
var look_timer := 1.0

onready var original_y := position.y
var squash_factor := 1.0
var squash_veloc := 0.0

func _ready():
	self.position.y += 200

func _physics_process(delta):
	# Anxiety eyes
	var amount := 0.5
	var balls = get_tree().get_nodes_in_group("ball")
	if balls.size() > 0:
		var ball = balls[0]
		if not ball.stuck:
			var balldis = (ball.global_position - global_position).length()
			amount = clamp(10.0 / sqrt(balldis), 0.75, 4.0)
	node_eyes.offset = Vector2(rand_range(-amount, amount), rand_range(-amount, amount))
	node_pupil1.offset = node_eyes.offset + Vector2(rand_range(-amount, amount), rand_range(-amount, amount))
	node_pupil2.offset = node_pupil1.offset
	var lookdir := Vector2(0, 0)
	var looklen := LOOK_RADIUS
	if looking == LOOK_LEFT:
		lookdir = Vector2(-1, 0)
	elif looking == LOOK_RIGHT:
		lookdir = Vector2(1, 0)
	elif looking == LOOK_BALL:
		if balls.size() > 0:
			var ball = balls[0]
			lookdir = (ball.global_position - global_position).normalized()
	node_pupil1.offset += lookdir * looklen
	node_pupil2.offset += lookdir * looklen
	look_timer -= delta
	if look_timer < 0.0:
		look_timer = rand_range(0.15, 1.5)
		looking = randi() % 4
	# Movement
	var view = get_viewport().get_visible_rect().size
	var target = get_viewport().get_mouse_position().x
	if target < WIDTH / 2:
		target = WIDTH / 2
	if target > view.x - WIDTH / 2:
		target = view.x - WIDTH / 2
	var movement = (target - position.x)
	position = Vector2(target, position.y)
	# SQUASH
	var target_squash := abs(movement) / 100.0 + 1.0
	var squash_diff := target_squash - squash_factor
	squash_factor += (squash_veloc + squash_diff) * delta * 15.0
	squash_veloc += squash_diff * delta * 15.0
	var real_squash = clamp(squash_factor, 0.1, 10.0)
	node_gfx.scale = Vector2(real_squash, 1.0/real_squash)
	# Retrieve ball
	if get_tree().get_nodes_in_group("ball").size() == 0:
		position.y += delta * 100
		if position.y > 680:
			ball = scene_ball.instance() as RigidBody2D
			ball.position = node_position.global_position
			ball.mode = RigidBody2D.MODE_KINEMATIC
			get_parent().add_child(ball)
	if ball != null:
		self.position.y = max(position.y - delta * 100, original_y)
		ball.global_position = node_position.global_position
		if Input.is_action_just_pressed("action_spawn") and abs(position.y - original_y) < 1e-3:
			ball.mode = RigidBody2D.MODE_CHARACTER
			ball.shoot()
			ball = null
			do_anim()

func do_anim():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("bounce")
