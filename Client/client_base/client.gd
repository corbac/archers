extends Node2D

# The URL we will connect to
export var websocket_url = "ws://localhost:9090"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

var ARROW = preload("res://arrow/arrow.tscn")

onready var _label = get_node("Label")
onready var _sprite = get_node("Sprite")

var shoot_cooldown = 2
var shoot_timer : Timer
var can_shoot : bool = false

const REGEN_COOLDOWN = 1

var is_stats_open : bool = false

var damage = 2
var armor = 1
var life = 10
var current_life = life-5

var regen = 1

var regen_timer


var experience = 1000

var speed = 15000

var move = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	_client.connect("data_received", self, "_on_data")
	_client.connect("connection_succeeded", self, "_connected")
	
	
	var S = $Stages
	S.connect("map_generated", self, "_on_map_generated")
	S.connect("ready", self, "_on_map_generated")
	
	#Shoot cooldown:
	shoot_timer = Timer.new()
	shoot_timer.connect("timeout", self, "_shoot_cooldown_over")
	_sprite.add_child(shoot_timer)
	shoot_timer.start(shoot_cooldown)
	
	#Regen cooldown:
	regen_timer = Timer.new()
	regen_timer.name = "RegenTimer"
	regen_timer.connect("timeout", self, "_regen_cooldown_over")
	_sprite.add_child(regen_timer)
	regen_timer.start(REGEN_COOLDOWN)
	
	
	var err = _client.connect_to_url(websocket_url, PoolStringArray(), true);
	get_tree().set_network_peer(_client)
	
	$Sprite/Camera2D/UI/HP.text = str(current_life)
	$Sprite/Camera2D/UI/Exp.text = str(experience)
	
	if err != OK:
		print("Unable to connect")
		set_process(false)	
	
	_label.text = "Ready"
	pass # Replace with function body.


func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
	
#	var t = Timer.new()
#	t.set_wait_time(1)
#	t.set_one_shot(true)
#	self.add_child(t)
#	t.start()
#	yield(t, "timeout")
#	t.queue_free()
#
#	rpc("move_sprite")
#	_label.text = str(_client.get_connection_status())

	action_handler(delta)
	
#func _input(event):
#	print("hello")
#	move = Vector2()
#	if event.is_action_pressed("up"):
#		move.y = -10
#	if event.is_action_pressed("down"):
#		move.y = 10
#	if event.is_action_pressed("left"):
#		move.x = -10
#	if event.is_action_pressed("right"):
#		move.x = 10
#
##	rpc("move_sprite")
#
#	pass


func action_handler(delta):
	
	if Input.is_action_just_pressed("stats"):
		$Sprite/Camera2D/UI/GridContainer.visible = !$Sprite/Camera2D/UI/GridContainer.visible
		is_stats_open = !is_stats_open
		
	move = Vector2()
	if Input.is_action_pressed("up"):
		move.y = -1
	if Input.is_action_pressed("down"):
		move.y = 1
	if Input.is_action_pressed("left"):
		move.x = -1
	if Input.is_action_pressed("right"):
		move.x = 1
		
		
	if move.length() > 0:
		move = move.normalized() * delta * speed
		move_sprite(move)
#		rpc("move_sprite", move)
	
	if !is_stats_open and Input.is_action_pressed("shoot"):
		if can_shoot : shoot()
#		rpc("shoot")

#	_sprite.rotation = get_local_mouse_position().angle()
#	_sprite.look_at(get_local_mouse_position())
	pass

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	
#	_label.text = str(_client.get_connected_host())
	
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
#	_client.get_peer(1).put_packet("Test packet".to_utf8())
#	_label.text = "Client - Connected and send message"

func _on_map_generated():
	pass
	_sprite.position = 32
	pass
	
func _shoot_cooldown_over():
	can_shoot = true

func _regen_cooldown_over():
	if current_life+regen <= life :
		current_life += regen
	else :
		current_life == regen
	
	regen_timer.start(REGEN_COOLDOWN)
	$Sprite/Camera2D/UI/HP.text = str(current_life)
	
func _connected_to_server():
#	_label.text = "connected :  _connected_to_server()"
	pass
	
func _on_data(id):
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())
	_label.text = "Got data from server: "+ _client.get_peer(1).get_packet().get_string_from_utf8()
#
#remote func label_change():
#	_label.text = "Remote call for write this message"
#	pass

func take_damage(damage):
	current_life -= damage
	if current_life <= 0:
		dead()

func dead():
#	self.queue_free()
	pass
	
func take_experience(e):
	experience -= e
	$Sprite/Camera2D/UI/Exp.text = str(experience)

func increase_exp(e):
	experience += e
	$Sprite/Camera2D/UI/Exp.text = str(experience)

remotesync func move_sprite(_move): 
	_sprite.move_and_slide(_move)
#	$Sprite/Camera2D.position = _sprite.position
	pass

remotesync func shoot():
	var local = get_local_mouse_position()
	var global = get_global_mouse_position()
	var arrow = ARROW.instance().initialize(_sprite.rotation, _sprite.position, get_local_mouse_position(), self)
	$Projectiles.add_child(arrow)
	can_shoot = false
	shoot_timer.start(shoot_cooldown)
	
#	move_and_collide()
	pass
