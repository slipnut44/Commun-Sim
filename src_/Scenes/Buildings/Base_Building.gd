# this script acts as the parent class for all other building elements within the game
# base feaures will include level, radius, max_agents, upgrade(), and on_click().

extends Node2D

class_name Base_Building

# basic building attributes/stats
var level := 1
var radius := 5
var max_agents := 10
var building_name := ""

# function that will be used to increase building stats
func upgrade_building():
	level += 1
	radius *= 2
	max_agents *= 3
	
# simple function activated when the building is clicked (is dummy for now)
func on_click():
	print(building_name, " was clicked")
