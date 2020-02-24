extends RigidBody2D

const scene_scoretext := preload("res://Scenes/Scoretext.tscn")
onready var Game = get_node("/root/Game")
var wait := 0.0
var target_veloc := Vector2()
var do_set_veloc := false
var stuck := true
const BASE_SPEED := 400.0
const MAX_SPEED := 800.0
const INC_SPEED := 10.0
var speed := 200.0
var no_contact_zone := 0.0

func _integrate_forces(state):
	if no_contact_zone <= 0.0 and not stuck:
		for i in range(state.get_contact_count()):
			var n = state.get_contact_local_normal(i)
			self.position = state.get_contact_local_position(i) + n * 16
			$Gfx.rotation = n.angle() + PI/2
			if wait <= 0.0:
				target_veloc = linear_velocity
			wait = 0.05
			no_contact_zone = 0.10
			$AnimationPlayer.stop()
			$AnimationPlayer.play("bounce")
	if do_set_veloc:
		state.linear_velocity = target_veloc
		do_set_veloc = false
	if wait <= 0.0 and not stuck:
		if state.linear_velocity.length() < 1e-5:
			state.linear_velocity = Vector2(0, 1)
		state.linear_velocity = state.linear_velocity.normalized() * speed
		if abs(state.linear_velocity.normalized().y) < 0.25:
			state.linear_velocity = state.linear_velocity.length() *\
			Vector2(state.linear_velocity.x, state.linear_velocity.y * 1.05).normalized()
		state.integrate_forces()
	else:
		state.linear_velocity = Vector2(0, 0)

func _ready():
	custom_integrator = true
	contact_monitor = true
	set_max_contacts_reported(4)
	$Particles2D.emitting = false
	wait = 0.0
	$AnimationPlayer.play("cool")

func _physics_process(delta):
	no_contact_zone -= delta
	if wait > 0.0:
		wait -= delta
		if wait <= 0.0:
			do_set_veloc = true
	$Particles2D.emitting = wait <= 0.0 and not stuck
	if position.y > get_viewport().get_size_override().y + 32.0 and not stuck:
		Game.change_lives(-1)
		queue_free()
	position.x = clamp(position.x, 0+6.0, 1024.0-6.0)
	if position.y < 6.0:
		position.y = 6.0

func _on_Ball_body_entered(body: PhysicsBody2D):
	if stuck:
		return
	if body.is_in_group("player"):
		$SndPaddleBounce.play()
		var dir = (global_position - body.global_position).normalized()
		target_veloc = speed * dir
		do_set_veloc = true
		body.do_anim()
	elif body.is_in_group("Tiles"):
		Game.change_score(body.points)
		var scoretext := scene_scoretext.instance()
		scoretext.set_amount(body.points)
		scoretext.position = body.global_position
		get_parent().add_child(scoretext)
		body.impact(global_position)
		speed = clamp(speed + INC_SPEED, BASE_SPEED, MAX_SPEED)
		$SndTileBreak.play()
		Game.add_screenshake(0.15)
	$SndBounce.play()

func shoot():
	apply_impulse(Vector2(0, 0), Vector2(0, -200))
	$Particles2D.emitting = true
	stuck = false
	wait = 0.0
	speed = BASE_SPEED
	$AnimationPlayer.play("cool")
