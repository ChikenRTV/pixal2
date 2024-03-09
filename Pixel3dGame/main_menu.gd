extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Move.play("Move")


func _on_button_pressed():
	$Second.visible = true
	$First.visible = false


func _on_check_button_pressed():
	print($CheckButton.button_pressed)
	Global.Rig_Det = $CheckButton.button_pressed







func _on_tutoril_pressed():
	get_tree().change_scene_to_file("res://Levels/level_0.tscn") 


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn") 


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Levels/level_2.tscn") 


func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://Levels/level_3.tscn") 
