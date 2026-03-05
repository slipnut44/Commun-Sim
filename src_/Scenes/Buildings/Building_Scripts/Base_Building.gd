# this script acts as the parent class for all other building elements within the game
# base feaures will include level, radius, max_agents, upgrade(), and on_click().

extends Node2D

class_name Base_Building

# constants regarding building types
const HOME = "Home"
const POLICE = "Police_Station"
const COM_CEN = "Community_Center"
const SOC_SER = "Social_Service"

const HOME_AGENT_SCENE_ADDY = "res://Scenes/Agents/resident_agent.tscn"
const COMMUNITY_AGENT_SCENE_ADDY = "res://Scenes/Agents/community_member_agent.tscn"
const SOCIAL_AGENT_SCENE_ADDY = "res://Scenes/Agents/social_worker_agent.tscn"
const POLICE_AGENT_SCENE_ADDY = "res://Scenes/Agents/police_agent.tscn"

# effectiveness of each building agents respectively
var EFFECT_HOME = 0.2
var EFFECT_POL  = 0.4
var EFFECT_COM  = 0.56
var EFFECT_SOC  = 0.6

const scene_dict = {
	HOME: HOME_AGENT_SCENE_ADDY,
	POLICE: POLICE_AGENT_SCENE_ADDY,
	COM_CEN: COMMUNITY_AGENT_SCENE_ADDY,
	SOC_SER: SOCIAL_AGENT_SCENE_ADDY
}

# maps building names to their agent effectiveness
var effectiveness_levels_dict = {
	HOME: EFFECT_HOME,
	POLICE: EFFECT_POL,
	COM_CEN: EFFECT_COM,
	SOC_SER: EFFECT_SOC
}

# basic building attributes/stats
var level := 1
var radius := 5
var max_agents := 10
var building_name := ""

# takes in a txt file and returns the full text of whats inside
func load_data(path := "user://success_rates.txt") -> String:
		# Check if file exists first
	if not FileAccess.file_exists(path):
		return ""  # nonexistent → skip

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""  # failed to open → skip

	if file.get_length() == 0:
		return ""  # empty → skip

	return file.get_as_text()

# parses information from within the file. taking 4 float values
# comma seperated and on a single line. saving them in the 
# effectiveness values above
func parse_za_file(line: String) -> Array[float]:
	if line.is_empty():
		return []  # nothing to parse

	var parts := line.strip_edges().split(",", false)
	if parts.size() != 4:
		return []  # malformed input

	# Convert each part to an int
	var nums := []
	for p in parts:
		nums.append(float(p.strip_edges()))

	return nums

func _ready() -> void:
	var data := load_data()
	if data.is_empty(): print("No success rate data to load")
	else: 
		print("Loaded: ", data)
		var tmp: Array[float] = parse_za_file(data)

		if tmp.is_empty(): print("error parsing line")
		else:
			EFFECT_HOME = tmp[0]
			EFFECT_SOC =  tmp[1]
			EFFECT_COM =  tmp[2]
			EFFECT_POL =  tmp[3]


# function that will be used to increase building stats
func upgrade_building():
	level += 1
	radius *= 2
	max_agents *= 3
	
# simple function activated when the building is clicked (is dummy for now)
func on_click():
	print(building_name, " was clicked")
	
# spawns agents upon being placed for the simulation manager to manipulate
func on_placed():
	for i in range(max_agents):
		# loading and instantiating the agent scene based on building name
		var tmp = load(scene_dict[building_name])
		var a_scene = tmp.instantiate()
		
		# set their name
		a_scene.set_agent_type(building_name)

		# assigning id
		a_scene.string_id = Sim_Manager.generate_agent_id(building_name)

		# set the effectiveness of each agent based on their respective building
		a_scene.set_effectiveness_in_crisis(effectiveness_levels_dict[building_name])

		# set up to spawn agents around where the building was placed
		var spawn_radius = 32.0
		var angle = randf() * TAU
		var offset = Vector2(cos(angle), sin(angle)) * spawn_radius

		a_scene.global_position = global_position + offset

		# adding the new scene as a child to the Agent node in the world scene tree
		Sim_Manager.AGENT_NODE.add_child(a_scene)

		Sim_Manager.register_agent(a_scene)

func set_max_agents(m: int): max_agents = m
func set_building_name(n: StringName): building_name = n
