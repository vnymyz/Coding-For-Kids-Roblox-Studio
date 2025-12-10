-- Script pintu berputar seperti pintu rumah

local door = script.Parent                 -- ini adalah pintu
local prompt = door:WaitForChild("ProximityPrompt") 
-- tombol "E" dekat pintu
local hinge = workspace:WaitForChild("Hinge")
-- engsel pintu (tempat pintu berputar)
local TweenService = game:GetService("TweenService") 
-- untuk bikin gerakan halus

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
-- durasi buka pintu = 0.5 detik

local openAngle = 90                       -- pintu dibuka 90 derajat
local isBusy = false                       -- supaya pintu tidak disuruh buka berkali-kali
local isOpen = false                       -- apakah pintu sedang terbuka?

-- offset = posisi pintu relatif terhadap engsel
-- ini supaya pintu mutarnya rapi dan tidak "loncat"
local offset = hinge.CFrame:ToObjectSpace(door.CFrame)

-- fungsi untuk memutar pintu ke sudut tertentu
local function setToAngle(angle)
	-- angle adalah angka derajat bukaannya
	local targetCFrame = hinge.CFrame * CFrame.Angles(0, math.rad(angle), 0) * offset
	-- hitung posisi pintu setelah diputar
	local tween = TweenService:Create(door, tweenInfo, {CFrame = targetCFrame})
	-- bikin animasi pintu berputar
	tween:Play()                           -- jalankan animasi
	tween.Completed:Wait()                 -- tunggu sampai animasi selesai
end

-- fungsi untuk buka / tutup pintu (toggle)
local function toggle()
	if isBusy then return end              -- kalau lagi sibuk, jangan buka lagi
	isBusy = true

	if not isOpen then                     -- kalau pintu masih tertutup...
		setToAngle(openAngle)              -- buka pintu
		isOpen = true
	else                                   -- kalau pintu sudah terbuka...
		setToAngle(0)                      -- tutup pintu
		isOpen = false
	end

	isBusy = false
end

-- saat pemain menekan tombol E → jalankan toggle()
prompt.Triggered:Connect(function(player)
	toggle()
end)

-- Slide door (move sideways) - Server Script in Door
--local door = script.Parent
--local prompt = door:WaitForChild("ProximityPrompt")
--local TweenService = game:GetService("TweenService")

--local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
--local slideDistance = 4 -- berapa stud pintu bergeser
--local isBusy = false
--local isOpen = false

---- hitung posisi close dan open
--local closeCFrame = door.CFrame
---- arah geser: pakai RightVector lokal (ubah jadi ForwardVector atau Left jika perlu)
--local openCFrame = closeCFrame * CFrame.new(door.CFrame.RightVector * slideDistance)

--local function toggle()
--	if isBusy then return end
--	isBusy = true
--	if not isOpen then
--		local t = TweenService:Create(door, tweenInfo, {CFrame = openCFrame})
--		t:Play()
--		t.Completed:Wait()
--		isOpen = true
--	else
--		local t = TweenService:Create(door, tweenInfo, {CFrame = closeCFrame})
--		t:Play()
--		t.Completed:Wait()
--		isOpen = false
--	end
--	isBusy = false
--end

--prompt.Triggered:Connect(function(player)
--	toggle()
--end)
