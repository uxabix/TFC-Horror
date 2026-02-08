--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FoodManager = require(ReplicatedStorage.Classes.FoodSystem.FoodManager)

local FoodAssets = ReplicatedStorage.Models.Food
local FoodFolder = workspace:WaitForChild("Foods")

local FoodSpawner = {}

-- [FoodItem] = Model
local foodToModel = {}

function FoodSpawner.Spawn(foodName: string, position: Vector3)
	local foodItem = FoodManager:CreateFood(foodName)
	if not foodItem then
		return
	end

	local template = FoodAssets:FindFirstChild(foodName)
	assert(template, "Missing food model: " .. foodName)

	local model = template:Clone()
	model:SetPrimaryPartCFrame(CFrame.new(position))
	model.Parent = FoodFolder

	foodToModel[foodItem] = model

	return foodItem
end

function FoodSpawner.GetModel(foodItem)
	return foodToModel[foodItem]
end

return FoodSpawner
