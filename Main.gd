extends Control


onready var camera = $Camera2D
var move = Vector2(0,0)
var check = load("res://Check.tscn")
var canplace = true
var checks = {}

func _ready():
	load_json()
	put_points()


func _process(delta):
#	if camera.position > Vector2(-1,-1) and camera.position < Vector2(6747, 4727):
	camera.position += move * 20
	if camera.position.x < -1:
		camera.position.x = 0
	if camera.position.x > 6747:
		camera.position.x = 6747
	if camera.position.y < -1:
		camera.position.y = 0
	if camera.position.y > 4727:
		camera.position.y = 4727

func put_points():
	if checks != null:
		for i in checks.checks:
			var checked = check.instance()
			checked.name = str(i)
			add_child(checked)
			var points = Vector2(checks.checks[i].x, checks.checks[i].y)
			checked.position = Vector2(points)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN and camera.zoom < Vector2(3.4, 3.4) :
			camera.zoom += Vector2(0.1, 0.1)
		if event.button_index == BUTTON_WHEEL_UP and camera.zoom > Vector2(0.3, 0.3):
			camera.zoom -= Vector2(0.1, 0.1)
		if event.is_action_released("click") and canplace:
			var checked = check.instance()
			add_child(checked)
			checked.position = get_global_mouse_position()
			var pos = {"x": checked.position.x, "y": checked.position.y}
			checks.checks[str(checks.num)] = pos
			checked.name = str(checks.num)
			checks.num += 1
			write_json()

func write_json():
	var file = File.new()
	file.open("user://HKMaps/Data.json", File.WRITE)
	file.store_line(to_json(checks))
	file.close()

func load_json():
	var file = File.new()
	if not file.file_exists("user://HKMaps/Data.json"):
		var dir = Directory.new()
		dir.open("user://")
		var val = dir.make_dir("HKMaps")
		print(val)
		file.open("user://HKMaps/Data.json", File.WRITE)
		var new = {"checks": {}, "num":1}
		file.store_string(to_json(new))
		file.close()
	file.open("user://HKMaps/Data.json", File.READ)
	checks = parse_json(file.get_as_text())

func remove_json(point):
	var sim = checks.checks.erase(point)
	print(sim)
	write_json()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Left_mouse_entered():
	move.x = -1

func _on_Left_mouse_exited():
	move.x = 0

func _on_Right_mouse_entered():
	move.x = 1

func _on_Right_mouse_exited():
	move.x = 0

func _on_Top_mouse_entered():
	move.y = -1

func _on_Top_mouse_exited():
	move.y = 0

func _on_Bottom_mouse_entered():
	move.y = 1

func _on_Bottom_mouse_exited():
	move.y = 0

func _on_TextureRect_mouse_entered():
	canplace = true

func _on_TextureRect_mouse_exited():
	canplace = false
