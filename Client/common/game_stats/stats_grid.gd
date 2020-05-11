extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SIZE : int = 10

var stats_matrix = []

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	set_mouse_filter(MOUSE_FILTER_PASS)
	columns = SIZE
	var stat_j = null
	for i in range(SIZE):
#		var stat_i = GameStats.new()
#		stats_matrix.append(stat_i)
#		self.add_child(stat_i)
		stats_matrix.append([])
		
		for j in range(SIZE):
			if i  < int(SIZE/2):
				if j < int(SIZE/2):
					stat_j = GameStats.new(get_tree().get_root().get_node("Node2D"), i, j, false, false)
				else:
					stat_j = GameStats.new(get_tree().get_root().get_node("Node2D"), i, j, false, true)
			else:
				if j < int(SIZE/2):
					stat_j = GameStats.new(get_tree().get_root().get_node("Node2D"), i, j, true, false)
				else:
					stat_j = GameStats.new(get_tree().get_root().get_node("Node2D"), i, j, true, true)
			
			if i  == int(SIZE/2) and (j  == int(SIZE/2) or j  == int(SIZE/2)-1) or i  == int(SIZE/2)-1 and (j  == int(SIZE/2) or j  == int(SIZE/2)-1):
				stat_j.is_activable = true
				
			stats_matrix[i].append(stat_j)
			self.add_child(stat_j)
	
	screen_size = get_viewport().get_visible_rect().size
	
#	rect_position = (screen_size-rect_size)/2
	
	pass
	
func _mouse_over_stats(stat):
	stat.get_child(0).visible = true
	pass

func _mouse_exited_stats(stat):
	stat.get_child(0).visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		var mouse_pos = get_global_mouse_position()
		var p = mouse_pos - (screen_size /2)
#		print("-----------------------------------")
#		print("x:"+ str(p.x) + " y:" + str(p.y))
	
		margin_top = -p.y/5
		margin_left= -p.x/6

	pass

func update_which_is_activable(st):
	if(st.prog_x):
		if(st.prog_y):
			activate_xy(st.coor_x, st.coor_y+1)
			activate_xy(st.coor_x+1, st.coor_y)
		else:
			activate_xy(st.coor_x, st.coor_y-1)
			activate_xy(st.coor_x+1, st.coor_y)
	else:
		if(st.prog_y):
			activate_xy(st.coor_x, st.coor_y+1)
			activate_xy(st.coor_x-1, st.coor_y)
		else:
			activate_xy(st.coor_x, st.coor_y-1)
			activate_xy(st.coor_x-1, st.coor_y)

func activate_xy(x, y):
	if stats_matrix[x][y]:
		stats_matrix[x][y].is_activable = true
		stats_matrix[x][y].material.set_shader_param("activation_id", 1)
