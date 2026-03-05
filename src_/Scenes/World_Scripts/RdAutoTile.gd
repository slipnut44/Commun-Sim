# code I sourced from copilot. for some reason i couldnt get the terrain tiling to work correctly.
# Though I have no idea how tiling works so I asked it to produced a auto tiling alg to leaverage
# rather than trying to access the one in Godot

extends TileMapLayer

# ---------------------------------------------------------
# 1. Tile IDs (adjust these to match your atlas coordinates)
# ---------------------------------------------------------

enum RoadTile {
	ISOLATED,          
	END_UP,            
	END_RIGHT,         
	END_DOWN,          
	END_LEFT,          
	STRAIGHT_VERTICAL, 
	STRAIGHT_HORIZONTAL,
	CORNER_UR,         
	CORNER_RD,         
	CORNER_DL,         
	CORNER_LU,         
	T_UP,              
	T_RIGHT,           
	T_DOWN,            
	T_LEFT,            
	FOUR_WAY           
}

# ---------------------------------------------------------
# 2. Mapping bitmask → tile ID
# ---------------------------------------------------------

const MASK_TO_TILE = {
	0b0000: RoadTile.ISOLATED,
	0b0001: RoadTile.END_UP,
	0b0010: RoadTile.END_RIGHT,
	0b0100: RoadTile.END_DOWN,
	0b1000: RoadTile.END_LEFT,
	0b0101: RoadTile.STRAIGHT_VERTICAL,
	0b1010: RoadTile.STRAIGHT_HORIZONTAL,
	0b0011: RoadTile.CORNER_UR,
	0b0110: RoadTile.CORNER_RD,
	0b1100: RoadTile.CORNER_DL,
	0b1001: RoadTile.CORNER_LU,
	0b0111: RoadTile.T_UP,
	0b1011: RoadTile.T_RIGHT,
	0b1101: RoadTile.T_DOWN,
	0b1110: RoadTile.T_LEFT,
	0b1111: RoadTile.FOUR_WAY
}

# ---------------------------------------------------------
# 3. Public API — call this when placing a road
# ---------------------------------------------------------

func place_road(cell: Vector2i) -> void:
	# Set a placeholder tile (source_id = 0, atlas coords = (0,0))
	set_cell(cell, 0, Vector2i(0, 0))
	_update_road_tile(cell)

	# Update neighbors too
	for n in _neighbors(cell):
		if is_road(n):
			_update_road_tile(n)

# ---------------------------------------------------------
# 4. Core auto-tiling logic
# ---------------------------------------------------------
# 
func _update_road_tile(cell: Vector2i) -> void:
	if not is_road(cell):
		return

	var up    = is_road(cell + Vector2i(0, -1))
	var right = is_road(cell + Vector2i(1, 0))
	var down  = is_road(cell + Vector2i(0, 1))
	var left  = is_road(cell + Vector2i(-1, 0))

	var mask = 0
	mask |= int(up)    << 0
	mask |= int(right) << 1
	mask |= int(down)  << 2
	mask |= int(left)  << 3

	var tile_id = MASK_TO_TILE.get(mask, RoadTile.ISOLATED)

	# Convert tile_id → atlas coords
	var atlas_coords = _tile_id_to_atlas(tile_id)

	# source_id is usually 0 unless you have multiple TileSet sources
	set_cell(cell, 0, atlas_coords)

# ---------------------------------------------------------
# 5. Helpers
# ---------------------------------------------------------

func is_road(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) != -1

func _neighbors(cell: Vector2i) -> Array:
	return [
		cell + Vector2i(0, -1),
		cell + Vector2i(1, 0),
		cell + Vector2i(0, 1),
		cell + Vector2i(-1, 0)
	]

# ---------------------------------------------------------
# 6. Tile ID → atlas coordinate mapping
# ---------------------------------------------------------
# You MUST fill this out based on your atlas layout.
# Example assumes your 16 road tiles are at (0,6) → (3,9).

func _tile_id_to_atlas(tile_id: int) -> Vector2i:
	match tile_id:
		# the isolated piece
		RoadTile.ISOLATED:            return Vector2i(0, 6)
		# the end caps
		RoadTile.END_UP:              return Vector2i(0, 9)
		RoadTile.END_RIGHT:           return Vector2i(1, 6)
		RoadTile.END_DOWN:            return Vector2i(0, 7)
		RoadTile.END_LEFT:            return Vector2i(3, 7)
		# the vertical pieces
		RoadTile.STRAIGHT_VERTICAL:   return Vector2i(0, 8)
		RoadTile.STRAIGHT_HORIZONTAL: return Vector2i(2, 6)
		# corner pieces
		RoadTile.CORNER_UR:           return Vector2i(1, 9)
		RoadTile.CORNER_RD:           return Vector2i(1, 7)
		RoadTile.CORNER_DL:           return Vector2i(3, 7)
		RoadTile.CORNER_LU:           return Vector2i(3, 9)
		# junctions
		RoadTile.T_UP:                return Vector2i(2, 9)
		RoadTile.T_RIGHT:             return Vector2i(3, 8)
		RoadTile.T_DOWN:              return Vector2i(2, 7)
		RoadTile.T_LEFT:              return Vector2i(1, 8)
		# forway piece
		RoadTile.FOUR_WAY:            return Vector2i(2, 8)
		_:                            return Vector2i(0, 6) # fallback
