extends KinematicBody
class_name Player

export var cam: NodePath

onready var sword: = $PlayerMesh/Skeleton/BackAttachment/Sword
onready var back_attachment: = $PlayerMesh/Skeleton/BackAttachment
onready var hand_attachment: = $PlayerMesh/Skeleton/HandAttachment

onready var jump_timer: = $JumpTimer
onready var dodge_timer: = $DodgeTimer
onready var animation_player: = $PlayerMesh/AnimationPlayer
onready var interaction: = $Interaction

var _velocity: = Vector3()
var _direction: = Vector3()

var _gravity: = -9.8 * 4
var _jump_height: = 14
var _can_jump: = true

var _can_dodge: = true

var has_contact: = true

const MAX_SPEED: = 5
const MAX_RUNNING_SPEED: = 9
const ACCEL: = 2 # 3
const DEACCEL: = 8 # 6

const MAX_SLOPE_ANGLE: = 35

const ROTATE_SPEED: = 10

enum States { CINEMATIC, INTERACT, FOCUSED, ATTACK, ATTACKING }
var current_state = States.INTERACT

const MAX_COMBO: = 2 # + 1

var combo: = false
var current_combo: = 0


func _ready() -> void:
	jump_timer.connect("timeout", self, "_on_JumpTimer_timeout")
	dodge_timer.connect("timeout", self, "_on_DodgeTimer_timeout")
	animation_player.connect("animation_finished", self, "_on_animation_finished")


func change_state(new_state : int) -> void:
	if current_state == States.ATTACKING:
		sword.get_node("AnimationPlayer").play("default")
	
	if new_state == States.ATTACK and current_state == States.INTERACT:
		_draw_sword()
		
	elif new_state == States.INTERACT:
		if current_state == States.ATTACK or current_state == States.ATTACKING:
			_sheath_sword()
		
	elif new_state == States.ATTACKING:
		sword.get_node("AnimationPlayer").play("slash", -1, 1.5)
		combo = false
		print("Combo: ", current_combo)
	
	current_state = new_state


func _process(delta : float) -> void:
	match current_state:
		States.INTERACT:
			if Input.is_action_just_pressed("interact"):
				interaction.interact()
				
			elif Input.is_action_just_pressed("attack"):
				change_state(States.ATTACK)
		
		States.ATTACK:
			if Input.is_action_just_pressed("attack"):
				change_state(States.ATTACKING)
				
			elif Input.is_action_just_pressed("interact"):
				change_state(States.INTERACT)
		
		States.ATTACKING:
			if Input.is_action_just_pressed("attack") and current_combo < MAX_COMBO:
				combo = true


func _physics_process(delta):
	if current_state != States.CINEMATIC:
		_walk(delta)
		_rotate(delta)
	else:
		_velocity = Vector3()
		_direction = Vector3()
	_set_anim()


func _walk(delta):
	_direction = Vector3()
	
	var aim = get_node(cam).get_global_transform().basis
	var input = U.get_input_strenght()
	
	if current_state != States.ATTACKING and _can_dodge:
		_direction += aim.z * input.y
		_direction += aim.x * input.x
	
	_direction.y = 0
	_direction = _direction.normalized()
	
	if is_on_floor():
		has_contact = true
		var normal = $Tail.get_collision_normal()
		var floor_angle = rad2deg(acos(normal.dot(Vector3.UP)))
		if floor_angle > MAX_SLOPE_ANGLE:
			_velocity.y += _gravity * delta
		if not _can_jump and jump_timer.is_stopped():
			jump_timer.start()
	else:
		if not $Tail.is_colliding():
			has_contact = false
		_velocity.y += _gravity * delta
	
	if has_contact and not is_on_floor():
		move_and_collide(Vector3(0, -1, 0))
	
	var temp_velocity = _velocity
	temp_velocity.y = 0
	
	var speed
	speed = MAX_RUNNING_SPEED if Input.is_action_pressed("run") else MAX_SPEED
	
	var target = _direction * speed
	
	var acceleration
	acceleration = ACCEL if _direction.dot(temp_velocity) > 0 else DEACCEL
	
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	_velocity.x = temp_velocity.x
	_velocity.z = temp_velocity.z
	
	if _can_jump and has_contact and Input.is_action_just_pressed("jump"):
		if not (current_state == States.ATTACKING or current_state == States.ATTACK):
			_velocity.y = _jump_height
			has_contact = false
			_can_jump = false
		
		"""
		elif _can_dodge: # evadir, per ara només llarg
			var impulse_direction: Vector3 = _direction if _direction else get_global_transform().basis.z * -1
			_velocity = impulse_direction * 25
			_can_dodge = false
			dodge_timer.start()
		"""
	
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, deg2rad(MAX_SLOPE_ANGLE))


func _on_JumpTimer_timeout() -> void:
	_can_jump = true


func _on_DodgeTimer_timeout() -> void:
	_can_dodge = true


func _rotate(delta):
	if _direction:
		var angle = atan2(_direction.x, _direction.z)
		
		var q_from = Quat(global_transform.basis)
		var q_to = Quat(Basis(Vector3(0, angle, 0)))
		
		global_transform.basis = Basis(q_from.slerp(q_to, delta * ROTATE_SPEED))


func _set_anim():
	# input -> velocitat
	if current_state == States.ATTACKING:
		if animation_player.current_animation != "sword_slash":
			animation_player.play("sword_slash", -1, 1.5)
			
	elif not has_contact:
		animation_player.play("falling")
		
	elif _direction:
		if Input.is_action_pressed("run"):
			animation_player.play("running")
			
		else:
			animation_player.play("walking")
			
	else:
		animation_player.play("idle")


func _draw_sword():
	back_attachment.remove_child(sword)
	hand_attachment.add_child(sword)
	sword.translation = Vector3(-0.55, 0, 0)
	sword.rotation_degrees = Vector3(0, -90, 0)


func _sheath_sword():
	hand_attachment.remove_child(sword)
	back_attachment.add_child(sword)
	sword.translation = Vector3(0, -0.05, -0.15)
	sword.rotation_degrees = Vector3(-60, -90, 90)


func _on_animation_finished(anim_name):
	if anim_name == "sword_slash":
		if combo:
			current_combo += 1
			change_state(States.ATTACKING)
		else:
			current_combo = 0
			change_state(States.ATTACK)
