extends Node2D

onready var world = get_tree().get_current_scene()
onready var curr_scene = self
onready var player = world.get_node("/root/Buried/Player")
onready var cam = player.get_node("Camera2D")
onready var title_cam = get_node("/root/Buried/Title/Menu Background/Camera2D")
onready var menu_bg = get_node("/root/Buried/Title/Menu Background")

func _ready():
	curr_scene = world.get_child(0)
	
	var map_limits
	var map_cellsize
	
	cam.current = false
	title_cam = get_node("/root/Buried/Title/Menu Background/Camera2D")
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
	var scaleX = float(menu_bg.texture.get_width()) / ProjectSettings.get("display/window/size/width")
	var scaleY = float(menu_bg.texture.get_height()) / ProjectSettings.get("display/window/size/height")
	title_cam.global_position = menu_bg.global_position
	title_cam.zoom = Vector2(scaleX, scaleY)
