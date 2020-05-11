extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	
	$Stage.rect_position.x = (screen_size.x - $Stage.rect_size.x)/2
	$Exp.rect_position.x = (screen_size.x - $Exp.rect_size.x)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
