local M = {}

M.miners = {}

function M.add()
	
	M.miners[msg.url()] = true
end

function M.remove()
	M.miners[msg.url()] = nil
end

function M.post(message_id, message)
	for k,v in pairs(M.miners) do
		msg.post(k, message_id, message)
	end
end


return M
