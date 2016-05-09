local simplex = require "utils.simplex"

--[[
SLOT 
	{
		grid_pos		vector3
		pos				vector3
		neighbours		table
		resource		number
		has_stone		bool
	}
	

--]]


local M = {}

function M.set_stone(slot,bool)
	slot.has_stone = bool
	msg.post("/cave","set_stone",{x = slot.grid_pos.x, y = slot.grid_pos.y, bool = bool})
end

local noise_scale = 0.09
local threshold = 0.8

function M.create(width,height)
	simplex.seedP(123431)
	-- creating grid and adding slots
	M.grid = {}
	for x = 1, width, 1 do
		local column = {}
		for y = 1, height, 1 do
			local slot = {
				grid_pos = vmath.vector3(x,y,0),
				pos = vmath.vector3((x-0.5)*64,(y-0.5)*64,0),
				neighbours = {},
				items = {},
				has_stone = true,
			}
			
			-- adding resources
				local val = (simplex.Noise2D(x*noise_scale,y*noise_scale)+1)/2 -- value 0-1
    			local tile = math.ceil((val-threshold)/(1-threshold)*2)
    			if tile > 0 then 
    				slot.resource = tile
    			end
			
			
			
			
			
			
			
			table.insert(column, slot)
		end
		table.insert(M.grid, column)
	end
	
	-- adding neighbours as k/v pairs
	for x,column in ipairs(M.grid) do
		for y,slot in ipairs(column) do
			local n = slot.neighbours
			if x > 1 then
				n["west"] = M.grid[x-1][y]
			end
			if x < width then
				n["east"] = M.grid[x+1][y]
			end
			if y > 1 then
				n["south"] = M.grid[x][y-1]
			end
			if y < height then
				n["north"] = M.grid[x][y+1]
			end
		end
	end		

end

return M