extends Button


func _on_Button_pressed():
	get_tree().change_scene("res://Scene 1.tscn")
	get_node("/root/Buried/Title").queue_free()
	GlobalWorld.curr_scene.name = "Scene 1"

