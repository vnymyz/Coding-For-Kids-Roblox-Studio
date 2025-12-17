-- Hybrid Platform Carry System
-- Firmly keeps character on platform when standing, allows free movement when moving

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local platform = script.Parent
local lastCFrame = platform.CFrame
local platformSize = platform.Size

-- Track characters and their movement state
local charactersOnPlatform = {}
local lastUpdateTime = tick()

local function isStandingOnPlatform(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	-- Check if character is within platform bounds
	local platformPos = platform.Position
	local charPos = root.Position

	-- Horizontal distance check
	local horizontalDist = Vector2.new(charPos.X - platformPos.X, charPos.Z - platformPos.Z).Magnitude
	if horizontalDist > math.max(platformSize.X, platformSize.Z) / 2 + 1 then
		return false
	end

	-- Vertical distance check
	local verticalDist = math.abs(charPos.Y - (platformPos.Y + platformSize.Y / 2))
	if verticalDist > 3 then
		return false
	end

	-- Raycast to confirm standing on platform
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(
		root.Position,
		Vector3.new(0, -5, 0),
		params
	)

	return result and result.Instance == platform
end

local function isPlayerMoving(character, humanoid)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	-- Check if humanoid is actively moving
	if humanoid.MoveDirection.Magnitude > 0.1 then
		return true
	end

	-- Check if character has significant velocity
	local velocity = root.AssemblyLinearVelocity
	local horizontalVelocity = Vector2.new(velocity.X, velocity.Z).Magnitude
	if horizontalVelocity > 2 then
		return true
	end

	-- Check if jumping
	if humanoid:GetState() == Enum.HumanoidStateType.Jumping or
		humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		return true
	end

	return false
end

local function getCharacterKey(character)
	local player = Players:GetPlayerFromCharacter(character)
	return player and player.UserId or character:GetFullName()
end

RunService.Heartbeat:Connect(function()
	local currentTime = tick()
	local currentCFrame = platform.CFrame
	local deltaTime = currentTime - lastUpdateTime

	-- Only process if platform moved
	if (currentCFrame.Position - lastCFrame.Position).Magnitude > 0.001 then
		local delta = currentCFrame * lastCFrame:Inverse()

		-- Check all players
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character
			local humanoid = character and character:FindFirstChild("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")

			if humanoid and root and humanoid.Health > 0 then
				local key = getCharacterKey(character)
				local isOnPlatform = isStandingOnPlatform(character)

				if isOnPlatform then
					-- Initialize tracking if new
					if not charactersOnPlatform[key] then
						charactersOnPlatform[key] = {
							character = character,
							relativeCFrame = currentCFrame:Inverse() * root.CFrame,
							lastCheck = currentTime,
							wasMoving = false
						}
					end

					local data = charactersOnPlatform[key]
					if data then
						local isMoving = isPlayerMoving(character, humanoid)

						if not isMoving then
							-- Player is standing still - firmly attach to platform
							local targetCFrame = currentCFrame * data.relativeCFrame
							root.CFrame = targetCFrame

							-- Reset velocity to prevent sliding
							root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

							data.wasMoving = false
						else
							-- Player is moving - apply gentle platform influence
							if not data.wasMoving then
								-- Just started moving - update relative position
								data.relativeCFrame = currentCFrame:Inverse() * root.CFrame
							end

							-- Calculate platform velocity and apply it gently
							local platformVelocity = (currentCFrame.Position - lastCFrame.Position) / deltaTime
							local currentVelocity = root.AssemblyLinearVelocity

							-- Blend platform movement with player movement
							local blendedVelocity = Vector3.new(
								currentVelocity.X + platformVelocity.X * 0.3,
								currentVelocity.Y,
								currentVelocity.Z + platformVelocity.Z * 0.3
							)

							root.AssemblyLinearVelocity = blendedVelocity
							data.wasMoving = true
						end

						data.lastCheck = currentTime
					end
				else
					-- Remove from tracking if not on platform
					if charactersOnPlatform[key] then
						charactersOnPlatform[key] = nil
					end
				end
			end
		end
	end

	-- Clean up old entries
	for key, data in pairs(charactersOnPlatform) do
		if currentTime - data.lastCheck > 2 then
			charactersOnPlatform[key] = nil
		end
	end

	lastCFrame = currentCFrame
	lastUpdateTime = currentTime
end)

-- Handle character removal
Players.PlayerRemoving:Connect(function(player)
	if player.Character then
		local key = getCharacterKey(player.Character)
		if key then
			charactersOnPlatform[key] = nil
		end
	end
end)