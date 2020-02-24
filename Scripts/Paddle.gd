extends KinematicBody2D

const WIDTH := 144.0
const scene_ball := preload("res://Scenes/Ball.tscn")
var ball: RigidBody2D
onready var node_position := $Position2D

func _physics_process(delta):
	var view = get_viewport().get_visible_rect().size
	var target = get_viewport().get_mouse_position().x
	if target < WIDTH / 2:
		target = WIDTH / 2
	if target > view.x - WIDTH / 2:
		target = view.x - WIDTH / 2
	position = Vector2(target, position.y)
	if get_tree().get_nodes_in_group("ball").size() == 0:
		ball = scene_ball.instance() as RigidBody2D
		ball.position = node_position.global_position
		ball.mode = RigidBody2D.MODE_KINEMATIC
		get_parent().add_child(ball)
	if ball != null:
		ball.global_position = node_position.global_position
		if Input.is_action_just_pressed("action_spawn"):
			ball.mode = RigidBody2D.MODE_CHARACTER
			ball.shoot()
			ball = null
			do_anim()

func do_anim():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("bounce")
