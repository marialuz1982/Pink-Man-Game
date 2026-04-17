extends Control
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options


# Called when the node enters the scene tree for the first time.
func _ready():
	main_buttons.visible = true
	options.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_settings_pressed() -> void:
	main_buttons.visible = false
	options.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_options_pressed() -> void:
	_ready()


func _on_audio_control_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_fullscreen_control_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_scale_control_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_sound_control_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	$HowToPlayPanel.visible = false
	_ready()


func _on_play_pressed() -> void:
	$HowToPlayPanel.visible = true
	$Options.visible = false
	$MainButtons.visible = false

func win():
	get_tree().paused = true
	$HUD/WinPanel.visible = true
