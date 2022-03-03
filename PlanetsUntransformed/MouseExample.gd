extends Control

var zoom = 1.0
var offset = Vector2()
var prev_mouse = Vector2()
var mouse_pressed = false
var planet_seed = randi()

onready var tween = $Tween
onready var control = $PlanetHolder/Control
onready var holder = $PlanetHolder

func _ready():
	prev_mouse = get_global_mouse_position()
	$GUI/HBoxContainer/Seed.text = String(planet_seed)

func _physics_process(_delta):
	if mouse_pressed:
		
		var mouse_pos = get_global_mouse_position()
		var diff = mouse_pos - prev_mouse
		prev_mouse = mouse_pos
		offset -= diff * 0.01

		offset.x = clamp(offset.x, 0.0, ((1 / zoom) - 1) * 2.0)
		offset.y = clamp(offset.y, 0.0, ((1 / zoom) - 1) * 1.0)
	
	for c in control.get_children():
		c.material.set_shader_param("offset", offset)
		c.material.set_shader_param("zoom", zoom)

func set_zoom(z):
	var factor = zoom / z
	zoom = z
	
	offset.x = clamp(offset.x, 0.0, ((1 / zoom) - 1) * 2.0)
	offset.y = clamp(offset.y, 0.0, ((1 / zoom) - 1) * 1.0)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				mouse_pressed = true
				prev_mouse = get_global_mouse_position()
			else:
				mouse_pressed = false
		if event.button_index == BUTTON_WHEEL_UP:
			tween.interpolate_method(self, "set_zoom", zoom, max(zoom - 0.1, 0.2), 0.1, Tween.TRANS_LINEAR)
			tween.start()
		if event.button_index == BUTTON_WHEEL_DOWN:
			tween.interpolate_method(self, "set_zoom", zoom, min(zoom + 0.1, 1.0), 0.1, Tween.TRANS_LINEAR)
			tween.start()


func _on_GUI_make_planet(p):
	for c in holder.get_children():
		c.queue_free()
	
	var child = p.instance()
	child.set_seed(planet_seed)
	holder.add_child(child)
	control = child

func set_seed(sd):
	planet_seed = sd

func _on_RandSeedButton_pressed():
	planet_seed = randi()
	$GUI/HBoxContainer/Seed.text = String(planet_seed)
	control.set_seed(planet_seed)

func _on_Seed_text_changed(new_text):
	planet_seed = int(new_text)
	control.set_seed(planet_seed)
