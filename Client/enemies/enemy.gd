extends KinematicBody2D


var life : int = 3
var damage = 2
var armor = 1
var regen = 1

var exp_given = 5

#enum 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	life -= damage
	if life <= 0:
		dead()

func dead():
	self.queue_free()
	
