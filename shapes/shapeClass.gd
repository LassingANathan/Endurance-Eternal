extends Area2D

class_name ShapeClass

# Signals
signal placed(shape)

## Constants
#grabbed=currently being dragged by mouse
enum STATES {GRABBED, IDLE};

## Variables
var state : int = STATES.IDLE;
# Global position of where the shape rests when not being grabbed
var restingPos := Vector2();
var gridHeight := -1;
var gridWidth := -1;
var grid := [];
var disFromMainToTop := -1; # Distance, in blocks, from the main block to the top block
var disFromMainToRight := -1; # Distance, in blocks, from the main block to the rightmost block
var disFromMainToBottom := -1; # Distance, in blocks, from the main block to the bottom block
var disFromMainToLeft := -1; # Distance, in blocks, from the main block to the leftmost block
var horizontalOffset := 0; # Horizontal Distance, in pixels, from the center of the mainBlock to the center of the whole shape.
						   # Negative value means the mainblock is to the left of the true center. Used to place correctly in availableShapes pool. 
var verticalOffset := 0; # Vertical version of above. Negative value means mainblock is above true center

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set grid dimensions
	gridHeight = grid.size();
	gridWidth = grid[0].size();
	# Set the resting pos as the position spawned at
	restingPos = global_position;
	# Set default z_index
	z_index = 1;
	
# Called after the shape has been added to the scene (also used to update position), initializes the shape_find_owner
#startingPos=the default position for the shape before adding offsets
func init(startingPos : Vector2):
	# Set the starting position and add offsets
	global_position = startingPos;
	global_position.x += horizontalOffset;
	global_position.y += verticalOffset;
	
	restingPos = global_position;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If grabbed, then follow the mouse. Otherwise return to resting pos
	if state == STATES.GRABBED:
		global_position = get_global_mouse_position();
	else:
		global_position = restingPos;

# Attempts to place the shape on the grid
#gridBlock=the GridBlock to place the shape on
func placeShape(gridBlock) -> bool:
	# Ensure placing the block won't leave the boundaries of the grid
	if gridBlock.row - disFromMainToTop < 0 or \
	   gridBlock.col + disFromMainToRight > gridWidth-1 or \
	   gridBlock.row + disFromMainToBottom > gridHeight-1 or \
	   gridBlock.col - disFromMainToLeft < 0:
		return false;
	return true;

# Called when an input event occurs within the shape
func _on_input_event(viewport, event, shape_idx):
	# If the event involves a mouse button...
	if event is InputEventMouseButton:
		# If the event is the left button being pressed, then move to grabbed state
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			state = STATES.GRABBED;
		# If the event is the left button being released, then place shape or move to idle state
		elif event.button_index == BUTTON_LEFT and event.is_action_released("ui_left_mouse"):
			# Iterate through the grid to see if the shape has been released on a GridBlock
			for row in range(gridHeight):
				for col in range(gridWidth):
					# If the current GridBlock had the mouse, then attempt to place the shape
					if grid[row][col].mouseEntered:
						# If the shape was placed, then return. Otherwise set state to idle and then return
						var shapePlaced = placeShape(grid[row][col]);
						if shapePlaced:
							emit_signal("placed", self);
							queue_free();
						state = STATES.IDLE;
						return
			# If no GridBlocks had the mouse, then the shape was not dropped on a GridBlock
			state = STATES.IDLE;
