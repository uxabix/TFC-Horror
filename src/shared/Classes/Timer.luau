--!strict
--!native

local RunService = game:GetService("RunService")

local Timer = {}

local DEBUG = false

local function debugPrint(...)
	if DEBUG and RunService:IsStudio() then
		print("[Timer]", ...)
	end
end

type TimerClassImpl<T> = {
	Start: (self: T) -> (),
	Stop: (self: T) -> (),
	Reset: (self: T) -> (),
	Destroy: (self: T) -> (),
	GetRemainingTime: (self: T) -> number,
	GetFormatedTime: (self: T) -> string,
}

export type TimerClass = {
	Duration: number,
	TimeLeft: number,

	Running: boolean,

	OnTick: BindableEvent,
	OnFinished: BindableEvent,

	_startTime: number,
	_endTime: number,
} & TimerClassImpl<TimerClass>

local __class = {} :: TimerClass
do
	function __class:Start(): ()
		if self.Running then
			return
		end
		self.Running = true

		self._startTime = os.clock()
		self._endTime = self._startTime + self.TimeLeft

		task.spawn(function()
			while self.Running do
				local now = os.clock()
				self.TimeLeft = math.max(0, math.ceil(self._endTime - now))

				self.OnTick:Fire(self.TimeLeft)

				if self.TimeLeft <= 0 then
					self.Running = false
					self.OnFinished:Fire()
					break
				end

				task.wait(0.1)
			end
		end)
	end

	function __class:Stop(): ()
		self.Running = false
	end

	function __class:Reset(): ()
		self:Stop()
		self.TimeLeft = self.Duration
	end

	function __class:Destroy(): ()
		self:Stop()
		self.OnTick:Destroy()
		self.OnFinished:Destroy()
	end

	function __class:GetRemainingTime(): number
		return self.TimeLeft
	end

	function __class:GetFormatedTime(): string
		return ("%02i:%02i:%02i"):format(
			math.floor(self.TimeLeft / 60 ^ 2 % 24),
			math.floor(self.TimeLeft / 60 % 60),
			math.floor(self.TimeLeft % 60)
		)
	end

	table.freeze(__class)
end

local __meta: { __index: TimerClass } = table.freeze({ __index = __class })

function Timer.new(duration: number): TimerClass
	local self = (setmetatable({}, __meta) :: any) :: TimerClass

	self.Duration = duration
	self.TimeLeft = duration
	self.Running = false

	self.OnTick = Instance.new("BindableEvent")
	self.OnFinished = Instance.new("BindableEvent")

	debugPrint("RS.Classes.Timer: New Timer created:", self)

	return self
end

return table.freeze(Timer)
