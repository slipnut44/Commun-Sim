extends Node

# note, that this script has been set to be globally accessible

# initial simulator engine that holds all agents as instances within a dict.
# aiming to expand it to make use of the world tree and signals

# constants that will be used to help indentify agent types
const HOME = "Home"
const POLICE = "Police_Station"
const COM_CEN = "Community_Center"
const SOC_SER = "Social_Service"

const BOTTLE_NECK = "everyone is busy"

const MAX_CONTENT = 25



# will be the form of "<Agent Type>, <Agent Number>": <Agent Obj> 
var agents : Dictionary[StringName, Base_Agent]= {} 
# used to keep track of agent id's as they're added
var next_agent_id = 0
# used to keep track of the agent node within the world scene tree
var AGENT_NODE

var report_saved := false # tracks whether the report was already saved

# effectiveness rates loaded from file
var effectiveness_rates = {
	"home": 0.2,
	"social": 0.6,
	"community": 0.56,
	"police": 0.4
}

# generates and formats a report of agent statistics to a string
func generate_report() -> String:
	var report := ""
	report += "=== Simulation Report ===\n\n"

	# --- Aggregate stats by agent type ---
	var type_stats := {}  # type -> {responded, success, failure}

	for aID in agents:
		var a = agents[aID]

		if not type_stats.has(a.agent_type):
			type_stats[a.agent_type] = {
				"responded": 0,
				"success": 0,
				"failure": 0
			}

		type_stats[a.agent_type]["responded"] += a.events_responded
		type_stats[a.agent_type]["success"] += a.events_successes
		type_stats[a.agent_type]["failure"] += a.events_failures

	report += "--- Agent Type Performance ---\n"

	for t in type_stats.keys():
		var s = type_stats[t]

		var rate := 0.0
		if s["responded"] > 0:
			rate = float(s["success"]) / float(s["responded"]) * 100.0

		report += "%s:\n" % t
		report += "  Responded: %d\n" % s["responded"]
		report += "  Successes: %d\n" % s["success"]
		report += "  Failures: %d\n" % s["failure"]
		report += "  Success Rate: %.2f%%\n\n" % rate

	# --- Average content of Home agents ---
	var total_content := 0.0
	var home_count := 0

	for aID in agents:
		var a = agents[aID]
		if a.agent_type == HOME:
			total_content += a.content
			home_count += 1

	var avg_content := 0.0
	if home_count > 0:
		avg_content = total_content / home_count

	report += "--- Home Agent Content ---\n"
	report += "Average Content: %.2f / %d\n" % [avg_content, MAX_CONTENT]

	return report

# creates a new file in the launch directory for the agent success report
func create_new_file(path: String = ""):
	if report_saved:
		return
	report_saved = true

	# Use executable directory first (for built game), then user data directory (for editor)
	if path.is_empty():
		# Try executable directory first
		var exe_path = OS.get_executable_path().get_base_dir() + "/report.txt"
		if FileAccess.file_exists(exe_path) or OS.get_executable_path().get_base_dir().count('/') > 1:
			path = exe_path
		else:
			# Fall back to user data directory
			path = OS.get_user_data_dir() + "/report.txt"

	print("[REPORT]: Saving report...")

	var report := generate_report()

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not write report file")
		return

	file.store_string(report)
	file.close()

	print("[REPORT]: Saved to ", path)

# once the games closes save a new txt file report
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST: 
		create_new_file()

func _ready() -> void:
	AGENT_NODE = get_node("/root/The_World/Agents")
	
	# Load effectiveness rates from file at simulation startup
	load_effectiveness_rates_from_file()

# Load effectiveness rates from success_rates.txt file
func load_effectiveness_rates_from_file():
	# Try multiple paths: user data dir first (for editor), then executable dir (for built game)
	var paths_to_check = [
		OS.get_user_data_dir() + "/success_rates.txt",  # User data directory (for editor)
		OS.get_executable_path().get_base_dir() + "/success_rates.txt"  # Executable directory (for built game)
	]
	
	var path = ""
	for check_path in paths_to_check:
		print("Checking for success rates file at: ", check_path)
		if FileAccess.file_exists(check_path):
			path = check_path
			break
	
	if path.is_empty():
		print("Success rates file not found in any location, using defaults")
		return
	
	print("Found success rates file at: ", path)
	
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Failed to open success rates file, using defaults")
		return
	
	var file_content = file.get_as_text().strip_edges()
	if file_content.is_empty():
		print("Success rates file is empty, using defaults")
		return
	
	var parts := file_content.split(",", false)
	if parts.size() != 4:
		print("Invalid format in success rates file, using defaults")
		return
	
	var rates = []
	for p in parts:
		rates.append(float(p.strip_edges()))
	
	effectiveness_rates["home"] = rates[0]
	effectiveness_rates["social"] = rates[1]
	effectiveness_rates["community"] = rates[2]
	effectiveness_rates["police"] = rates[3]
	print("Loaded effectiveness rates: ", effectiveness_rates)

func generate_agent_id(n: StringName) -> StringName:
	var id = "[%s Agent : %d]" % [n, next_agent_id]
	next_agent_id += 1
	return id

# responsible for adding the agent to the dictionary in the format listed above. 
# takes in a Base_Agent object as a param to be processed
func register_agent(agent: Base_Agent):
	agents[agent.string_id] = agent

	# indicate in the console the agent that has been registered
	print("[AGENT]: ", agent.string_id, " has been registered")

# handles probabilites invovlved in resolving event
func resolve_event(responder: Base_Agent):

	var crisis_id = responder.event_target_id
	var crisis_agent = agents[crisis_id]

	# save the responders effectiveness
	var eff = responder.effectiveness_in_crisis
	responder.events_responded += 1

	if randf() <= eff:
		crisis_agent.content += 3.0
		responder.events_successes += 1
		print("[SUCCESS]: ", responder.string_id, " helped ", crisis_id)
	else:
		crisis_agent.content -= 2.0
		responder.events_failures += 1
		print("[FAILURE]: ", responder.string_id, " failed to help ", crisis_id)

	# crisis agent returns to idle
	crisis_agent.state = Base_Agent.Agent_State.PAUSED
	crisis_agent.pause_timer = randf_range(0.5, 1.5)

# simplified event function. logic driving how agents will respond/produce to an event
# takes in the agent id for the respective agent that produced the event
func handle_event(agent_id_in_crisis: StringName):
	print(agent_id_in_crisis, " triggered an event")

	var available_aID = find_free_agent()
	if available_aID != BOTTLE_NECK:
		# indicate the responder is now busy 
		agents[available_aID].is_responding_to_event = true
		agents[available_aID].event_target_id = agent_id_in_crisis

		# can start moving the agent towards the event
		var crisis_posi = Vector2i(agents[agent_id_in_crisis].global_position) # ensure its converted into int coords
		agents[available_aID].move_to(crisis_posi)

		# signal response
		print("[RESPONSE]: ", available_aID, " moving to ", crisis_posi, " to assist ", agent_id_in_crisis)
	else:
		if agents[agent_id_in_crisis].content != 0: agents[agent_id_in_crisis].content -= 3
		print("[WARNING]: unhandled event from ", agent_id_in_crisis, " their content levels is now: ", agents[agent_id_in_crisis].content)

# looks up the agents dict for an agent labelled as free or not busy.
# return the agents id in the dictionary upond success. on failure, it will return 
# the string constanst BOTTLE_NECK
func find_free_agent() -> StringName:
	for aID in agents:
		var person = agents[aID]
		# first search for social workers
		if not person.is_occupied() and person.agent_type == SOC_SER: return aID
	
	for aID in agents:
		var person = agents[aID]
		# if no social workers search for community workers
		if not person.is_occupied() and person.agent_type == COM_CEN: return aID

	for aID in agents:
		var person = agents[aID]
		# if theres no other support groups, then call the police
		if not person.is_occupied() and person.agent_type == POLICE: return aID 

	return BOTTLE_NECK
