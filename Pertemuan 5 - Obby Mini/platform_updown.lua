local TweenService = game:GetService("TweenService")
local platform = script.Parent

local startPos = platform.Position
local endPos = startPos + Vector3.new(0, 10, 0)

local info = TweenInfo.new(
	2,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

local tween = TweenService:Create(
	platform,
	info,
	{Position = endPos}
)

tween:Play()