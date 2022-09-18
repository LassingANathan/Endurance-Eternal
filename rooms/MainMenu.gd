extends Node

## Variables
var playButtonPressed := false; # Holds whether the play button has been pressed
var currentAlpha := 1.0; # Holds the current alpha of the mainMenu
var fadeWeight := 3.0; # Holds a weight for how quickly the mainMenu fades

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame
func _process(delta):
	# If a button's been pressed, fade to black before switching rooms
	if playButtonPressed:
		self.modulate = Color(1,1,1,currentAlpha-(fadeWeight/255.0));
		currentAlpha-=(fadeWeight/255.0);
		
		# If the alpha value is less than or equal to zero, switch rooms
		if self.modulate.a8 <= 0:
			get_tree().change_scene("res://rooms/MainScene.tscn")
		

# Called when the play button is pressed
func _on_PlayButton_pressed():
	playButtonPressed = true;
	
# Called when the quit button is pressed
func _on_QuitButton_pressed():
	get_tree().quit();