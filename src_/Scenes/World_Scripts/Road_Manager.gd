extends Node2D
class_name Road_manager
# this class is responsible for the logic behind the road tiling

const ROAD_SOURCE_ID = 0
const ROAD_ATLAS_COORDS = Vector2i(2,6) # straigh horizontal

# holds the tile layer holding the roads
@onready var road_map = $"../TileLayer_Road"

# determines if the user is dragging their input accross the screen
var is_dragging := false
var is_placing = false

# responsible for handling passed input from the placement controller. 
# has multiple if statements for the same event to ensure that the 
# event is captured in despite how it's recognized 
func handle_input(event):

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and is_placing:
		is_dragging = event.pressed
		if is_dragging: paint_road()

	elif event is InputEventMouseMotion and is_dragging and is_placing:
		paint_road()

	else:
		is_dragging = false
		is_placing = false
	
func paint_road():
	print("printing the road on the map")

	# gather the mouse position
	var mouse_posi = get_viewport().get_mouse_position()
	var cell = road_map.local_to_map(road_map.to_local(mouse_posi))

	# paint the cell using the road auto tiler
	road_map.place_road(cell)

#func is_occupied()
