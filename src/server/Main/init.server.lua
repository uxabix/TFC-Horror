local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PhysicsService = game:GetService("PhysicsService")
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")

local Events = ReplicatedStorage.Events
local RepStorage = ReplicatedStorage.Storage
local Classes = ReplicatedStorage.Classes

local CookingSurfaceController = require(ServerScriptService.World.CookingSurfaceController)
local FoodSpawner = require(ServerScriptService.World.FoodSpawner)
local TimerClass = require(Classes.Timer)

local RoundStartEvent = Events.RoundStart

local RoundManager = require(script.RoundManager)
local NPCManager = require(script.NPCManager)
local GrabManager = require(script.GrabManager)

Players.PlayerAdded:Connect(function(Player)
	local StartTick, RoundTime--[[, Signal]] = RoundManager.Start()

	if StartTick and RoundTime then
		RoundStartEvent:FireAllClients(StartTick, RoundTime)

		local Timer = TimerClass.new(60)
		Timer:Start()

		task.delay(5, function()
			print(Timer:GetFormatedTime())
		end)

		--[[Начинаем раунд]]

		NPCManager.Spawn()
		GrabManager:Init()
	end

	Player.CharacterAdded:Connect(function(Character) end)
end)

CookingSurfaceController.Init()
