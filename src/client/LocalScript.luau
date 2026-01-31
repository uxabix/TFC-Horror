--!strict

local ProxPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService: TweenService = game:GetService("TweenService")

local POP_UP_OUT_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0)

local HOLDER_SIZE = UDim2.new(3, 0, 1, 0)
local HOLDER_ANIM_SIZE = UDim2.new(0, 0, 1, 0)

local function Tween(Object: Instance, Info: TweenInfo, Properties: { [string]: any })
	local Tween = TweenService:Create(Object, Info, Properties)

	return Tween
end

local Template: BillboardGui = script.Template

local SetupTemplate = function(Prompt: ProximityPrompt)
	local CustomPrompt = Template:Clone()
	CustomPrompt.Size = HOLDER_ANIM_SIZE
	CustomPrompt.Parent = Prompt.Parent
	CustomPrompt.Adornee = Prompt.Parent
	CustomPrompt.Enabled = true
	CustomPrompt.Holder.KeyCode.Text = tostring(Prompt.KeyboardKeyCode.Name)
	CustomPrompt.Holder.ActionText.Text = Prompt.ActionText
	CustomPrompt.Holder.ObjectText.Text = Prompt.ObjectText

	return CustomPrompt
end

ProxPromptService.PromptShown:Connect(function(Prompt: ProximityPrompt)
	if Prompt.Style == Enum.ProximityPromptStyle.Default then
		return
	end

	local Holder = SetupTemplate(Prompt)
	local PopUpTween: Tween = Tween(Holder, POP_UP_OUT_INFO, { Size = HOLDER_SIZE })
	PopUpTween:Play()

	--local ActionText: TextLabel = CustomPrompt.ActionText

	Prompt.PromptHidden:Connect(function()
		local PopDownTween: Tween = Tween(Holder, POP_UP_OUT_INFO, { Size = HOLDER_ANIM_SIZE })
		PopDownTween:Play()

		PopDownTween.Completed:Connect(function()
			Holder:Destroy()
		end)
	end)
end)
