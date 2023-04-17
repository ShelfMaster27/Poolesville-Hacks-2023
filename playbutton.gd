extends Button


func _on_Button_pressed():
	get_tree().change_scene("res://Scene 1.tscn")
	GlobalWorld.curr_scene = "Scene 1"
