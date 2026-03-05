extends Node2D

class_name The_World

# this script matched with its parent node in the world tree handles:
# registering shortcuts, determining the active in game tool
# orchistrating the Placement_Tool

# variable for building_manager. used whenever user needs to place a building or road
@onready var bldng_mngr = $Building_Manager
@onready var shortcut_mngr = $Shortcut_Manager
@onready var ground_tilemap = $TileLayer_Ground
@onready var pc = $Placement_Tool

func _ready():
	# --- setting up shortcuts ---
	# shortcut for build mode
	shortcut_mngr.register_shortcut(pc.BUILD_SC_ALIAS, KEY_B, true)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	# shortcut for switching to building roads
	shortcut_mngr.register_shortcut(pc.BUILD_ROAD_SC_ALIAS, KEY_R, false)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	# shortcut for switching to building homes
	shortcut_mngr.register_shortcut(pc.BUILD_HOME_SC_ALIAS, KEY_H, false)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	# shortcut for switching to building police stations
	shortcut_mngr.register_shortcut(pc.BUILD_POLICE_SC_ALIAS, KEY_P, false)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	# shortcut for switching to building community centres
	shortcut_mngr.register_shortcut(pc.BUILD_COM_SC_ALLIS, KEY_C, false)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	# shortcut for activating social service building placement
	shortcut_mngr.register_shortcut(pc.BUILD_SOC_SC_ALIAS, KEY_S, false)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	
# handles the logic of when a shortcut signal was sent from the ShortcutManager script
func _on_shortcut_pressed(action_name: StringName):
	pc.set_action_mode(action_name)
