local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events

local StopGrabRE = Events.StopGrab
local CanGrabRF = Events.CanGrab

local Grab = {}

local function CanGrab(Player: Player, Prop: BasePart | MeshPart)
	if Player and Prop then
		local Character = Player.Character
		local RootPart = Character.HumanoidRootPart
		if Prop:IsDescendantOf(workspace.Map.FoodTrays) then
			local Distance = (RootPart.Position - Prop.Position).Magnitude
			if Distance < 10 then
				for Index, _Instance in Prop.Parent:GetDescendants() do
					if _Instance:IsA("BasePart") or _Instance:IsA("MeshPart") then
						_Instance:SetNetworkOwner(Player)
						_Instance.Massless = true
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
	return false, "IDK lol."
end

local function StopGrab(Player: Player, Prop: BasePart | MeshPart)
	if Prop then
		for Index, _Instance in Prop.Parent:GetDescendants() do
			if _Instance:IsA("BasePart") or _Instance:IsA("MeshPart") then
				--_Instance:SetNetworkOwner(nil)
				_Instance:SetNetworkOwnershipAuto()
				_Instance.Massless = false
			end
		end
	end
end

function Grab:Init()
	CanGrabRF.OnServerInvoke = CanGrab
	StopGrabRE.OnServerEvent:Connect(StopGrab)
end

return Grab
