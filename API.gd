extends Node

var gui

enum export_mode {NONE, IMG, GIF, SPRITESHEET}
var planet_types = {
	TerranWet = "Terran Wet",
	TerranDry = "Terrand Dry",
	Islands = "Island",
	NoAtmosphere = "No atmosphere",
	GasGiant1 = "Gas giant 1",
	GasGiant2 = "Gas giant 2",
	IceWorld = "Ice World",
	LavaWorld = "Lava World",
	Asteroid = "Asteroid",
	BlackHole = "Black Hole",
	Galaxy = "Galaxy",
	Star = "Star",
}

func _ready():
	gui = get_tree().root.get_node("GUI")
	yield(get_tree(), "idle_frame")
	
	# some examples of how you could use it.
#	_create_planet(planet_types.TerranWet, export_mode.IMG, 34207432, 200, PI * 0.5, Vector2(0.75,0.75), true, {})
#	_create_planet(planet_types.TerranWet, export_mode.SPRITESHEET, 34207432, 200, PI * 0.5, Vector2(0.75,0.75), true, {"frames_w": 20, "frames_h": 5, "pixel_margin": 0})
#	_create_planet(planet_types.TerranWet, export_mode.GIF, 34207432, 100, PI * 0.5, Vector2(0.75,0.75), true, {"frames": 300, "length": 5})




# create a planet with the following params
# type (String) - choose from planet_types, for example: planet_types.TerranWet .
# export mode (enum) - image will be saved according to export type. To not export, use export_mode.NONE.
# seed (int) - unique seed of the planet. leave 0 for random
# pixels (int) - amount of pixels planet will be rendered in (Black Hole and Gas Planet 2 will use more pixels than given because of their rings).
# rotation (float) - radial rotation of planet.
# light_origin (Vector2) - where planet will be lit from, from Vector2(0,0) (top left), to Vector2(1,1) (bottom right).
# dither (bool) - whether or not to dither in image.
# colors (PoolColorArray) - colorscheme that will be used for planet. Leave empty for random
# export_options (Dictionary) - options for either spritesheet or gif, containing follow info:
# { "frames_w": int, "frames_h": int, "pixel_margin": int} for spritesheets
# { "frames": int, "length": float} for gifs (length being length of gif in seconds).
func _create_planet(type, mode = export_mode.NONE, sd = 0, pixels = 100, rotation = 0, light_origin = Vector2(0.4,0.4),
 dither = true, export_options = {}, colors = PoolColorArray()):
	if sd == 0:
		gui._seed_random()
	else:
		gui.sd = sd
		
	var t = gui._lookup_type(type)
	gui._create_new_planet(t)
	gui._set_pixels(pixels)
	gui.rotate_planet(rotation)
	gui.set_light_origin(light_origin)
	gui.set_dither(dither)
	
	yield(get_tree(), "idle_frame")
	if colors.size() < 1:
		gui._randomize_colors()
	else:
		gui.set_colors(colors)
	
	yield(get_tree(), "idle_frame")
	match mode:
		export_mode.IMG:
			gui._export_img()
		export_mode.SPRITESHEET:
			gui.export_spritesheet_no_bar(Vector2(export_options.frames_w, export_options.frames_h), export_options.pixel_margin)
		export_mode.GIF:
			gui.export_gif_no_bar(export_options.frames, float(export_options.length) / export_options.frames)
