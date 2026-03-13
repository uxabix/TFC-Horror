--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CookingSurfaceManager = require(ReplicatedStorage.Classes.FoodSystem.CookingSystem.CookingSurfaceManager)

local SurfacesFolder = workspace:WaitForChild("CookingSurfaces")

local SurfaceController = {}

-- [Model] = CookingSurface instance
local surfaceMap = {}

function SurfaceController.Init()
	for _, model in ipairs(SurfacesFolder:GetChildren()) do
		local surfaceId = model:GetAttribute("SurfaceId")
		assert(surfaceId, "CookingSurface model missing SurfaceId attribute")

		local surface = CookingSurfaceManager:CreateSurface(surfaceId)
		assert(surface, "Unknown surface id: " .. surfaceId)

		surfaceMap[model] = surface

		SurfaceController.BindPrompt(model, surface)
	end
end

function SurfaceController.BindPrompt(model: Model, surface)
	local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not prompt then
		return
	end

	prompt.Triggered:Connect(function(player)
		-- For now, just print the interaction.
		print(player.Name, "interacted with", surface.SurfaceType)
	end)
end

return SurfaceController
