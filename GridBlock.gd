extends Area2D

## Constants
#empty=black, filled=white, fillNext=will be filled next turn
enum STATES {EMPTY, FILLED, DANGER1, DANGER2, DANGER3, FILLNEXT}

## Variables
var state : = 0 #default is zero, i.e., STATES.EMPTY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Called by __on_GridBlock_input_event() when the GridBlock is left clicked
func clicked():
	# Change to filled state
	self.changeState(STATES.FILLED);

# Updates the GridBlock's state to the new given state
#newState=the STATES value of the new state
func changeState(newState : int):
	state = newState
	match newState:
		STATES.EMPTY:
			$AnimatedSprite.animation = "empty"
		STATES.FILLED:
			$AnimatedSprite.animation = "filled"
		STATES.DANGER1:
			$AnimatedSprite.animation = "danger1"
		STATES.DANGER2:
			$AnimatedSprite.animation = "danger2"
		STATES.DANGER3:
			$AnimatedSprite.animation = "danger3"
		STATES.FILLNEXT:
			$AnimatedSprite.animation = "fillnext"

# Called when an input event happens within this GridBlock
func _on_GridBlock_input_event(viewport, event, shape_idx):
	# If the event involves a mouse button...
	if event is InputEventMouseButton:
		# If the event is the left button being pressed, then the object was clicked
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			self.clicked();
