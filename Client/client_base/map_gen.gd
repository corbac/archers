extends Node

class_name MapGenerator

var _size
var map_grid = []


var nb_rooms = 7
var room_min_size = 10
var room_max_size = 50

var TILE_SIZE = 32

var pos_start : Vector2

enum TILE {
	NONE,
	WALL,
	GROUND,
	STAIRS
}

var ground_space =  []


func _init(size):
	randomize()
	pos_start = Vector2(0,0)
	nb_rooms = size
	_size = nb_rooms * 10
	for i in range(_size):
		map_grid.append([])
		for j in range(_size):
			map_grid[i].append(TILE.NONE)
	
	for r in range(nb_rooms):
		gen_room()
		
	put_stairs()
	
	pass


func gen_room():
	var room_siz_h = room_min_size + (randi() % (room_max_size - room_min_size))
	var room_siz_v = room_min_size + (randi() % (room_max_size - room_min_size))
	
	tile_room(room_siz_h, room_siz_v)
	# Next Gen
	pos_start.x = pos_start.x + (randi() % (room_siz_h))
	pos_start.y = pos_start.y + (randi() % (room_siz_v))

func tile_room(size_h, size_v):
	for i in range(size_h):
		for j in range(size_v):
			map_grid[min(pos_start.x+i,_size-1)][min(pos_start.y+j,_size-1)] = TILE.GROUND
			ground_space.append(Vector2(min(pos_start.x+i,_size-1),min(pos_start.y+j,_size-1)))

	
func draw_map(t):
	for i in range(_size):
		for j in range(_size):
			if map_grid[i][j] != TILE.NONE:
				if map_grid[i-1][j] == TILE.NONE or map_grid[min(i+1,_size-1)][j] == TILE.NONE  or map_grid[i][j-1]  == TILE.NONE or map_grid[i][min(j+1,_size-1)] == TILE.NONE :
					if map_grid[i][j] != TILE.STAIRS:
						map_grid[i][j] = TILE.WALL
						t.set_cell(i,j, 0)
				elif i == _size-1 and map_grid[i][j] == TILE.GROUND:
					map_grid[i][j] = TILE.WALL
					t.set_cell(i,j, 0)
				elif j == _size-1 and map_grid[i][j] == TILE.GROUND:
					map_grid[i][j] = TILE.WALL
					t.set_cell(i,j, 0)
				if map_grid[i][j] == TILE.STAIRS:
					t.set_cell(i,j, 1)
					print("Stairs: "+str(i*32)+str(j*32))


func put_stairs():
	var i = randi() % (len(ground_space))
	map_grid[ground_space[i].x][ground_space[i].y] = TILE.STAIRS
	

func find_starter_pos():
	var i = randi() % (len(ground_space))
	
	
	var found = false
	
	while !found:
		
		for t in range(len(ground_space)):
			found = ground_space[t].y == ground_space[i].y + 1 or ground_space[t].y == ground_space[i].y - 1
			if ground_space[t].y == ground_space[i].y + 1  :
				return Vector2(ground_space[i].x, ground_space[i].y)
			elif ground_space[t].y == ground_space[i].y - 1:
				return Vector2(ground_space[i].x, ground_space[i].y-1)
#		if map_grid[i][j] == TILE.GROUND and map_grid[i][j-1] == TILE.GROUND:
#			return Vector2(i,j)
#		elif map_grid[i][j] == TILE.GROUND and map_grid[i][min(j+1,_size-1)] == TILE.GROUND:
#			return Vector2(i,j)
#		elif map_grid[i][j] == TILE.GROUND and map_grid[i-1][j] == TILE.GROUND:
#			return Vector2(i,j)
#		elif map_grid[i][j] == TILE.GROUND and map_grid[min(i+1,_size-1)][j] == TILE.GROUND:
#			return Vector2(i,j)
#		else:
#			i += 1
		i = randi() % (len(ground_space))
