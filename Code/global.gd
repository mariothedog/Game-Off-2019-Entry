extends Node

#warning-ignore-all:unused_class_variable

var player

var level = 0
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

var debug = false

func _ready():
	randomize()

func random_int(mini, maxi):
	return randi() % maxi + mini

func next_level():
	level += 1
	var level_scene = "res://Scenes/Level " + str(level) + ".tscn"
	global.checkpoint = null
	if get_tree().change_scene(level_scene) != OK:
		print_debug("An error occured when trying to switch to the " + level_scene + " scene.")

func credits():
	if get_tree().change_scene("res://Scenes/Credits.tscn") != OK:
		print_debug("An error occured when trying to switch from the Main Menu scene to the Credits scene.")

func MainMenu():
	if get_tree().change_scene("res://Scenes/Main Menu.tscn") != OK:
		print_debug("An error occured when trying to switch from the Main Menu scene to the Credits scene.")