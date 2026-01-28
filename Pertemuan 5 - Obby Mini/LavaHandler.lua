-- LavaHandler (Global Lava System)
local CollectionService = game:GetService("CollectionService")

-- fungsi saat karakter menyentuh lava
local function onTouched(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid then
		humanoid.Health = 0
	end
end

-- pasang ke semua lava yang SUDAH ADA
for _, lava in ipairs(CollectionService:GetTagged("Lava")) do
	lava.Touched:Connect(onTouched)
end

-- pasang ke lava yang DITAMBAH BELAKANGAN
CollectionService:GetInstanceAddedSignal("Lava"):Connect(function(lava)
	lava.Touched:Connect(onTouched)
end)