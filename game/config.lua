M = {}
M.directions = { "north", "west", "south", "east" }
M.prio_weights = {
	stone = 5,
	ground = 1,
	same_direction = 125,
	resource = 100,
}
return M