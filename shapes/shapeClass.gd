extends Area2D

class_name ShapeClass

## Constants
#grabbed=currently being dragged by mouse
enum STATES {GRABBED, IDLE};

## Variables
var state : int = STATES.IDLE;
# Global position of where the shape rests when not being grabbed
var restingPos := Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the resting pos as the position spawned in at
	restingPos = global_position;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If grabbed, then follow the mouse. Otherwise return to resting pos
	if state == STATES.GRABBED:
		global_position = get_global_mouse_position();
	else:
		global_position = restingPos;

# Called when an input event occurs within the shape
func _on_input_event(viewport, event, shape_idx):
	# If the event involves a mouse button...
	if event is InputEventMouseButton:
		# If the event is the left button being pressed, then move to grabbed state
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			state = STATES.GRABBED;
		# If the event is the left button being released, then move to idle state
		elif event.button_index == BUTTON_LEFT and event.is_action_released("ui_left_mouse"):
			state = STATES.IDLE;
