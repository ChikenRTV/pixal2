extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("Fade_In")
	$LogoDark.visible = true
	await get_tree().create_timer(2.5).timeout
	$AnimationPlayer.play("Fade_Out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://main_menu.tscn")


