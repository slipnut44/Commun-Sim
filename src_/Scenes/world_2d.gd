extends Node2D

# note, that this script has been set as global, 
# so other scripts can access functions, and variables

# variable for building_manager. used whenever user needs to place a building or road
@onready var bldng_mngr = $Building_Manager
@onready var shortcut_mngr = $Shortcut_Manager
@onready var ground_tilemap = $TileLayer_Ground

# constants
const GRASS_TILE_ID

# TODO: remove everything below when done testing base agent movement
func _ready():
	# testing agent movement. 
	# TODO: need to make it so that it moves along a defined road. and if theres no road, then agents stay within a smaller radius of their buildings
	var resident_scene = preload("res://Scenes/Agents/resident_agent.tscn")
	var agent = resident_scene.instantiate()
	add_child(agent)
	agent.global_position = Vector2(100, 25)
	agent.move_to(Vector2i(500, 300))

	# setting up shortcuts
	shortcut_mngr.register_shortcut("build", KEY_B, true)
	shortcut_mngr.shortcut_pressed.connect(_on_shortcut_pressed)
	
# handles the logic of when a shortcut signal was sent from the ShortcutManager script
func _on_shortcut_pressed(action_name: StringName):
	if action_name == "build": bldng_mngr.start_placing(true)

# returns true if a given world position allows for a certain building type to be placed
func can_place_at(world_pos: Vector2) -> bool:
	# converts the world position to tile coordinates
	var tile_pos = ground_tilemap.local_to_map(world_pos)
	
	# only place buildings on grass tiles
	var tile_id = ground_tilemap.get_cell_source_id(tile_pos)
	
	# returns true on success
	return tile_id == GRASS_TILE_ID
	
