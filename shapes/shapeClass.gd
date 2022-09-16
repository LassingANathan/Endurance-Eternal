extends Area2D

class_name ShapeClass

## Constants
#grabbed=currently being dragged by mouse
enum STATES {GRABBED, IDLE};

## Variables
var state : int = STATES.IDLE;
# global position of where the shape rests when not being grabbed
var restingPos := Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
