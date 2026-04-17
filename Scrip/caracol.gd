extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal player_died
const SPEED = 30.0
@export var direction =  -1.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# C alled   every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta


func _on_timer_timeout() -> void:
	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_body_entered(body: Node2D) -> void:	
	
	if body.name == "Jugador" and body.alive:
		$LoseLifeSound.play()
		await get_tree().create_timer(0.2).timeout
		#get_tree().current_scene.get_node("LoseLifeSound").play()
		emit_signal("player_died", body)
	if body.name == "Jugador":		
		get_tree().current_scene.lose_life()
		#print("toqué al jugador")
	
	 
	
