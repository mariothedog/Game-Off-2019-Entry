extends ParallaxBackground

var cloud = load("res://Scenes/Cloud.tscn")

func _ready(): # So there are clouds on the screen at the beginning
	for _i in range(30):
		create_cloud()

func create_cloud():
	var cloud_instance = cloud.instance()
	cloud_instance.position.y = -global.random_int(20, int(get_viewport().size.y)+700)
	cloud_instance.position.x = global.random_int(-600, 1920)
	cloud_instance.add_to_group("Clouds")
	get_parent().call_deferred("add_child", cloud_instance)

func _on_Cloud_Spawn_Cooldown_timeout():
	if get_tree().get_nodes_in_group("Clouds").size() > 30:
		return
	var cloud_instance = cloud.instance()
	cloud_instance.position.y = -global.random_int(20, int(get_viewport().size.y)+700)
	cloud_instance.position.x = global.player.position.x - global.player.get_global_transform_with_canvas().origin.x - 30
	cloud_instance.add_to_group("Clouds")
	get_parent().add_child(cloud_instance)