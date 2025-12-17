-- Script Elevator / Platform Bergerak

local TweenService = game:GetService("TweenService")
local elevator = script.Parent

-- pengaturan waktu animasi
local tweenInfo = TweenInfo.new(
	2, -- waktu 2 detik
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

-- posisi awal (bawah)
local bottomCFrame = elevator.CFrame

-- posisi tujuan (naik 10 stud)
local topCFrame = bottomCFrame * CFrame.new(0, 10, 0)

local isUp = false      -- apakah elevator sedang di atas?
local isBusy = false   -- supaya tidak ditekan berkali-kali

-- fungsi untuk gerakkan elevator
local function moveElevator()
	if isBusy then return end
	isBusy = true

	if not isUp then
		local tweenUp = TweenService:Create(
			elevator,
			tweenInfo,
			{CFrame = topCFrame}
		)
		tweenUp:Play()
		tweenUp.Completed:Wait()
		isUp = true
	else
		local tweenDown = TweenService:Create(
			elevator,
			tweenInfo,
			{CFrame = bottomCFrame}
		)
		tweenDown:Play()
		tweenDown.Completed:Wait()
		isUp = false
	end

	isBusy = false
end

-- gerak otomatis setiap 3 detik
while true do
	wait(3)
	moveElevator()
end
