--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FoodItemModule = require(ReplicatedStorage.Classes.FoodItem)
local CookingTypes = require(ReplicatedStorage.Classes.CookingTypes)

type FoodItem = FoodItemModule.FoodItem
type CookingSurfaceType = CookingTypes.CookingSurfaceType

export type CookingSurface = {
	SurfaceType: CookingSurfaceType,
	SlotsSize: number,
	Slots: { FoodItem },

	AddFood: (self: CookingSurface, foodItem: FoodItem, timer: any) -> (boolean, string?),
	RemoveFood: (self: CookingSurface, foodItem: FoodItem) -> FoodItem?,
}

local CookingSurface = {}
CookingSurface.__index = CookingSurface

function CookingSurface.new(surfaceType: CookingSurfaceType, slotsSize: number): CookingSurface
	local self = (setmetatable({}, CookingSurface) :: any) :: CookingSurface

	self.SurfaceType = surfaceType
	self.SlotsSize = slotsSize
	self.Slots = {}

	return self
end

function CookingSurface:AddFood(foodItem: FoodItem, timer: any): (boolean, string?)
	if foodItem.SurfaceType ~= self.SurfaceType then
		return false, "INVALID_SURFACE"
	end

	if #self.Slots >= self.SlotsSize then
		return false, "NO_FREE_SLOTS"
	end

	table.insert(self.Slots, foodItem)
	foodItem:StartCooking(timer)

	return true
end

function CookingSurface:RemoveFood(foodItem: FoodItem): FoodItem?
	for i, item in ipairs(self.Slots) do
		if item == foodItem then
			table.remove(self.Slots, i)
			return item
		end
	end
	return nil
end

return CookingSurface
