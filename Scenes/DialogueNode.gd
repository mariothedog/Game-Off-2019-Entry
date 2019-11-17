# dialogue system
extends Area2D

var dialogue_start = false
var line = 0

export (Array, String) var dialogue_line

# functions 
func _ready():
	$"Dialogue control/TEXT".hide()
	pass

func _on_Dialogue_node_body_entered(body): # when player touches collision shape, dialogue starts
	if body.get_name() == "Player":
		dialogue_start = true

func _input(event):                        # show
	if dialogue_start == true:
		$"Dialogue control/TEXT".show()
	else:
		return

func _dialogue():                         # dialogue function
	$"Dialogue control/TEXT".visible_characters = 0
	$"Dialogue control/TEXT".text = line[dialogue_line]
