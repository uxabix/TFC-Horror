--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FoodItem = require(ReplicatedStorage.Classes.FoodSystem.FoodItem)
local FoodData = require(ReplicatedStorage.Data.FoodData)

type FoodItem = FoodItem.FoodItem

local FoodManager = {}
FoodManager.__index = FoodManager

FoodManager.FoodDatabase = FoodData

function FoodManager:CreateFood(name: string): FoodItem?
	local data = self.FoodDatabase[name]
	if not data then
		warn("Food not found: " .. name)
		return nil
	end

	return FoodItem.new(name, data.CookTime, data.BurnTime, data.SurfaceType)
end

return FoodManager
