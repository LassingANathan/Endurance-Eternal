extends Node

## Variables
var playButtonPressed := false; # Holds whether the play button has been pressed
var currentAlpha := 1.0; # Holds the current alpha of the mainMenu
var fadeWeight := 3.0; # Holds a weight for how quickly the mainMenu fades
var fadingIn := true; # Bool for if the mainMenu is currently fading in

# Called when the node enters the scene tree for the first time.
func _ready():
	# Turn on music (might be necessary if music was turned off by game failure)
	get_node("/root/Music").play(0);
	fadingIn = true;

# Called every frame
func _process(delta):
	if fadingIn:
		fade(self, fadeWeight)
		# If the alpha value is greater than or equal to 255, stop fading in
		if self.modulate.a8 >= 255:
			fadingIn = false;
		
	# If a button's been pressed, fade to black before switching rooms
	if playButtonPressed:
		# Stop fading in since now we're fading out
		fadingIn = false;
		fade(self, -fadeWeight)
		
		# If the alpha value is less than or equal to zero, switch rooms
		if self.modulate.a8 <= 0:
			get_tree().change_scene("res://rooms/MainScene.tscn")
		

# Fades a node in or out, based on fadeWeight
#node=the node to fade, fadeWeight=the weight to fade the node, negative means fading out, greater absval means faster
func fade(node, fadeWeight):
	var currentAlpha = node.modulate.a;
	node.modulate = Color(1.0,1.0,1.0,currentAlpha+(fadeWeight/255));
	currentAlpha += (fadeWeight/255);

# Called when the play button is pressed
func _on_PlayButton_pressed():
	playButtonPressed = true;
	
# Called when the tuttorial button is ppressed
func _on_TutorialButton_pressed():
	get_tree().change_scene("res://rooms/TutorialScene.tscn")

# Called when the quit button is pressed
func _on_QuitButton_pressed():
	get_tree().quit();
