extends Node
class_name NavigationService

var astar := AStar2D.new() # intitalized astar
const TILE_SIZE = 16 # constant tile size



# takes a given tilemap and rebuilds it in the astar algorithm
func rebuild_from_tilemap(tilemap: TileMapLayer):
	astar.clear() # ensure astar is cleared before rebuild

	# intially add the points from the tilemap
	for cell in tilemap.get_used_cells():
		if is_walkable(cell):
			var id = cell_to_id(cell)
			#astar.add_point(id, cell * tile_size)

	for cell in tilemap.get_used_cells():
		if is_walkable(cell):
			var id = cell_to_id(cell)
			for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
				var n = cell + dir
				if is_walkable(n):
					astar.connect_points(id, cell_to_id(n), true)

func get_path_to_target(start: Vector2i, goal: Vector2i) -> Array[Vector2]:
	var sid = cell_to_id(start)
	var gid = cell_to_id(goal)
	if astar.has_point(sid) and astar.has_point(gid):
		return astar.get_point_path(sid, gid)
	return []

func cell_to_id(cell: Vector2i) -> int:
	return (cell.x << 16) | cell.y

func is_walkable(cell: Vector2i):
	print()
