extends CharacterBody2D

class_name Base_Agent

# will most likely use these constants in the future
# constsant to be used in case of checking the current state
enum Agent_State {
	IDLE,
	ENROUTE,
	PAUSED,
	EVENT, # To signal and event was emitted
	WAITING # to signal that a agent is waiting for help
}

var speed := 75.0
var state := Agent_State.IDLE
var target_position := Vector2()
var string_id: StringName

# attributes relating to statistics
var events_responded: int = 0
var events_successes: int = 0
var events_failures: int = 0


# tracks whether or not this current agent is dealing with something
var is_busy := false
# used to track the agent type
var agent_type: StringName = ""
# used to track agent happiness
var content:float = 10 
# used as a radius for how far to wander to given their current position
var idle_radius = 200
# helps to time how long the agent will pause after idle movement
var pause_timer = 0.0
# used to indicate how effective an agent type is during crisis
var effectiveness_in_crisis = 0.5

var is_responding_to_event = false # checks whether agent is responding to an event
var event_target_id: StringName # keeps the target id of the agent in crisis

# basic function for movement
func move_to(target: Vector2):
	target_position = target
	state = Agent_State.ENROUTE

# picks a random set of coords within the map to move to. 
# used to help simulate ilding
func pick_target():
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * idle_radius
	var raw_target = global_position + offset

	# get screen/world bounds
	var viewport_rect = get_viewport_rect()

	# clamp target so it stays inside the screen
	var clamped_x = clamp(raw_target.x, 0, viewport_rect.size.x)
	var clamped_y = clamp(raw_target.y, 0, viewport_rect.size.y)

	move_to(Vector2(clamped_x, clamped_y))

# basic means of sprite movement towards target location
func _physics_process(delta: float) -> void:
	match state:
		Agent_State.ENROUTE:
			is_busy = true
			var distance_to_target = target_position - global_position

			# checks if agent is within range of the target
			if distance_to_target.length() < 100:
				velocity = Vector2.ZERO
				if is_responding_to_event:
					state = Agent_State.EVENT   # responder enters EVENT state
				else:
					state = Agent_State.PAUSED
			else:
				# start the movement
				velocity = distance_to_target.normalized() * speed # uses a built in velocity variable
				move_and_slide() # built in movement method
		Agent_State.PAUSED:
			is_busy = false
			# wait till timer reaches zero before switching back to idle
			pause_timer -= delta
			if pause_timer <= 0: state = Agent_State.IDLE
		Agent_State.IDLE:
			is_busy = false
			pick_target()
		Agent_State.EVENT:
			# resolve the event
			Sim_Manager.resolve_event(self)
			is_responding_to_event = false
			state = Agent_State.PAUSED
			pause_timer = randf_range(0.5, 1.5)
			
	
	# once the agent has reached within a certain range of the target posi,
	# consider the target posi reached and return the agent back to IDLE
	# to stop the agent from overshooting their target


func is_occupied() -> bool: return is_busy
func get_agent_type() -> StringName: return agent_type
func set_agent_type(at: StringName): agent_type = at
func set_effectiveness_in_crisis(e: float): effectiveness_in_crisis = e
