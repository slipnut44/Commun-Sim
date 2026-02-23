# script that handles the logic of building and road placment on the game map.
# ensuring buildings aren't placed on top of one another or on water tiles.

extends Node2D

# onready esnures that the ground map is only pulled when we need it.
# ensuring we have all the other nodes loaded already. 
# additionally the $ sign is used to point to objects within the scene structure

@onready var ground_mapping = $"../TileLayer_Ground"  # grabbing the ground map in the scene

# TODO: fix the following functions so that it works in tandem with the UI. right now is for testing purposes
# is used when needing to place a building on the map
func place_building():
	# preloading the scene i need
	var home_scene = preload("res://Scenes/Buildings/Home.tscn")
	# initialize the current selected building
	var building = home_scene.instantiate()


# TODO: fix the following  functions so that it functions only when the user is placing a building or road

# updates at each frame what the user is doing with their mouse
func _process(delta):
	var mouse_posi = get_global_mouse_position() # getting the global mouse position
	var tile_posi = ground_mapping.local_to_map(mouse_posi) # getting the tile position in relation to current mouse position
	var snapped_posi = ground_mapping.map_to_local(tile_posi) # gets exact pixel coords in relation to the mouse over the corresponding tile
	# preview.position = snapped_posi line doesn't work

# takes user input based on mouse (possibly on keyboard input?)
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		place_building()
