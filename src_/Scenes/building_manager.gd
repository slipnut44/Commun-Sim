# script that handles the logic of building and road placment on the game map.
# ensuring buildings aren't placed on top of one another or on water tiles.

extends Node2D

# onready esnures that the ground map is only pulled when we need it.
# ensuring we have all the other nodes loaded already. 
# additionally the $ sign is used to point to objects within the scene structure

# constants regarding the selected building scene to load and valid tile placements
const FORBIDDEN = 'forbid'
const ALL_BUILDINGS = "all"
const HOME = "Home"
const POLICE = "Police_Station"
const COM_CEN = "Community_Center"
const SOC_SER = "Social_Service"
const BRIDGE = "Bridge"

# TODO: correct these constants to be 
# constants reagrding tileset id's
const GRASS_TERRAIN = "Grass"
const WATER_TERRAIN = "Water"
const BUILDING_TERRAIN = "Building"
const BRIDGE_TERRAIN = "Bridge"	
const MOUNTAIN_TERRAIN = "Mountain" # TODO: add mountains to the terrain

# constants for scene addresses
const HOME_SCENE_ADDY = 	"res://Scenes/Buildings/Home.tscn" 
const POLICE_SCENE_ADDY = 	"res://Scenes/Buildings/Police_Station.tscn"
const COM_CEN_SCENE_ADDY = 	"res://Scenes/Buildings/Community_Center.tscn"
const SOC_SERV_SCENE_ADDY = "res://Scenes/Buildings/Social_Service.tscn"

@onready var ground_mapping = $"../TileLayer_Ground"  # grabbing the ground map in the scene
@onready var placement_mask = $"../Building_Rd_Placement_Mask" # handles the logic of where buildings can be placed
@onready var buildings = $"../Buildings" # carries the placed buildings from the player

# used as a ghosting preview of where the user is intending to place a building
var preview: Node2D

# constants regarding the preloaded scenes possible. ensuring that the previews are 
# always only instantiated once when needed
const scene_dict = {
	HOME: HOME_SCENE_ADDY,
	POLICE: POLICE_SCENE_ADDY,
	COM_CEN: COM_CEN_SCENE_ADDY,
	SOC_SER: SOC_SERV_SCENE_ADDY
}

var is_placing := false # indicates when the user wants is placing something
var valid_building_on_tile := 'forbid' # indicates if the current tile wthin _process can 
								  # have a building or road placed on it. 
								  # forbidden,
								  # homes,
								  # roads, 
								  # bridges,
								  # all
var selected_building_type := '' # indicates the currently selected building
								 # home,
								 # police,
								 # social services,
								 # community centre,
								 # roads,
								 # bridges
var can_place_here = false # indicates if a building can be placed on a tile or not

# TODO: fix the following functions so that it works in tandem with the UI. right now is for testing purposes
# is used when needing to place a building on the map
func place_building():
	# instantiating the needed scene
	var b_scene = load(scene_dict[selected_building_type])
	var b_instant = b_scene.instantiate()
	# linking global position of the preview
	b_instant.global_position = preview.global_position
	# adding the building to the building node in the world tree
	buildings.add_child(b_instant)
	# intialize a new property for the building node to save its position relative to the ground layer
	b_instant.set("tile_pos", ground_mapping.local_to_map(ground_mapping.to_local(preview.global_position)))

# TODO: fix the following  functions so that it functions only when the user is placing a building or road

# updates at each frame what the user is doing with their mouse
func _process(delta):
	if is_placing:
		var mouse_posi = get_global_mouse_position() # getting the global mouse position
		var tile_posi = ground_mapping.local_to_map(ground_mapping.to_local(mouse_posi)) # getting the tile position in relation to current mouse position and the local position of the map
		var snapped_posi = ground_mapping.map_to_local(tile_posi) # gets exact pixel coords in relation to the mouse over the corresponding tile
		preview.position = snapped_posi

		# TODO: remove later
		print("curr tile position", tile_posi, ", and is_placing is ", is_placing)
		print("ground pos:", ground_mapping.global_position)
		print("mouse:", mouse_posi)
		print("local:", ground_mapping.to_local(mouse_posi))
		print("tile:", tile_posi)

		# get the terrain name
		var tn := StringName(retrieve_terrain_name(tile_posi))

		# check if atlas coord is valid
		valid_terrain(tn)

# TODO: remove print statements after debugging
# responsible for retrieving the terrain name corresponding to a given 2d coordinate
func retrieve_terrain_name(posi: Vector2i) -> StringName:
		# gathering information to retrieve tile information based on where the mouse is
		var source_id = ground_mapping.get_cell_source_id(posi)
		if source_id == -1: # theres no tile here
			print("couldnt retrieve tile source id")
			return "" 
		var atlas_coords = ground_mapping.get_cell_atlas_coords(posi)
		var alt = ground_mapping.get_cell_alternative_tile(posi)

		# get the exact tile data from the tileset based on the the source id, atlas coords, and alt values
		var tile_data = ground_mapping.tile_set.get_source(source_id).get_tile_data(atlas_coords, alt)
		if tile_data == null:
			print("couldn't get the tile data")
			return ""

		# getting the terrain set, the terrain object, tileset, and terrain name
		var terrain_set = tile_data.terrain_set # note if tile has no terrain set, then will be set to -1
		var terrain = tile_data.terrain
		if terrain_set == -1 or terrain == -1:
			print("issue with getting the terrain/terrain_set")
			return ""
		
		return ground_mapping.tile_set.get_terrain_name(terrain_set, terrain)

# function that check whether or not a placed building is occupying a tile
func is_tile_occupied(posi):
	for b in buildings.get_children():
		# using the arbitrary var we made earlier; can pull out the tile position we saved to the scene node
		if b.tile_posi == posi: can_place_here = false
		# TODO: add feature that also loops through the new road tilelayer map for road children
	can_place_here = true

# determines if the given terrain is valid for the building being placed
func valid_terrain(t: StringName):
	print("current tile id ", t)
	# TODO: add more dynamic building permissions
	# initial placement permission layer
	# responsible for setting what types of buildings are allowed on the current tile that was _process(ed)
	match t: 
		GRASS_TERRAIN: valid_building_on_tile = ALL_BUILDINGS; 
		WATER_TERRAIN: valid_building_on_tile = BRIDGE	
		_: valid_building_on_tile = FORBIDDEN

	# the final placement permission layer
	# these if statements are for the mapping the whether or the selected building can be placed on the tile	
	if valid_building_on_tile == ALL_BUILDINGS: can_place_here = true # checks if any building type is valid on the current tile
	elif valid_building_on_tile == FORBIDDEN: can_place_here = false # checks if no building types is valid on the selected tile
	elif valid_building_on_tile == selected_building_type: can_place_here = true # if the selected building 
																				 # type is either a home, road, or bridge, then 
																				 # they're valid on their respective tiles
	else: can_place_here = false
# takes user input based on mouse click
func handle_input():
	print("building has been placed")
	place_building()
	start_placing(false)
		
# function that switches whether or not the user is placing a building or not
func start_placing(setting: bool):
	is_placing = setting
	# show or hide the preview based on if the user is trying to place something
	if is_placing: preview.show()
	else: 
		if preview != null: preview.hide()
		can_place_here = false
	

# sets the currently selected building
func set_current_building(build_type: String): 
	# check if being asked to reset the selected building type
	if build_type == "": 
		selected_building_type = build_type
	# if building type isn't being reset
	else:
		# if the preview was already added as a child, ensure its removed so it can be refreshed
		if ground_mapping.is_ancestor_of(preview): ground_mapping.remove_child(preview)

		selected_building_type = build_type # ensure that the selected building is saved

		# load the scene and instatiate it to the preview
		var s = load(scene_dict[build_type])
		preview = s.instantiate()
		# add the preview as a child to the ground map so local coords can match 
		ground_mapping.add_child(preview) # ensure that the building is being shown relative to the local coords of the ground map tilelayer
		preview.modulate = Color(1, 1, 1, 0.5) # making the preview semi-transparent
		preview.hide()

# gets the currently selected building
func get_current_building() -> String: return selected_building_type
