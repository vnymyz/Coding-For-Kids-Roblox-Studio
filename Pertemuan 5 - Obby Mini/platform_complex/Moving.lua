-- MovePlatform
local TweenService = game:GetService("TweenService")
local platform = script.Parent

local speed = 2 -- makin besar makin lambat

-- Posisi awal
local startCF = platform.CFrame

-- Jalur gerak (bisa kamu ubah)
local points = {
	startCF * CFrame.new(0, 10, 0),   -- naik
	startCF * CFrame.new(10, 10, 0),  -- geser kanan
	startCF * CFrame.new(10, 0, 0),   -- turun
	startCF                          -- balik
}

local tweenInfo = TweenInfo.new(
	speed,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

while true do
	for _, targetCF in ipairs(points) do
		local tween = TweenService:Create(
			platform,
			tweenInfo,
			{CFrame = targetCF}
		)
		tween:Play()
		tween.Completed:Wait()
	end
end