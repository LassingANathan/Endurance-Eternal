extends "res://shapes/shapeClass.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set all distances
	disFromMainToTop = 1;
	disFromMainToRight = 2;
	disFromMainToBottom = 1;
	disFromMainToLeft = 1;
	
	# Set offsets for availableShapes pool
	horizontalOffset = -5;
	verticalOffset = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Attempts to place the shape on the grid
#gridBlock=the GridBlock to place the shape on
func placeShape(gridBlock) -> bool:
	# If the parent function returns false, then return false
	if (!.placeShape(gridBlock)):
		return false
	# Get filled blocks and coordinates of gridBlock
	var filledBlocks = get_tree().get_nodes_in_group("filled");
	var gridBlockRow = gridBlock.row;
	var gridBlockCol = gridBlock.col;
	
	# If all blocks on the grid that the shape overlaps are filled, then the shape can be placed. Empty the blocks and return true
	if (gridBlock in filledBlocks and \
	grid[gridBlockRow][gridBlockCol-1] in filledBlocks and \
	grid[gridBlockRow][gridBlockCol+1] in filledBlocks and \
	grid[gridBlockRow][gridBlockCol+2] in filledBlocks and \
	grid[gridBlockRow-1][gridBlockCol+1] in filledBlocks and \
	grid[gridBlockRow+1][gridBlockCol+1] in filledBlocks):
		# Wow this is ugly. Curly brackets for life
		gridBlock.setState(gridBlock.STATES.EMPTY);
		grid[gridBlockRow][gridBlockCol-1].setState(gridBlock.STATES.EMPTY);
		grid[gridBlockRow][gridBlockCol+1].setState(gridBlock.STATES.EMPTY);
		grid[gridBlockRow][gridBlockCol+2].setState(gridBlock.STATES.EMPTY);
		grid[gridBlockRow-1][gridBlockCol+1].setState(gridBlock.STATES.EMPTY);
		grid[gridBlockRow+1][gridBlockCol+1].setState(gridBlock.STATES.EMPTY);
		
		return true;
		
	return false

# Called when an input event occurs within the shape
func _on_input_event(viewport, event, shape_idx):
	# Call parent function
	._on_input_event(viewport, event, shape_idx);
