extends Node2D

onready var world = get_tree().get_current_scene()
onready var curr_scene = self
export var matching_scene_trigger = ""
#onready var player = world.get_node("Player")
onready var player = world.get_node("Player")
onready var globals = preload("res://globalresource.tres")


func _ready():
	curr_scene = world.get_child(0)
	print("\nNew scene instance! (", curr_scene.get_name(), ")\n")
	
	var map_limits
	var map_cellsize
	var cam = player.get_node("Camera2D")
	var title_cam = get_node("Sprite/Camera2D")
	
	cam.current == false
	title_cam.current == true
	
	matching_scene_trigger = globals.matching_scene_trigger
	globals.matching_scene_trigger = ""
	ResourceSaver.save("res://globalresource.tres", globals)
	
	
	if curr_scene.get_name() == "Title":
		cam.zoom.x = 0.9
		cam.zoom.y = 0.9
		player.visible == false
		cam.current == false
		title_cam.current == true
		
		title_cam.scale.x = 1.5
		title_cam.scale.y = 1.5
		
	# rmber to add reverse of above for future scenes
	
	title_cam.limit_left = get_node("Sprite").get_height.x  * map_cellsize.x
	title_cam.limit_top = get_node("Sprite").get_height.y * map_cellsize.y
	title_cam.limit_right = get_node("Sprite").width.x * map_cellsize.x
	title_cam.limit_bottom = get_node("Sprite").height.y * map_cellsize.y
	
	if matching_scene_trigger != "":
		var scene_trigger = curr_scene.get_node(matching_scene_trigger)
		# FIXME: this check is probably indicative of poor design
		if scene_trigger != null:
			var position = scene_trigger.get_child(1).global_position
			player.global_position = position
	else:
		var start_position = player.get_node("Position2D")
		player.global_position = start_position.global_position
	
	register_scene_triggers()

func _notification(notif: int):
	match notif:
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST, MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			# FIXME: probably a cleaner way to do this
			globals.matching_scene_trigger = ""
			ResourceSaver.save("res://globalresource.tres", globals)
		_:
			pass

func on_scene_trigger_entered(colliding_body, scene_trigger):
	print("Entered: ", scene_trigger.get_name(), " < ", colliding_body.get_name())
	if colliding_body.name == "Player":
		scene_change(scene_trigger.get_name())

func scene_change(scene_trigger):
	var sceneChangePlayer = world.get_node("SceneChangePlayer")
	sceneChangePlayer.play("SceneChangeFade")
	yield(get_tree().create_timer(0.3), "timeout")
	
	var next_scene
	match scene_trigger.rfind("(") - 1:
		-2:
			next_scene = scene_trigger.substr(3)
		var n:
			next_scene = scene_trigger.substr(3, n - 3)

	matching_scene_trigger = scene_trigger.replace(next_scene, curr_scene.get_name())
	globals.matching_scene_trigger = matching_scene_trigger
	ResourceSaver.save("res://globalresource.tres", globals)
	
	world.remove_child(world.get_child(1))
	var next_scene_packed = load(str(next_scene, ".tscn"))
	world.add_child_below_node(world.get_node("SceneChangePlayer"), next_scene_packed.instance())

# ?FIXME: scene triggers have to be manually given group "Scene Trigger"
# can this be more streamlined?!?!
func register_scene_triggers():
	var scene_triggers = get_tree().get_nodes_in_group("Scene Trigger")
	
	for scene_trigger in scene_triggers:
		scene_trigger.connect("body_entered", self, "on_scene_trigger_entered", [scene_trigger])
