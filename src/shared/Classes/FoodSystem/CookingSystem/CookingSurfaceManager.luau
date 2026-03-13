--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CookingSurface = require(ReplicatedStorage.Classes.FoodSystem.CookingSystem.CookingSurface)
local SurfaceData = require(ReplicatedStorage.Data.CookingSurfaceData)
local CookingTypes = require(ReplicatedStorage.Classes.FoodSystem.CookingSystem.CookingTypes)

type CookingSurfaceType = CookingTypes.CookingSurfaceType
type CookingSurface = CookingSurface.CookingSurface

local CookingSurfaceManager = {}
CookingSurfaceManager.__index = CookingSurfaceManager

CookingSurfaceManager.SurfaceDatabase = SurfaceData

function CookingSurfaceManager:CreateSurface(name: string): CookingSurface?
	local data = self.SurfaceDatabase[name]
	if not data then
		warn("Surface not found: " .. name)
		return nil
	end

	return CookingSurface.new(data.SurfaceType, data.SlotsSize)
end

return CookingSurfaceManager
