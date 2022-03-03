extends CanvasLayer

signal make_planet

onready var planets = {
	"Terran Wet": preload("res://PlanetsUntransformed/Rivers/Rivers.tscn"),
	"Terran Dry": preload("res://PlanetsUntransformed/DryTerran/DryTerran.tscn"),	
	"Islands": preload("res://PlanetsUntransformed/LandMasses/LandMasses.tscn"),
	"No atmosphere": preload("res://PlanetsUntransformed/NoAtmosphere/NoAtmosphere.tscn"),
	"Gas giant 1": preload("res://PlanetsUntransformed/GasPlanet/GasPlanet.tscn"),
	"Gas giant 2": preload("res://PlanetsUntransformed/GasPlanetLayers/GasPlanetLayers.tscn"),
	"Ice World": preload("res://PlanetsUntransformed/IceWorld/IceWorld.tscn"),
	"Lava World": preload("res://PlanetsUntransformed/LavaWorld/LavaWorld.tscn")
}

func _ready():
	for k in planets.keys():
		$HBoxContainer/OptionButton.add_item(k)

func _on_OptionButton_item_selected(index):
	var chosen = planets[planets.keys()[index]]
	emit_signal("make_planet", chosen)
