-- pathfinding for the miner. all calls must contain the 'self' param as it is just a functional module for the miner script.
local M = {}
local open 
local closed
local tp

local function print_tables()
	print("----open-------")
	for slot,v in pairs(open) do
		print(slot.grid_pos,slot.f)	
	end
	print("----closed-------")
	for slot,v in pairs(closed) do
		print(slot.grid_pos,slot.f)	
	end
end

local function check_slot(slot)
	open[slot] = nil
	closed[slot] = true
	-- uncomment to see all covered ground
	--tilemap.set_tile("/cave#tilemap", "ground", slot.grid_pos.x, slot.grid_pos.y, 6)
	for k,v in pairs(slot.neighbours) do
		if v.has_stone == false and closed[v] == nil and open[v] == nil then 
			v.parent = slot
			open[v] = true
			v.g = slot.g + 1
			v.h = math.abs(v.grid_pos.x-tp.x)+math.abs(v.grid_pos.y-tp.y)
			v.f = v.g + v.h
		elseif v.grid_pos == tp then
			v.parent = slot
			return v
		end
	end
	return nil
end

local function get_dir(slot, parent)	
	for k,v in pairs(parent.neighbours) do
		if slot == v then 
			return k 
		end
	end	
	return nil
end

-- will set the path to the target slot
function M.set_path(self, target_slot)
	open = {}
	closed = {}
	local end_path
	self.current_slot.parent = nil 
	self.path_target_slot = target_slot
	tp = target_slot.grid_pos
	-- insert start slot and neighbours in open
	self.current_slot.g = 0
	open[self.current_slot] = true
		
	local s = check_slot(self.current_slot)
	if s then return {get_dir(s,s.parent)} end -- return single direction if it's adjecent
	
	while next(open) ~= nil do
		-- check slot with lowest f
		local lowest_f = 9999  
		for slot,v in pairs(open) do
			if slot.f < lowest_f then
				lowest_f = slot.f
				lowest_slot = slot
			end
		end
		local goal = check_slot(lowest_slot)
		
		-- found target slot. Return a list of directions.
		if goal ~= nil then			
			end_path = {}
			local s = goal
			while s.parent do
				table.insert(end_path, get_dir(s,s.parent))
				-- uncomment to see full path
				tilemap.set_tile("/cave#tilemap", "ground", s.grid_pos.x, s.grid_pos.y, 17)
				local v = s
				s = s.parent
				v.parent = nil
			end
			return end_path
		end
	end
	print("ERROR: Could not find path to target")
	return nil
end

return M
