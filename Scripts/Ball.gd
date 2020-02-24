extends RigidBody2D

onready var Game = get_node("/root/Game")
var wait := 0.0
var target_veloc := Vector2()
var do_set_veloc := false
var stuck := true
const BASE_SPEED := 200.0
const MAX_SPEED := 600.0
const INC_SPEED := 10.0
var speed := 200.0

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var n = state.get_contact_local_normal(i)
		self.position = state.get_contact_local_position(i) + n * 16
		$Gfx.rotation = n.angle() + PI/2
		wait = 0.2
		target_veloc = linear_velocity
		$AnimationPlayer.stop()
		$AnimationPlayer.play("bounce")
	if do_set_veloc:
		state.linear_velocity = target_veloc
		do_set_veloc = false
	if wait <= 0.0:
		state.linear_velocity = state.linear_velocity.normalized() * speed
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
	if wait > 0.0:
		wait -= delta
		if wait <= 0.0:
			do_set_veloc = true
	$Particles2D.emitting = wait <= 0.0 and not stuck
	if position.y > get_viewport().get_size_override().y:
		Game.change_lives(-1)
		queue_free()

func _on_Ball_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player"):
		var dir = (global_position - body.global_position).normalized()
		linear_velocity = linear_velocity.length() * dir
	if body.is_in_group("Tiles"):
		Game.change_score(body.points)
		body.impact(global_position)
	speed = clamp(speed + INC_SPEED, BASE_SPEED, MAX_SPEED)

func shoot():
	apply_impulse(Vector2(0, 0), Vector2(-200, -200))
	$Particles2D.emitting = true
	stuck = false
	wait = 0.0
	speed = BASE_SPEED
	$AnimationPlayer.play("cool")
