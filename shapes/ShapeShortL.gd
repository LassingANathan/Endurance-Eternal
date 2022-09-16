extends "res://shapes/shapeClass.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Called when an input event occurs within the shape
func _on_input_event(viewport, event, shape_idx):
	# Call parent function
	._on_input_event(viewport, event, shape_idx);
