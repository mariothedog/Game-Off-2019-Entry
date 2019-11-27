extends Node

#warning-ignore-all:unused_class_variable

var player

var coins = 0

var tile_colors = {
	"Spawn": Color(0.52, 0.49, 0.53, 1),
	"Grass": Color(0.42, 0.75, 0.19, 1),
	"Ground": Color(0.27, 0.16, 0.24, 1),
	"Grass Edge": Color(0.42, 0.75, 0.19, 1),
	"Ground Edge": Color(0.27, 0.16, 0.24, 1)
	}
	
var skills = []
var freezing = false

var checkpoint = null

var can_charge = false

func _ready():
	randomize()

func random_int(mini, maxi):
	return randi() % maxi + mini