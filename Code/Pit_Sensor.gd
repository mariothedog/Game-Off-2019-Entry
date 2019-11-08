extends Area2D

# Pit sensor
func _on_Pit_sensor_body_entered(body):
	if body.get_name() == "Player":        # if the body's name is player, the scene will reload
		if get_tree().reload_current_scene() != OK:
			print_debug("An error occured when trying to reload the current scene at Pit_Sensor.gd.")