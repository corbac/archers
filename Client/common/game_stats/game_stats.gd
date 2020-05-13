extends TextureButton

class_name GameStats
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

var img : Texture = load("res://asset/block.png")

var shader = load("res://asset/game_stats_shader.tres")

var cost : int
var description

var effected_player

var is_active : bool
var is_activable : bool

var stat_type

var coor_x:int
var coor_y:int
var prog_x:bool
var prog_y:bool

var _grid_size

func _init(player, x, y, x_line=false, y_line=false):
	cost = 100
	is_activable = false

	effected_player = player
	coor_x = x
	coor_y = y
	prog_x = x_line
	prog_y = y_line
	
	set_normal_texture(img)
	set_material(shader.duplicate(true))

	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_grid_size = get_parent().SIZE
	stat_type = set_type()
		
	self.connect("mouse_entered", get_parent(), "_mouse_over_stats", [self])
	self.connect("mouse_exited", get_parent(), "_mouse_exited_stats", [self])
#	self.connect("pressed" , get_parent(), "_mouse_selected_stats", [self])
	self.connect("pressed" , self, "_mouse_selected_stats")
	
#	var label = Label.new()
#	var p = get_global_mouse_position()
#	label.rect_position= p
##	label
##	var c = CanvasLayer.new()
##	c.set_layer(5)
##	c.
##	c.add_child(label)
#	get_parent().get_parent().add_child(label)
#	label.text = STATS_TYPE.keys()[stat_type]
#	label.visible = false
	
	if is_activable:
		self.material.set_shader_param("activation_id", 1)
	
	

	pass # Replace with function body.
	
func set_type():
	if coor_x  == int(_grid_size/2)-1:
		if coor_y  == int(_grid_size/2)-1:
			return STATS_TYPE.CLASS_PROTECTOR
		elif coor_y == int(_grid_size/2):
			return STATS_TYPE.CLASS_PATHFINDER
	elif coor_x  == int(_grid_size/2):
		if coor_y == int(_grid_size/2)-1:
			return STATS_TYPE.CLASS_ROGUE
		elif coor_y == int(_grid_size/2):
			return STATS_TYPE.CLASS_HEALER
	
	randomize()
	return 4 + randi() % (len(STATS_TYPE)-4)

func _mouse_selected_stats():
	if is_activable and effected_player.experience >= cost:
		is_active = true
		effected_player.take_experience(cost)
		activate_effect()
		self.material.set_shader_param("activation_id", 2)
		get_parent().update_which_is_activable(self)

func activate_effect():
	if stat_type in [STATS_TYPE.CLASS_PROTECTOR] :
		var pclass = ProtectorClass.new()
		pclass.name = "ProtctorClass"
		effected_player.add_child(pclass)
	elif stat_type in [STATS_TYPE.CLASS_PATHFINDER] :
		var pclass = PlayerClass.new()
		effected_player.add_child(pclass)
	elif stat_type in [STATS_TYPE.CLASS_ROGUE] :
		var pclass = PlayerClass.new()
		effected_player.add_child(pclass)
	elif stat_type in [STATS_TYPE.CLASS_HEALER] :
		var pclass = PlayerClass.new()
		effected_player.add_child(pclass)
		pass
	else:
		if coor_x  < int(_grid_size/2):
			if coor_y < int(_grid_size/2):
#				print(3)
				get_node("/root/Node2D/ProtctorClass").add_stat(self)
#				y.
			else:
				pass
		else:
			if coor_y < int(_grid_size/2):
				pass
			else:
				pass
		
