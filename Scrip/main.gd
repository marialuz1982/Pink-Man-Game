extends Node2D
#@onready var game_over_sound: AudioStreamPlayer2D = $GameOverSound
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var fade: ColorRect = $HUD/Fade
@onready var game_over_sound: AudioStreamPlayer2D = $GameOverSound
@onready var win_sound: AudioStreamPlayer2D = $WinSound



var score: int = 0
var current_level_root: Node = null 
const key_level = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$HUD/UIRoot/GameOverPanel.visible = false
	load_hearts()
	#Setup the level
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(Global.level, true, false)	

#LEVEL MANAGMENT
func _load_level(level_number: int, first_load: bool, reset_score: bool ) -> void:
	#Fade out
	if not first_load:
		await _fade(1.0)
	if reset_score:
		score = 0
		score_label.text = "SCORE: 0"
	if current_level_root:
		current_level_root.queue_free()
	#Change level
	var level_path = "res://scenes/Levels/level%s.tscn" %level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)	
	#Fade in
	await _fade(0.0)

func _setup_level(level_root: Node) -> void:
	#Connet Exit
	var exit =  level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)		
	#Connect apples
	var apples =  level_root.get_node_or_null("Apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
	#Connect enemies
	var enemies =  level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
			
### SEÑALES
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":		
		if Global.level == key_level and not Global.has_key:
			print("necesitás la llave")
			body.position.x -= 80
			#$HUD/MessageKey.visible = true
			$HUD/MessagePanel.visible = true
			await get_tree().create_timer(1.5).timeout
			$HUD/MessagePanel.visible = false	
			#get_tree().current_scene.get_node("LevelRoot/MessageKey").visible = true
			#$LevelRoot/MessageKey.call_deferred("set_visible", true)
			
			# $LevelRoot/MessageKey.visible = true
			
			return
		Global.level += 1
		Global.has_key = false
		#print(level)
		var level_path = "res://scenes/Levels/level%s.tscn" % Global.level
		if not ResourceLoader.exists(level_path):
			win()
			return		
		#body.can_move = false
		await _load_level(Global.level, false,false)
		
func win():
	get_tree().paused = true
	$HUD/WinPanel.visible = true
	win_sound.play()

func _on_player_died(body):
	#print("Muerto")
	body.die()
	await _load_level(Global.level, false, true)
	
  ###SCORE
func increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" % score
	
	##FADE
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade,"modulate:a", to_alpha,1.5)
	await tween.finished
	
	###LIVES
func load_hearts():
	var container = $HUD/ScorePanel/HeartsContainer	
	#  Limpiar corazones anteriores
	for child in container.get_children():
		child.queue_free()	
	# Cargar escena del corazón
	var heart_scene = preload("res://scenes/heart.tscn")	
	#  Crear corazones según vidas
	for i in range(Global.lives):
		var heart = heart_scene.instantiate()
		container.add_child(heart)
func _reload_level():
	#call_deferred("_do_reload_level")
	get_tree().reload_current_scene()
	
func _do_reload_level():
	var level_path = "res://scenes/Levels/level%s.tscn" % Global.level
	get_tree().change_scene_to_file(level_path)
	
	#Perder vidas
func lose_life():
	#print("pierde vida")
	Global.lives -= 1	
	#print("vidas:", Global.lives)
	load_hearts()	
	if Global.lives <= 0:		
		game_over()
	else:
		_reload_level()
	
func game_over():
	#print("GAME OVER")
	game_over_sound.play()
	get_tree().paused = true	
	#$HUD/UIRoot.GameOverPanel.process_mode = Node.PROCESS_MODE_ALWAYS
	$HUD/GameOverPanel.visible = true
	#$GameOverSound.play()
	

	
	
#func _input(event):
	#if event.is_action_pressed("ui_accept"): # Enter o espacio
	#	lose_life()


func _on_start_pressed() -> void:
	get_tree().paused = false
	Global.reset_lives()
	Global.level = 1
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://control.tscn")
