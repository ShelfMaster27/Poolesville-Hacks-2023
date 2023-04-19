extends Node2D

onready var world = get_tree().get_current_scene()
onready var curr_scene = self
onready var player = world.get_node("Player")


func _ready():
	curr_scene = world.get_child(0)
	
	var map_limits
	var map_cellsize
	var cam = player.get_node("Camera2D")
	var title_cam = get_node("Menu Background/Camera2D") #Menu Background/Camera2D
	
	cam.current = false
	title_cam.current = true
	
	if curr_scene.get_name() == "Title":
		player.visible = false
		cam.current = false
		title_cam.current = true
		title_cam.scale.x = 1.5
		title_cam.scale.y = 1.5
		
	if curr_scene.get_name() == "Scene 1":
		print("hi")
		player.visible = true
		cam.current = true
		title_cam.current = false
		cam.scale.x = 1.5
		cam.scale.y = 1.5
	
	title_cam.current = true
	var scaleX = float(get_node("Menu Background").texture.get_width()) / ProjectSettings.get("display/window/size/width")
	var scaleY = float(get_node("Menu Background").texture.get_height()) / ProjectSettings.get("display/window/size/height")
	title_cam.global_position = get_node("Menu Background").global_position
	title_cam.zoom = Vector2(scaleX, scaleY)
