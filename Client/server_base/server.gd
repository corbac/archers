extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const PORT = 9090


var _server = WebSocketServer.new()

onready var _label = get_node("Label")
onready var _sprite = get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	_server.connect("client_connected", self, "_connected")
	_server.connect("peer_connected", self, "_peer_connected")
	_server.connect("data_received", self, "_on_data")
#	_server.connect("connected_to_server", self, "")
	
	var err = _server.listen(PORT, PoolStringArray(), true)
	get_tree().set_network_peer(_server)
	
	if err != OK:
		print("Unable to start server")
		set_process(false)
		
	pass # Replace with function body.


func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	_server.poll()
#	_label.rpc("label_change")
	
	
#	
	
func _connected(id, proto):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	_label.text = "Client %d connected with protocol: %s" % [id, proto]
	print("Client %d connected with protocol: %s" % [id, proto])
	
	
func _peer_connected(id):
	print("Client %d connected" % [id])
	_label.text = "_peer_connected %d" % id
	_label.rpc_id(id, "label_change")
	_label.text += "--" + str(get_tree().get_multiplayer().get_network_connected_peers())
	pass

	
func _on_data(id):
	var pkt = _server.get_peer(id).get_packet()
	print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	_server.get_peer(id).put_packet("Test client".to_utf8())
	
	_label.text = pkt.get_string_from_utf8()
	_label.rpc("label_change")
	_label.rpc_id(id, "label_change")
	
	print(str(id) + " contacted !")
	
#sync func label_change():
#	print("remote go")
#	_label.text = "remote go"
#	pass

remotesync func move_sprite(_move):
	_sprite.move_and_slide(_move)
	pass
