extends PlayerClass


class_name ProtectorClass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cooldown_effect = 0.1
var damage_effect = 1
var armor_effect  = 1
var regen_effect = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_stat(stat):
	if stat.stat_type == STATS_TYPE.COOLDOWN :
		apply_cooldown()
	elif stat.stat_type == STATS_TYPE.DOMAGE :
		apply_damage()
	elif stat.stat_type == STATS_TYPE.ARMOR :
		apply_armor()
	elif stat.stat_type == STATS_TYPE.REGEN :
		apply_regen()
	else :
		pass
	pass
	

func apply_cooldown():
	_player.shoot_cooldown -= cooldown_effect
	
func apply_damage():
	_player.damage += damage_effect
	pass

func apply_armor():
	_player.armor += armor_effect
	pass

func apply_regen():
	_player.regen += armor_effect
	pass
