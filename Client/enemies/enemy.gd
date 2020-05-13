extends KinematicBody2D


var life : int = 3
var damage = 2
var armor = 1
var regen = 1

var exp_given = 5

var speed = 8000

var can_shoot : bool = false

var move = Vector2(0,0)

var order

var _target
var _move : Vector2

var _range : int = 40#pixels

signal ready_to_attack
var attack_cooldown = 2

enum AI_STAT {
	IDLE,
	MOVE,
	ATTACK
} 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.connect("ready_to_attack", get_parent(), "_ready_to_attack")
	$AttackTimer.start(attack_cooldown)
	$AttackTimer.connect("timeout", self, "_on_attack_cooldown_over")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if order == AI_STAT.MOVE:
		move_and_slide(_move * delta)
		
	if order == AI_STAT.IDLE:
		_target = null
		
	if order == AI_STAT.ATTACK:
		give_damage()
		pass
		
		
		
	#check distance to player
	if _target:
		var dist_target= position.distance_to(_target.position)
		print (order == AI_STAT.ATTACK)
		if  order != AI_STAT.ATTACK and dist_target <= _range:
			emit_signal("ready_to_attack", self)
		
	pass

func ai_move_to_player(player):
	order = AI_STAT.MOVE
	_target = player
	_move = (player.position - position).normalized() * speed

func give_damage():
	if _target and can_shoot and position.distance_to(_target.position) <= _range:
		can_shoot = false
		$AttackTimer.start(attack_cooldown)
		_target.get_parent().take_damage(damage)
	pass

func take_damage(damage):
	life -= damage
	if life <= 0:
		dead()

func dead():
	self.queue_free()
	
func _on_attack_cooldown_over():
	can_shoot = true
	
