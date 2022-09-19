extends Node

## Variables
var gridAlpha := 0.0; # Holds the current alpha of the grid
var textAlpha := 0.0; # Holds the current alpha of the opening text
var fadeWeight := 2.5; # Holds a weight for how quickly the scene fades
var gridFadingIn := false; # Bool for if the grid is fading in
var gridFadingOut := false; # Bool for if the grid is fading out
var textFadingIn := true; # Bool for if the opening text is fading in
var textFadingOut := false; # Bool for if the opening text is fading out

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set grid to invisible at first so clicking won't have an effect
	$Grid.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Slowly fade in text if necessary
	if textFadingIn:
		fade($OpeningText, fadeWeight);
		# If the grid is fully visible, then stop fading it in
		if $OpeningText.modulate.a >= 1.0:
			textFadingIn = false;
	
	# Slowly fade in the grid if necessary
	if gridFadingIn:
		fade($Grid, fadeWeight);
		# If the grid is fully visible, then stop fading it in
		if $Grid.modulate.a >= 1.0:
			gridFadingIn = false;
			
	# Slowly fade out the grid if necessary
	if gridFadingOut:
		fade($Grid, -fadeWeight*0.5);
		# If the grid is fully invisible, then switch to the main menu
		if $Grid.modulate.a <= 0.0:
			gridFadingIn = false;
			get_tree().change_scene("res://rooms/MainMenu.tscn")
	
	# Slowly fade out text if necessary
	if textFadingOut:
		fade($OpeningText, -fadeWeight);
		# If the grid is fully visible, then stop fading it in
		if $OpeningText.modulate.a <= 0.0:
			textFadingIn = false;

# Fades a node in or out, based on fadeWeight
#node=the node to fade, fadeWeight=the weight to fade the node, negative means fading out, greater absval means faster
func fade(node, fadeWeight):
	var currentAlpha = node.modulate.a;
	node.modulate = Color(1.0,1.0,1.0,currentAlpha+(fadeWeight/255));
	currentAlpha += (fadeWeight/255);

# Called when the opening text timer is done. Fades out text and fades in grid
func _on_OpeningTextTimer_timeout():
	$Grid.visible = true;
	textFadingOut = true;
	gridFadingIn = true;

# Called when the main menu button is pressed
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://rooms/MainMenu.tscn");
