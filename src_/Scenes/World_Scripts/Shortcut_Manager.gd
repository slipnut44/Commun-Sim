extends Node

# handles all shortcuts within the game. works based on firing
# signals whether a registered shortcut has been pressed

class_name Shortcut_Manager

signal shortcut_pressed(action_name: StringName) # broadcasting signal when a shortcut has been pressed

var shortcuts = {} # saved dictionary of shortcuts

func register_shortcut(action_name: StringName, key: Key, use_ctrl := false):
	var key_event = InputEventKey.new() # temp event
	key_event.keycode = key
	key_event.ctrl_pressed = use_ctrl
	key_event.command_or_control_autoremap = use_ctrl
	
	var sc = Shortcut.new() # creating the shortcut to be saved with the provided key input event
	sc.events = [key_event]
	shortcuts[action_name] = sc

# this function is responsible for signal firing logic
func _unhandled_key_input(given_event: InputEvent):
	# search through all saved actions
	for action_name in shortcuts.keys():
		var shortcut: Shortcut = shortcuts[action_name]

		# if the triggered event matches whats in records, emit a signal 
		# and set the input as handled
		if given_event.is_pressed() and not given_event.is_echo() and shortcut.matches_event(given_event):
			emit_signal("shortcut_pressed", action_name)
			get_viewport().set_input_as_handled()
