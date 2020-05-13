extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var decision_timer : Timer
var decision_cooldown : int = 2

var _player

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_player = get_node("/root/Node2D/Sprite")
	
	# Decision  Timer
	decision_timer = Timer.new()
	decision_timer.connect("timeout", self, "_decision_cooldown_over")
	add_child(decision_timer)
	decision_timer.start(decision_cooldown)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _ready_to_attack(enemy):
	enemy.order = 2

func _decision_cooldown_over():
	get_node("Enemy").ai_move_to_player(_player)
