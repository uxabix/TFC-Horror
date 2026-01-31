local RunService = game:GetService("RunService")

local RoundTime = 15

local RoundManager = {}

--[[
local Signal = require(script.Signal)

InteractSignal = Signal.new()

InteractSignal:Fire()

InteractSignal:Connect(function()
		
end)


]]

--[[Таймер]]
function RoundManager.Start()
	local StartTick = tick()

	local Connection
	Connection = RunService.Heartbeat:Connect(function(Delta)
		if tick() - StartTick >= RoundTime then
			warn("Round end!")
			Connection:Disconnect()
			Connection = nil
		end
	end)

	return StartTick, RoundTime --,InteractSignal
end

return RoundManager
