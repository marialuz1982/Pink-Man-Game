extends Area2D
@onready var key: AudioStreamPlayer2D = $Key


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		$Key.play()
		await get_tree().create_timer(0.5).timeout
		#print("llave recogida")
		Global.has_key = true
		queue_free()
