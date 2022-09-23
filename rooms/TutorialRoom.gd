extends Node2D

## Variables
# Can't declare TUTORIAL_COMPONENTS as a constant due to $'s being found at runtime, but it's practically a constant. Initialized in _ready()
var TUTORIAL_COMPONENTS = []; # Array of arrays. Each outer array is the tutorial page, each inner array is the components needed for that page
var tutorialPage = 0; # Holds the current page of the tutorial

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize TUTORIAL_COMPONENTS now that child nodes are loaded
	TUTORIAL_COMPONENTS = [ 
	[$Text0],
	[$Text1],
	[$Text2],
	[$Text3],
	[$Text4],
	[$Text5],
	[$Text6],
	[$Text7],
	[$Text8]];

# Goes to the next page of the tutorial
#page=the page of the tutorial to advance to
func nextPage(page):
	# If trying to go past the last page, then go back to main menu
	if (page >= TUTORIAL_COMPONENTS.size()):
		get_tree().change_scene("res://rooms/MainMenuRoom.tscn");
		# Have to return, since change_scene() finishes the function before changing the scene
		return;
		
	# Set every component in the current page to invisible
	for component in TUTORIAL_COMPONENTS[tutorialPage]:
		component.visible = false;
	# Set every component in the new page to visible
	for component in TUTORIAL_COMPONENTS[page]:
		component.visible = true;
	self.tutorialPage = page;

# Called when the next button is pressed
func _on_NextButton_pressed():
	nextPage(tutorialPage+1);
