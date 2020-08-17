extends StaticBody # NPC per a quan vulgui PNJ enemics?
class_name Enemy

signal died(battler)

export var delay_sec: = 0.08
export var MAX_HEALTH: = 5

onready var audio = $AudioStreamPlayer

var health: = MAX_HEALTH
var died: = false


func take_damage(amount : int) -> void:
	if not health == 0:
		health -= amount
		health = max(0, health)
		$HealthBar3D.update(health)
		if health == 0:
			die()


func heal(amount : int) -> void:
	health += amount
	health = min(health, MAX_HEALTH)
	$HealthBar3D.update(health)


func die() -> void:
	emit_signal("died", self)
	
	$CollisionShape.disabled = true
	hide()
	died = true
	
	# Game feel
	Input.start_joy_vibration(0, 0.7, 0.3, 0.6)
	audio.play()
	
	# Pausa
	get_tree().paused = true
	yield(get_tree().create_timer(delay_sec), 'timeout') # -> EnemyAudio, SwordAudio i Music: pause mode = process
	get_tree().paused = false
	
	$Timer.start()


func respawn() -> void:
	if died:
		heal(MAX_HEALTH)
		
		$CollisionShape.disabled = false
		show()
		died = false
