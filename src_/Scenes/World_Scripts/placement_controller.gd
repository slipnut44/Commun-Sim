extends Node2D

# this script along with its repsective parent node handles the logic invovled with placing tiles on the screen
# from shortcuts created in world_2d.gd

class_name Placement_Controller

# constants for shortcuts
const BUILD_SC_ALIAS = "activate build mode"
const BUILD_HOME_SC_ALIAS = "build home"
const BUILD_POLICE_SC_ALIAS = "build police station"
const BUILD_SOC_SC_ALIAS = "build social services centre"
const BUILD_COM_SC_ALLIS = "build community centre"
const BUILD_BRIDGE_SC_ALIAS = "build bridge"
const BUILD_ROAD_SC_ALIAS = "build road"

# tracks whether a shortcut has been pressed. helping to enhance the logic between shortcuts in _on_shortcut_pressed 
var toggle_shortcuts = {
	BUILD_SC_ALIAS: false,
	BUILD_ROAD_SC_ALIAS: false,
}

@onready var world = $The_World
@onready var bldng_mngr = $"../Building_Manager"
@onready var rd_mngr = $"../Road_Manager"

func _unhandled_input(event):
	# building placement
	if bldng_mngr.is_placing and event is InputEventMouseButton and event.pressed and bldng_mngr.can_place_here and toggle_shortcuts[BUILD_SC_ALIAS]:
		bldng_mngr.handle_input()

	# road placement
	elif toggle_shortcuts[BUILD_ROAD_SC_ALIAS] and (event is InputEventMouseButton or event is InputEventMouseMotion):
		rd_mngr.handle_input(event)		


# helper function, used to toggle off all toggle shortcuts, but leaves out the exception
func toggle_shutoff(exception: String):
	for toggle in toggle_shortcuts:
		if toggle != exception: toggle_shortcuts[toggle] = false

func set_action_mode(mode: String):
	# --- code for overall building modes ---
	if mode == BUILD_SC_ALIAS: 
		if not toggle_shortcuts[BUILD_SC_ALIAS]: # toggle on building mode  
			toggle_shortcuts[BUILD_SC_ALIAS] = true
			print("building mode activated")

	# shortcut logic for selecting home building after building mode shortcut has been pressed
	elif mode == BUILD_HOME_SC_ALIAS and toggle_shortcuts[BUILD_SC_ALIAS]:
		print("selected home building")
		bldng_mngr.set_current_building(bldng_mngr.HOME)
		bldng_mngr.start_placing(true)

	# shortcut logic for selecting a road
	elif mode == BUILD_ROAD_SC_ALIAS and toggle_shortcuts[BUILD_SC_ALIAS]:
		print("selected road architecture")
		toggle_shortcuts[BUILD_ROAD_SC_ALIAS] = true
		rd_mngr.is_placing = true

	# shorcut logic for selecting a police building
	elif mode == BUILD_POLICE_SC_ALIAS and toggle_shortcuts[BUILD_SC_ALIAS]:
		print("selected police building")
		bldng_mngr.set_current_building(bldng_mngr.POLICE)
		bldng_mngr.start_placing(true)

	# selecting community centre building
	elif mode == BUILD_COM_SC_ALLIS and toggle_shortcuts[BUILD_SC_ALIAS]:
		print("slected community building")
		bldng_mngr.set_current_building(bldng_mngr.COM_CEN)
		bldng_mngr.start_placing(true)

	# selecting social services building
	elif mode == BUILD_SOC_SC_ALIAS and toggle_shortcuts[BUILD_SC_ALIAS]:
		print("selected social service building")
		bldng_mngr.set_current_building(bldng_mngr.SOC_SER)
		bldng_mngr.start_placing(true)

	else: # if already toggled, turn off
		#toggle_shutoff("")
		print("building mode deactivated")
		# remove the building selection from the building manager
		
