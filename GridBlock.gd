extends Area2D

## Signals
# Emitted when clicked.
signal clicked()

## Constants
#empty=black, filled=white, fillNext=will be filled next turn
enum STATES {EMPTY, FILLED, DANGER1, DANGER2, DANGER3, FILL_NEXT}

## Variables
var state := 0; # Current state. default is zero, i.e., STATES.EMPTY
var col := -1; # The column of the GridBlock
var row := -1; # The row of the GridBlock
var gridWidth := -1; # The width of the grid in GridBlocks
var gridHeight := -1; # The height of the grid in GridBlocks
var grid := []; # The grid this GridBlock is a part of
var mouseEntered := false; # Holds whether or not the mouse is currently touching the GridBlock

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Returns true if all 8 GridBlocks surrounding this GridBlock is filled
func isSurrounded() -> bool:
	# If on borders, this GridBlock can never be surrounded
	if (row == 0 or col == 0 or row == gridHeight - 1 or col == gridWidth - 1):
		return false
	else:
		# Get all filled blocks (includes danger blocks)
		var filledBlocks = get_tree().get_nodes_in_group("filled");
		# Return true if all 8 surrounding GridBlocks are filled
		return grid[row-1][col-1] in filledBlocks and grid[row-1][col] in filledBlocks and grid[row-1][col+1] in filledBlocks \
		   and grid[row][col-1] in filledBlocks and grid[row][col+1] in filledBlocks \
		   and grid[row+1][col-1] in filledBlocks and grid[row+1][col] in filledBlocks and grid[row+1][col+1] in filledBlocks;

# Called by __on_GridBlock_input_event() when the GridBlock is left clicked
func clicked():
	# Change to filled state
	self.setState(STATES.FILLED);
	emit_signal("clicked")

# Updates the GridBlock's state to the new given state
#newState=the STATES value of the new state
func setState(newState : int):
	state = newState
	match newState:
		STATES.EMPTY:
			$AnimatedSprite.animation = "empty";
			if self.is_in_group("filled"):
				self.remove_from_group("filled");
		STATES.FILLED:
			$AnimatedSprite.animation = "filled";
			self.add_to_group("filled");
			if self.is_in_group("fillNext"):
				self.remove_from_group("fillNext")
		# NOTE: Danger states count as filled, so they are not removed from filled group
		STATES.DANGER1:
			$AnimatedSprite.animation = "danger1";
		STATES.DANGER2:
			$AnimatedSprite.animation = "danger2";
		STATES.DANGER3:
			$AnimatedSprite.animation = "danger3";
		STATES.FILL_NEXT:
			$AnimatedSprite.animation = "fillNext";
			self.add_to_group("fillNext");

# Called when an input event happens within this GridBlock
func _on_GridBlock_input_event(viewport, event, shape_idx):
	# If the event involves a mouse button...
	if event is InputEventMouseButton:
		# If the event is the left button being pressed, then the object was clicked
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			self.clicked();

# Called when the mouse enters this GridBlock
func _on_GridBlock_mouse_entered():
	mouseEntered = true;

# Called when the mouse leaves this GridBlock
func _on_GridBlock_mouse_exited():
	mouseEntered = false;
