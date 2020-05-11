extends Node

# The URL we will connect to
export var websocket_url = "ws://localhost:9090"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

onready var _label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	_client.connect("data_received", self, "_on_data")
	 
	_client.connect("connection_established", self, "_connected")
	
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	pass # Replace with function body.


func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
	
func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	
#	_label.text = str(_client.get_connected_host())
	
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_data(id):
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

sync func label_change():
	_label.text = "Remote call for write this message"
	pass
