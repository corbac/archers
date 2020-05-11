extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction : Vector2
var speed : int = 1000

const ENEMY = preload("res://enemies/enemy.gd")

var life : Timer
var life_time : int = 3

var _shooter

func initialize(angle, pos, target, shooter):
	rotation = angle
	position = pos
	direction = (target - position).normalized()
	_shooter = shooter
	return self
	
# Called when the node enters the scene tree for the first time.
func _ready():
	life = Timer.new()
	life.set_wait_time(life_time)
	life.set_one_shot(true)
	self.add_child(life)
	life.connect("timeout", self, "disappears")
	life.start()
#	yield(t, "timeout")
#	t.queue_free()
	pass # Replace with function bodsy.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collide = move_and_collide(direction*delta*speed, true)
	if collide and collide.collider is ENEMY:
		collide.collider.take_damage(_shooter.damage)
		_shooter.increase_exp(collide.collider.exp_given)
		disappears()
		pass
	pass

func disappears():
	self.queue_free()
