local TweenService = game:GetService("TweenService")
local lift = script.Parent
local prompt = lift.ProximityPrompt

local up = lift.Position + Vector3.new(0, 12, 0)
local down = lift.Position

local isUp = false

prompt.Triggered:Connect(function()
	local target = isUp and down or up
	isUp = not isUp

	local tween = TweenService:Create(
		lift,
		TweenInfo.new(2),
		{Position = target}
	)
	tween:Play()
end)