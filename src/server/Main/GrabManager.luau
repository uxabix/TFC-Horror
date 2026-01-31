local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events

local StopGrabRE = Events.StopGrab
local CanGrabRF = Events.CanGrab

local Grab = {}

local function CanGrab(Player: Player, Prop: BasePart | MeshPart)
	if not Player or not Prop then
		return false, "Invalid player or prop."
	end

	local Character = Player.Character
	if not Character then
		return false, "Player has no character."
	end

	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	if not RootPart or not RootPart:IsA("BasePart") then
		return false, "No HumanoidRootPart."
	end

	local MapFolder = workspace:FindFirstChild("Map")
	if not MapFolder then
		return false, "No Map found."
	end

	local FoodTrays = MapFolder:FindFirstChild("FoodTrays")
	if not FoodTrays then
		return false, "No FoodTrays found."
	end

	if Prop:IsDescendantOf(FoodTrays) then
		local Distance = (RootPart.Position - Prop.Position).Magnitude
		if Distance < 10 then
			local parent = Prop.Parent
			assert(parent, "Prop has no parent.")
			for _, Descendant in ipairs(parent:GetDescendants()) do
				if Descendant:IsA("BasePart") or Descendant:IsA("MeshPart") then
					Descendant:SetNetworkOwner(Player)
					Descendant.Massless = true
				end
			end
			return true
		else
			return false, "Too far away."
		end
	else
		return false, "Not a prop."
	end
end

local function StopGrab(Player: Player, Prop: BasePart | MeshPart)
	if not Prop then
		return
	end

	local parent = Prop.Parent
	assert(parent, "Prop has no parent.")
	for _, Descendant in ipairs(parent:GetDescendants()) do
		if Descendant:IsA("BasePart") or Descendant:IsA("MeshPart") then
			Descendant:SetNetworkOwnershipAuto()
			Descendant.Massless = false
		end
	end
end

function Grab:Init()
	CanGrabRF.OnServerInvoke = CanGrab
	StopGrabRE.OnServerEvent:Connect(StopGrab)
end

return Grab
