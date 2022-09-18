extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called when the play button is pressed
func _on_PlayButton_pressed():
	get_tree().change_scene("res://rooms/MainScene.tscn")
