extends Node

export (PackedScene) var GridBlock;

## Constants
export (int) var gridWidth : = 0; # In gridblocks
export (int) var gridHeight : = 0; # In gridblocks
export (int) var gridBlockWidth : = 0; # In pixels
export (int) var gridBlockHeight : = 0; # In pixels

## Variables
var grid = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	createGrid(grid, gridHeight, gridWidth, gridBlockHeight, gridBlockWidth, Vector2(50,50));

# Instantiates the grid with GridBlocks
#grid: variable to store grid in
#gridHeight, gridWidth: dimensions of the grid, in GridBlocks
#gridBlockHeight, gridBlockWidth: dimensions of the GridBlocks, in pixels
#upperLeftGridBlockPos: position of (the center of) the upper left GridBlock
func createGrid(grid, gridHeight, gridWidth, gridBlockHeight, gridBlockWidth, upperLeftGridBlockPos : Vector2) -> void:
	# Set relative coordinates for current GridBlock being created
	var currentGridBlockXPos = upperLeftGridBlockPos.x;
	var currentGridBlockYPos = upperLeftGridBlockPos.y;
	
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
			gridBlock.position = Vector2(currentGridBlockXPos, currentGridBlockYPos);
			add_child(gridBlock);
			
			# Update the xpos
			currentGridBlockXPos += gridBlockWidth;
			
		# Update ypos after we're done with a row
		currentGridBlockYPos += gridBlockHeight;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
