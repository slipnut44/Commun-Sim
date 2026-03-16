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

func _ready() -> void:
	# Get effectiveness rates from Sim_Manager (loaded at startup)
	EFFECT_HOME = Sim_Manager.effectiveness_rates["home"]
	EFFECT_SOC = Sim_Manager.effectiveness_rates["social"]
	EFFECT_COM = Sim_Manager.effectiveness_rates["community"]
	EFFECT_POL = Sim_Manager.effectiveness_rates["police"]
	print("Building effectiveness rates set: HOME=", EFFECT_HOME, " SOC=", EFFECT_SOC, " COM=", EFFECT_COM, " POL=", EFFECT_POL)


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
