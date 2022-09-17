extends Node

export (PackedScene) var GridBlock;
export (PackedScene) var ShapeShortL;
export (PackedScene) var ShapeReverseShortL;
export (PackedScene) var ShapeI;

## Constants
export (int) var gridWidth := 0; # In gridblocks
export (int) var gridHeight := 0; # In gridblocks
export (int) var gridBlockWidth := 0; # In pixels
export (int) var gridBlockHeight := 0; # In pixels

var ALL_SHAPES = [] # Holds every shape in the game, instantiated in _ready()

var AVAILABLE_SHAPES_POSITIONS = [Vector2(95, 250), Vector2(95, 200), Vector2(95, 150)] # Holds the global coordinates of the shapes that are available

## Variables
var grid := [];
var clickAdvancesTurn := false; # boolean for whether clicks should advance a turn. Allows the starting fill block to be filled without advancing a turn
var availableShapes := [null, null, null]; # Holds the available shapes

# Called when the node enters the scene tree for the first time.
func _ready():
	# Fill the grid with GridBlocks
	createGrid(grid, gridHeight, gridWidth, gridBlockHeight, gridBlockWidth, Vector2(161,60));
	ALL_SHAPES = [ShapeShortL, ShapeReverseShortL, ShapeI]

	# Choose a random GridBlock to set as filled at the start
	var rand = RandomNumberGenerator.new();
	var startingGridBlock = grid[rand.randi_range(0,gridHeight-1)][rand.randi_range(0,gridWidth-1)]
	startingGridBlock.clicked()
	clickAdvancesTurn = true;
	
	# Get the gridBlock to fill on the next turn
	var gridBlockToFillNextTurn = findNearbyEmptyGridBlock(startingGridBlock);
	gridBlockToFillNextTurn.setState(gridBlockToFillNextTurn.STATES.FILL_NEXT);
	
	# Generate random starting shape in availableShapes
	addRandomShapeToAvailable(0);

# Called at the beginning of every turn
func nextTurn():
	# Get all blocks to fill and fill them
	var blocksToFill = get_tree().get_nodes_in_group("fillNext");
	for block in blocksToFill:
		block.setState(block.STATES.FILLED);
	
	# Find a new block to set as fillNext
	var rand = RandomNumberGenerator.new();
	var filledBlocks = get_tree().get_nodes_in_group("filled");
	var newFillNextBlock = null;
	# Keep attempting to find a new fillNext GridBlock until one is found
	while newFillNextBlock == null:
		# Get all currently filled blocks
		filledBlocks = get_tree().get_nodes_in_group("filled");
		
		# Find a random empty GridBlock near a random filled GridBlocklock
		newFillNextBlock = findNearbyEmptyGridBlock(filledBlocks[rand.randi_range(0, filledBlocks.size()-1)]);
		
		# If a random empty GridBlock near the random filled GridBlock was found, then set it to fillNext
		if newFillNextBlock != null:
			newFillNextBlock.setState(newFillNextBlock.STATES.FILL_NEXT);
	
	# Set surrounded gridblocks to danger state
	filledBlocks = get_tree().get_nodes_in_group("filled");
	for gridBlock in filledBlocks:
		if gridBlock.isSurrounded():
			gridBlock.setState(gridBlock.STATES.DANGER1);
	
	# Move all available pieces up 1 slot
	# If the top slot has a shape and both beneath slots are full, then no shape was placed this turn and we delete the top shape
	if availableShapes[2] != null and availableShapes[1] != null and availableShapes[0] != null:
		setShapeInAvailableShapes(availableShapes[2], -1, 2);
	# if the middle slot has a shape and there's a shape underneath it, then either the top shape was placed or erased, move the middle shape to the top
	if availableShapes[1] != null and availableShapes[0] != null:
		setShapeInAvailableShapes(availableShapes[1], 2, 1);
	# If the bottom slot has a shape, then move it to the middle slot
	if availableShapes[0] != null:
		setShapeInAvailableShapes(availableShapes[0], 1, 0);

	# Add new shape to bottom
	addRandomShapeToAvailable(0);
	

# Adds a random shape to the given index
#index=the index to add the shape to
func addRandomShapeToAvailable(index) -> bool:
	# If the index isn't free, then don't add a shape there
	if (availableShapes[index] != null):
		return false
	# Create and connect signals
	var shape = getRandomShapeType().instance()
	shape.connect("placed", self, "_on_Shape_placed");
	# Give grid
	shape.grid = grid;
	# Set the global and resting positions
	shape.global_position = AVAILABLE_SHAPES_POSITIONS[index];
	shape.restingPos = AVAILABLE_SHAPES_POSITIONS[index];
	
	availableShapes[index] = shape;
	
	# Add to tree
	add_child(shape);
	return true
	
# Puts a shape object into another  index
#shape=the shape to add, index=the index to add it to. -1 means delete the shape, prevIndex=the previous index of the given shape, -1 means it doesn't exist
func setShapeInAvailableShapes(shape, index, prevIndex = -1) -> bool:
	# If the index is -1, then delete the shape
	if (index == -1):
		index = availableShapes.find(shape);
		availableShapes[index] = null;
		shape.queue_free();
		return true;
	
	# If the slot isn't available, don't add a shape
	if availableShapes[index] != null:
		return false;
	
	# Set the global position and resting position of the new shape
	shape.global_position = AVAILABLE_SHAPES_POSITIONS[index];
	shape.restingPos = AVAILABLE_SHAPES_POSITIONS[index];
	
	# Put the shape in the availableShape list
	availableShapes[index] = shape;
	
	# If the previous index is not -1 (i.e., a value was given for prevIndex), then set the previous index to null
	if prevIndex != -1:
		availableShapes[prevIndex] = null;
	
	return true;

# Returns a random shape type
func getRandomShapeType():
	var rand = RandomNumberGenerator.new();
	rand.randomize();
	
	return ALL_SHAPES[rand.randi_range(0, ALL_SHAPES.size()-1)]

# Returns an empty GridBlock near the given GridBlock, or null if none exist
#gridBlock=the GridBlock to search near
func findNearbyEmptyGridBlock(gridBlock):
	var directionsToCheck = [0, 1, 2, 3] # 0=up, continues clockwise
	# If in top row, don't check GridBlock above
	if gridBlock.row == 0:
		directionsToCheck.erase(0);
	# If in last row, don't check GridBlock below
	elif gridBlock.row == gridHeight - 1:
		directionsToCheck.erase(2);
	# If in leftmost column, don't check GridBlock to left
	if gridBlock.col == 0:
		directionsToCheck.erase(3);
	# If in rightmost column, don't check GridBlock to right
	elif gridBlock.col == gridWidth - 1:
		directionsToCheck.erase(1);
		
	# While there are directions to check, check for them in a random order
	while directionsToCheck.size() > 0:
		# Get a random direction
		var rand = RandomNumberGenerator.new();
		var dirToCheck = directionsToCheck[rand.randi_range(0, directionsToCheck.size()-1)]
		
		# Checking above
		if dirToCheck == 0:
			# If above GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row - 1][gridBlock.col].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row - 1][gridBlock.col];
			# If the block wasn't open, remove it from the directions to check
			directionsToCheck.erase(0);
		# Checking right
		if dirToCheck == 1:
			# If right GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row][gridBlock.col + 1].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row ][gridBlock.col + 1];
			# If the block wasn't open, remove it from the directions to check
			directionsToCheck.erase(1);
		# Checking below
		if dirToCheck == 2:
			# If below GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row + 1][gridBlock.col].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row + 1][gridBlock.col];
			# If the block wasn't open, remove it from the directions to check
			directionsToCheck.erase(2);
		# Checking left
		if dirToCheck == 3:
			# If left GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row][gridBlock.col - 1].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row][gridBlock.col - 1];
			# If the block wasn't open, remove it from the directions to check
			directionsToCheck.erase(3);
			
	return null
	
# Instantiates the grid with GridBlocks
#grid: variable to store grid in
#gridHeight, gridWidth: dimensions of the grid, in GridBlocks
#gridBlockHeight, gridBlockWidth: dimensions of the GridBlocks, in pixels
#upperLeftGridBlockPos: position of (the center of) the upper left GridBlock
func createGrid(grid, gridHeight, gridWidth, gridBlockHeight, gridBlockWidth, upperLeftGridBlockPos : Vector2) -> void:
	# Set relative coordinates for current GridBlock being created
	var currentGridBlockXPos := upperLeftGridBlockPos.x;
	var currentGridBlockYPos := upperLeftGridBlockPos.y;
	
	# Create rows (and columns!)
	for row in range(gridHeight):
		# Reset xpos
		currentGridBlockXPos = upperLeftGridBlockPos.x
		
		# Create a new row and resize it to be the correct width
		grid.append([])
		grid[row].resize(gridWidth)
		
		# Iterate through columns of the row we just created
		for col in range(gridWidth):
			# Create a new GridBlock
			var gridBlock = GridBlock.instance();
			# Give position
			gridBlock.position = Vector2(currentGridBlockXPos, currentGridBlockYPos);
			# Connect signals
			gridBlock.connect("clicked", self, "_on_GridBlock_clicked");
			# Give coordinates on grid
			gridBlock.row = row;
			gridBlock.col = col;
			# Give grid dimensions
			gridBlock.gridHeight = gridHeight;
			gridBlock.gridWidth = gridWidth;
			# Give grid
			gridBlock.grid = grid;
			
			add_child(gridBlock);
			
			# Add GridBlock into list
			grid[row][col] = gridBlock;
			
			# Update the xpos
			currentGridBlockXPos += gridBlockWidth;
			
		# Update ypos after we're done with a row
		currentGridBlockYPos += gridBlockHeight;

# Called when a GridBlock is clicked
func _on_GridBlock_clicked():
	if clickAdvancesTurn:
		nextTurn();
		
# Called when a shape is placed
func _on_Shape_placed(shape):
	# Delete the shape, then start the next turn
	setShapeInAvailableShapes(shape, -1);
	nextTurn();
