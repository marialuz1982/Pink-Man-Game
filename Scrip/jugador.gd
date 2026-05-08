extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true
var can_move = true



func _physics_process(delta: float) -> void:
	if !alive:
		return
	#Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jump"

	if can_move:
		# Handle jump.
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			jump_sound.play()

		# Movimiento
		var direction = Input.get_axis("left", "right")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if direction > 0:
			animated_sprite_2d.flip_h = false
		elif direction < 0:
			animated_sprite_2d.flip_h = true


#func _on_fall_zone_body_entered(body: Node2D) -> void:
	#if body == self:
		#get_tree().current_scene.lose_life()


func _on_fall_zone_body_entered(body: Node2D) -> void:
	print("Cae")
	if body.name == "Jugador" and body.alive:
		emit_signal("player_died", body)
	if body.name == "Jugador":
		get_tree().current_scene.lose_life()
		#print("toqué al jugador")
	#if body.name == "Jugador":
		#get_tree().current_scene.lose_life()
