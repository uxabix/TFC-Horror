local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local Signal = require(Modules.Signal)

local Template = ReplicatedStorage.Storage.NPCS.Template
local Map = workspace.Map
local NPC_Spawn = Map.NPC_Spawn
local NPC_Waypoints = Map.NPC_Waypoints

local NPCManager = {}

_G.OrderSignal = Signal.new()

local function FollowPath(
	NPC: Model,
	Path: Path,
	Destination: Vector3,
	NextWaypointIndex: number,
	Final: boolean,
	ReachedSignal: typeof(Signal.new())?
)
	local Humanoid: Humanoid = NPC:WaitForChild("Humanoid") :: Humanoid

	local Waypoints = {}
	local YIELDING = true

	local Blocked_Con
	local Reached_Con

	local s, e = pcall(function()
		local primary = NPC.PrimaryPart
		assert(primary, "NPC has no PrimaryPart")
		Path:ComputeAsync(primary.Position, Destination)
	end)

	if s and Path.Status == Enum.PathStatus.Success then
		Waypoints = Path:GetWaypoints()

		Blocked_Con = Path.Blocked:Connect(function(BlockedIndex)
			if BlockedIndex >= NextWaypointIndex then
				Blocked_Con:Disconnect()
				FollowPath(NPC, Path, Destination, NextWaypointIndex, Final, ReachedSignal)
			end
		end)

		if not Reached_Con then
			Reached_Con = Humanoid.MoveToFinished:Connect(function(Reached)
				if Reached and NextWaypointIndex < #Waypoints then
					NextWaypointIndex += 1
					Humanoid:MoveTo(Waypoints[NextWaypointIndex].Position)
				else
					Reached_Con:Disconnect()
					Blocked_Con:Disconnect()

					if ReachedSignal then
						ReachedSignal:Fire()
					end

					if Final == true then
						NPC:Destroy()
						NPCManager.Spawn()
					else
						--NPC:PivotTo(NPC:GetPivot() * CFrame.Angles(0,math.rad(90),0))
						Humanoid.WalkSpeed = 0.1
						Humanoid:MoveTo(NPC:GetPivot().Position + Vector3.new(-10, 0, 0))
						task.delay(1, function()
							Humanoid:MoveTo(NPC:GetPivot().Position)
							Humanoid.WalkSpeed = 16
						end)
					end
				end
			end)
		end

		NextWaypointIndex = 2
		Humanoid:MoveTo(Waypoints[NextWaypointIndex].Position)
	else
		warn("Path not computed!", e)
	end

	return Reached_Con
end

local function ProcessNPC(NPC: Model)
	local Path = PathfindingService:CreatePath({

		AgentCanClimb = false,
		AgentRadius = 2,
		Costs = {
			Concrete = 0,
		},
	})

	local ReachedSignal = Signal.new()

	FollowPath(NPC, Path, NPC_Waypoints.Order.Position, 1, false, ReachedSignal)

	ReachedSignal:Once(function()
		_G.OrderSignal:Once(function()
			FollowPath(NPC, Path, NPC_Waypoints.Final.Position, 1, true)

			ReachedSignal:DisconnectAll()
			ReachedSignal = nil

			Path:Destroy()
		end)
	end)
end

function NPCManager.Spawn()
	local NPC = Template:Clone()
	NPC.Parent = workspace

	NPC.PrimaryPart:SetNetworkOwner(nil)

	local Spawns = NPC_Spawn:GetChildren()
	NPC:PivotTo(Spawns[Random.new():NextInteger(1, #Spawns)].CFrame)

	ProcessNPC(NPC)
end

return NPCManager
