local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local purchasableTemplate = {}
local templateFolder = ServerStorage:WaitForChild("TycoonItems")
for _, obj in pairs(templateFolder:GetChildren()) do
	purchasableTemplate[obj.Name] = obj
end

local function claimTycoon(tycoon)
	local owner = tycoon:FindFirstChild("Owner")
	if not owner then return end
	local door = owner:FindFirstChild("OwnerDoor")
	if not door then return end

	door.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if player and tycoon:FindFirstChild("OwnerValue") and tycoon.OwnerValue.Value == nil then
			local hasTycoon = player:FindFirstChild("HasTycoon")
			if hasTycoon and hasTycoon.Value == false then
				tycoon.OwnerValue.Value = player
				if player:FindFirstChild("TycoonOwned") then
					player.TycoonOwned.Value = tycoon
				end
				hasTycoon.Value = true
				for _, v in pairs(tycoon.Owner:GetChildren()) do
					if v:IsA("BasePart") then
						v.Transparency = 1
						v.CanCollide = false
					end
				end
				print("[Tycoon] "..player.Name.." claimed "..tycoon.Name)
			end
		end
	end)
end

local function setupTycoon(tycoon)
	if not tycoon or not tycoon:IsA("Model") then return end
	local buttons = tycoon:FindFirstChild("Buttons")
	local purchasedItems = tycoon:FindFirstChild("Purchasable Items")
	if not buttons or not purchasedItems or not tycoon:FindFirstChild("OwnerValue") then return end

	for _, v in pairs(buttons:GetChildren()) do
		task.spawn(function()
			if not v:FindFirstChild("Button") or not v:FindFirstChild("Object") or not v:FindFirstChild("Price") then return end

			local buttonPart = v.Button
			local objectName = v.Object.Value
			local price = v.Price.Value
			local buttonDesign = v:FindFirstChild("ButtonDesign") and v.ButtonDesign:GetChildren() or {}

			local function setButtonVisible(visible)
				buttonPart.Transparency = visible and 0 or 1
				buttonPart.CanCollide = visible
				if buttonPart:FindFirstChild("BillboardGui") then
					buttonPart.BillboardGui.Enabled = visible
				end
				for _, part in pairs(buttonDesign) do
					if part:IsA("BasePart") then
						part.Transparency = visible and 0 or 1
					end
				end
			end

			local hasDep = v:FindFirstChild("Dependency")
			if hasDep then
				setButtonVisible(false)
				task.spawn(function()
					purchasedItems:WaitForChild(v.Dependency.Value)
					if v:FindFirstChild("Dependency1") then purchasedItems:WaitForChild(v.Dependency1.Value) end
					if v:FindFirstChild("Dependency2") then purchasedItems:WaitForChild(v.Dependency2.Value) end
					setButtonVisible(true)
				end)
			else
				setButtonVisible(true)
			end

			local debounce = false
			buttonPart.Touched:Connect(function(hit)
				if debounce then return end
				debounce = true

				local player = Players:GetPlayerFromCharacter(hit.Parent)
				if not player then debounce = false return end
				if tycoon.OwnerValue.Value ~= player then debounce = false return end
				if not buttonPart.CanCollide then debounce = false return end

				local leaderstats = player:FindFirstChild("leaderstats")
				if not leaderstats then debounce = false return end
				local money = leaderstats:FindFirstChild("Money")
				if not money or money.Value < price then debounce = false return end

				money.Value -= price
				
				local objectTemplate = purchasableTemplate[objectName]
				if not objectTemplate then
					warn("⚠️ Could not find object in ServerStorage:", objectName)
					debounce = false
					return
				end

				local clone = objectTemplate:Clone()
				clone.Parent = purchasedItems

				v:Destroy()

				debounce = false
			end)
		end)
	end
end

Players.PlayerRemoving:Connect(function(player)
	local tycoon = player:FindFirstChild("TycoonOwned") and player.TycoonOwned.Value
	if tycoon and tycoon.Parent then
		local tycoonCFrame = tycoon.PrimaryPart and tycoon.PrimaryPart.CFrame
		tycoon:Destroy()

		local template = ServerStorage:FindFirstChild("Tycoon#1")
		if not template then
			warn("Tycoon template not found in ServerStorage")
			return
		end

		local newTycoon = template:Clone()
		newTycoon.Parent = workspace
		if newTycoon.PrimaryPart and tycoonCFrame then
			newTycoon:SetPrimaryPartCFrame(tycoonCFrame)
		end

		claimTycoon(newTycoon)
		setupTycoon(newTycoon)
	end
end)

for _, t in pairs(workspace:GetChildren()) do
	if t:IsA("Model") and t:FindFirstChild("Buttons") and t:FindFirstChild("Purchasable Items") then
		claimTycoon(t)
		setupTycoon(t)
	end
end
