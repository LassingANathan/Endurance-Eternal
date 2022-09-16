extends Node

export (PackedScene) var GridBlock;

## Constants
export (int) var gridWidth := 0; # In gridblocks
export (int) var gridHeight := 0; # In gridblocks
export (int) var gridBlockWidth := 0; # In pixels
export (int) var gridBlockHeight := 0; # In pixels

## Variables
var grid := [];

# Called when the node enters the scene tree for the first time.
func _ready():
	# Fill the grid with GridBlocks
	createGrid(grid, gridHeight, gridWidth, gridBlockHeight, gridBlockWidth, Vector2(161,60));

	# Choose a random GridBlock to set as filled at the start
	var rand = RandomNumberGenerator.new();
	var startingGridBlock = grid[rand.randi_range(0,gridHeight-1)][rand.randi_range(0,gridWidth-1)]
	startingGridBlock.clicked()
	print(startingGridBlock.row, " ", startingGridBlock.col)
	var gridBlockToFillNextTurn = findNearbyEmptyGridBlock(startingGridBlock);
	gridBlockToFillNextTurn.changeState(gridBlockToFillNextTurn.STATES.FILL_NEXT);

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
		# Checking right
		if dirToCheck == 1:
			# If right GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row][gridBlock.col + 1].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row ][gridBlock.col + 1];
		# Checking below
		if dirToCheck == 2:
			# If below GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row + 1][gridBlock.col].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row + 1][gridBlock.col];
		# Checking left
		if dirToCheck == 3:
			# If left GridBlock is empty, then return that GridBlock
			if (grid[gridBlock.row][gridBlock.col - 1].state == gridBlock.STATES.EMPTY):
				return grid[gridBlock.row][gridBlock.col - 1];
			
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
			
			add_child(gridBlock);
			
			# Add GridBlock into list
			grid[row][col] = gridBlock;
			
			# Update the xpos
			currentGridBlockXPos += gridBlockWidth;
			
		# Update ypos after we're done with a row
		currentGridBlockYPos += gridBlockHeight;

# Called when a GridBlock is clicked
func _on_GridBlock_clicked():
	pass
