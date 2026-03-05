# resident agent script that will describe their unique movement and behaviour

extends Base_Agent

class_name Resident_Agent

# TODO: finish implementing the resident agent script and the rest of the agents

# probability that this agent will produce an event that needs response
var event_probability = 0.004

func _process(delta):
	# in the event that an agent is not occupied and probability favors, indicate an event to Sim_Manager
	if randf() < event_probability and not is_occupied(): 
		Sim_Manager.handle_event(self.string_id)
		state = Agent_State.WAITING
		velocity = Vector2.ZERO
