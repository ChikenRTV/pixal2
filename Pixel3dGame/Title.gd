extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		$CharacterBody2D.velocity.y = -250
	else:
		$CharacterBody2D.velocity.y = -50
	$CharacterBody2D.move_and_slide()
	if $CharacterBody2D.position.y < -5000:
		get_tree().change_scene_to_file("res://main_menu.tscn") 
	



func _on_timer_timeout():
	get_tree().change_scene_to_file("res://main_menu.tscn") 
