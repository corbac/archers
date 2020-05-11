extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#signal map_generated

# Called when the node enters the scene tree for the first time.
func _ready():
#	$TileMap.set_cell(1,5, 1, 0)
	
	var t = TileMap.new()
	t.tile_set = load("res://client_base/tileset.tres")
	t.cell_size = Vector2(32,32)
	var map = MapGenerator.new(12)
	map.draw_map(t)
	add_child(t)
	
#	print(map.find_starter_pos()*32)
#	get_parent().get_node("Sprite").position = map.find_starter_pos()*32

#	get_parent().get_node("Camera2D").position = map.find_starter_pos()*32
#	print(map.find_starter_pos())
#	emit_signal("map_generated")
#	visible = false
