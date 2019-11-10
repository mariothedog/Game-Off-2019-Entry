extends Particles2D

func _ready():
	process_material = process_material.duplicate() # So when one particle's color is changed all the particle's colors won't change