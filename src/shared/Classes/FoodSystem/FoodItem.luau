--!strict

-- UNFINISEHED: FoodItem class to represent food items and their cooking states
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CookingTypes = require(ReplicatedStorage.Classes.FoodSystem.CookingSystem.CookingTypes)

type CookingSurfaceType = CookingTypes.CookingSurfaceType
type FoodState = CookingTypes.FoodState

export type FoodItem = {
	Name: string,
	SurfaceType: CookingSurfaceType,
	State: FoodState,

	StartCooking: (self: FoodItem, timer: any) -> (),
}

type FoodItemImpl = FoodItem & {
	CookTime: number,
	BurnTime: number,
	CookStage: number,
}

local FoodItem = {}
FoodItem.__index = FoodItem

function FoodItem.new(name: string, cookTime: number, burnTime: number, surfaceType: CookingSurfaceType): FoodItem
	local self = (setmetatable({}, FoodItem) :: any) :: FoodItemImpl
	self.Name = name
	self.CookTime = cookTime -- seconds to Cooked
	self.BurnTime = burnTime -- seconds to Burned after Cooked
	self.SurfaceType = surfaceType -- CookingSurfaceType
	self.State = "Raw" -- Raw, Cooking, Cooked, Burned
	self.CookStage = 0 -- UNUSED FOR NOW: For food that may have multiple cooking stages (optional)

	return self
end

function FoodItem:StartCooking(timer)
	self.State = "Cooking"
	-- REPLACE WITH ACTUAL TIMER IMPLEMENTATION
	timer:Start(self.CookTime, function()
		self:OnCooked(timer)
	end)
end

function FoodItem:OnCooked(timer)
	self.State = "Cooked"
	-- REPLACE WITH ACTUAL TIMER IMPLEMENTATION
	timer:Start(self.BurnTime, function()
		self:OnBurned()
	end)
end

function FoodItem:OnBurned()
	self.State = "Burned"
end

return FoodItem
