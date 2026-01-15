local SGui = script.Parent
local groupId = 35628863

local tweenService = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out
)

local settingsMenu = SGui:WaitForChild("SettingsMenu")
local settingsButton = SGui:WaitForChild("Settings").TextButton

local shopMenu = SGui:WaitForChild("ShopMenu")
local shopButton = SGui:WaitForChild("Shop").TextButton

local codesMenu = SGui:WaitForChild("CodesMenu")
local codesButton = SGui:WaitForChild("Codes").TextButton

local musicOnButton  = settingsMenu.Bg.Color.Up.Main.M.Bg.On.TextButton
local musicOffButton = settingsMenu.Bg.Color.Up.Main.M.Bg.Off.TextButton

local soundOnButton  = settingsMenu.Bg.Color.Up.Main.S.Bg.On.TextButton
local soundOffButton = settingsMenu.Bg.Color.Up.Main.S.Bg.Off.TextButton

local player = game.Players.LocalPlayer
local music = player:WaitForChild("Music")
local sound = player:WaitForChild("Sound")

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local REs = replicatedStorage.REs
local CodeRedeem1 = REs.Redeem1
local CodeRedeem2 = REs.Redeem2

local SoundToggleEvent = replicatedStorage:WaitForChild("SoundToggleEvent")

local codes = {"CodeExample1", "CodeExample2"}
local isInGroup = player:IsInGroup(groupId)

local function musicFunction()
	if music.Value == true then
		musicOnButton.Parent.Visible = true
		musicOffButton.Parent.Visible = false
	else
		musicOnButton.Parent.Visible = false
		musicOffButton.Parent.Visible = true
	end
end

local function soundFunction()
	if sound.Value == true then
		soundOnButton.Parent.Visible = true
		soundOffButton.Parent.Visible = false
	else
		soundOnButton.Parent.Visible = false
		soundOffButton.Parent.Visible = true
	end
end

musicFunction()
soundFunction()

music.Changed:Connect(musicFunction)

musicOnButton.MouseButton1Up:Connect(
	function()
		music.Value = false
		musicFunction()
	end
)

musicOffButton.MouseButton1Up:Connect(
	function()
		music.Value = true
		musicFunction()
	end
)

sound.Changed:Connect(soundFunction)

soundOnButton.MouseButton1Up:Connect(function()
	sound.Value = false
	SoundToggleEvent:FireServer(false)
	soundFunction()
end)

soundOffButton.MouseButton1Up:Connect(function()
	sound.Value = true
	SoundToggleEvent:FireServer(true)
	soundFunction()
end)

settingsButton.MouseButton1Up:Connect(function()
	if shopMenu.Visible or codesMenu.Visible then
		shopMenu.Visible = false
		codesMenu.Visible = false
	end
	settingsMenu.Visible = not settingsMenu.Visible
end)

shopButton.MouseButton1Up:Connect(function()
	if settingsMenu.Visible or codesMenu.Visible then
		settingsMenu.Visible = false
		codesMenu.Visible = false
	end
	shopMenu.Visible = not shopMenu.Visible
end)

script.Parent.Money.Plus.TextButton.MouseButton1Up:Connect(function()
	if settingsMenu.Visible or codesMenu.Visible then
		settingsMenu.Visible = false
		codesMenu.Visible = false
	end
	shopMenu.Visible = not shopMenu.Visible
end)

script.Parent.Subsribers.Plus.TextButton.MouseButton1Up:Connect(function()
	if settingsMenu.Visible or codesMenu.Visible then
		settingsMenu.Visible = false
		codesMenu.Visible = false
	end
	shopMenu.Visible = not shopMenu.Visible
end)

codesButton.MouseButton1Up:Connect(function()
	if settingsMenu.Visible or shopMenu.Visible then
		settingsMenu.Visible = false
		shopMenu.Visible = false
	end
	codesMenu.Visible = not codesMenu.Visible
end)


shopMenu.Top.X.TextButton.MouseButton1Up:Connect(function()
	shopMenu.Visible = false
end)

settingsMenu.Bg.X.TextButton.MouseButton1Up:Connect(function()
	settingsMenu.Visible = false
end)

codesMenu.Top.X.TextButton.MouseButton1Up:Connect(function()
	codesMenu.Visible = false
end)

script.Parent.CodesMenu.Top.Up.Codes.Frame.Redeem.TextButton.MouseButton1Up:Connect(function()
    if isInGroup then
		if script.Parent.CodesMenu.Top.Up.Codes.Frame.Box.Bg.Color.TextBox.Text == codes[1] then
			CodeRedeem1:FireServer(player)
		end

		if script.Parent.CodesMenu.Top.Up.Codes.Frame.Box.Bg.Color.TextBox.Text == codes[2] then
			CodeRedeem2:FireServer(player)
		end    
	end
end)

local marketplaceService = game:GetService("MarketplaceService")
local tweenService = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(
	0.1,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)
local gamepassLabel = shopMenu.GamepassLabel
local purchaseLabel = shopMenu.PurchaseLabel
local tween1 = tweenService:Create(gamepassLabel, tweeninfo, {Position = UDim2.new(0.5,0,1.1,0)})
local tween2 = tweenService:Create(purchaseLabel, tweeninfo, {Position = UDim2.new(0.5,0,1.1,0)})

shopMenu.Top.Up.ScrollingFrame.Passes.Money2x.TextButton.MouseButton1Up:Connect(function()
	local hasPass = false
	local moneyPassId = 1091016286
	
	local success, errorMessage = pcall(function()
		hasPass = marketplaceService:UserOwnsGamePassAsync(player.UserId, moneyPassId)
	end)
	
	if success then
		tween1:Play()
		wait(2)
		gamepassLabel.Position = UDim2.new(0.5,0,1.4,0)
	else
		marketplaceService:PromptGamePassPurchase(player, moneyPassId)
	end
end)

shopMenu.Top.Up.ScrollingFrame.Passes.Subs2x.TextButton.MouseButton1Up:Connect(function()
	local hasPass = false
	local subsPassId = 1113273915

	local success, errorMessage = pcall(function()
		hasPass = marketplaceService:UserOwnsGamePassAsync(player.UserId, subsPassId)
	end)

	if success then
		tween1:Play()
		wait(2)
		gamepassLabel.Position = UDim2.new(0.5,0,1.4,0)
	else
		marketplaceService:PromptGamePassPurchase(player, subsPassId)
	end
end)

local money = shopMenu.Top.Up.ScrollingFrame.Money
local subscriber = shopMenu.Top.Up.ScrollingFrame.Subsribers

money.Money1.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245426247)
end)

money.Money2.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245426641)
end)

money.Money3.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245427212)
end)

money.Money4.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245430155)
end)

money.Money5.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245430608)
end)

money.Money6.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245432052)
end)

subscriber.Subscribers1.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3246559877)
end)

subscriber.Subscribers2.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245446670)
end)

subscriber.Subscribers3.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245456491)
end)

subscriber.Subscribers4.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3245456977)
end)

subscriber.Subscribers5.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3246560985)
end)

subscriber.Subscribers6.TextButton.MouseButton1Up:Connect(function()
	marketplaceService:PromptProductPurchase(player, 3246562295)
end)

replicatedStorage.REs.PurchaseSound.OnClientEvent:Connect(function()
	script.Parent.Parent.BuySound:Play()
end)

REs.PurchaseSound.OnClientEvent:Connect(function()
	script.Parent.Parent.BuySound:Play()
	tween2:Play()
	wait(2)
	purchaseLabel.Position = UDim2.new(0.5,0,1.4,0)
end)
