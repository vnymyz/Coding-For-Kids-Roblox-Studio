-- Path-based Moving Platform
-- Naik → Kanan → Turun → Balik

local TweenService = game:GetService("TweenService")

local platform = script.Parent
platform.Anchored = true

local startCFrame = platform.CFrame

-- ===== KONFIGURASI =====
local height = 12        -- tinggi naik
local distance = 20      -- jarak kiri / kanan
local moveTime = 2       -- durasi tiap gerakan
local pauseTime = 0.2    -- jeda antar gerakan
-- =======================

local tweenInfo = TweenInfo.new(
	moveTime,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

local function tweenTo(targetCFrame)
	local tween = TweenService:Create(platform, tweenInfo, {
		CFrame = targetCFrame
	})
	tween:Play()
	tween.Completed:Wait()
	task.wait(pauseTime)
end

while true do
	-- 1. NAIK
	tweenTo(startCFrame * CFrame.new(0, height, 0))

	-- 2. KE KANAN (ganti X ke minus kalau mau ke kiri)
	tweenTo(startCFrame * CFrame.new(distance, height, 0))

	-- 3. TURUN
	tweenTo(startCFrame * CFrame.new(distance, 0, 0))

	-- 4. BALIK KE AWAL
	tweenTo(startCFrame)

	task.wait(0.5)
end
