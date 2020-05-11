extends Node2D


class_name PlayerClass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum STATS_TYPE {
	CLASS_PROTECTOR,
	CLASS_PATHFINDER,
	CLASS_ROGUE,
	CLASS_HEALER,
	COOLDOWN,
	DOMAGE,
#	ARROW_SPEED,
	ARMOR,
	REGEN
}

var _player

func _init():
	
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_parent()
	pass # Replace with function body.
