-- this is on Server Script Service
-- CoinHandler (BEST PRACTICE)
local CollectionService = game:GetService("CollectionService")

local coins = CollectionService:GetTagged("Coin")

for _, coin in ipairs(coins) do
	coin.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid then
			coin:Destroy()
		end
	end)
end

-- kalau coin ditambah saat game jalan
CollectionService:GetInstanceAddedSignal("Coin"):Connect(function(coin)
	coin.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid then
			coin:Destroy()
		end
	end)
end)