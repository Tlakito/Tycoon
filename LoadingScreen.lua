local ContentProvider = game:GetService("ContentProvider")
local holder = script.Parent.Holder
local assets = game.Workspace:GetDescendants()

local ScreenGui = script.Parent.Parent.ScreenGui
ScreenGui.Enabled = false

game.ReplicatedFirst:RemoveDefaultLoadingScreen()

local skipped = false

holder.SkipFrame.MouseButton1Up:Connect(function()
	skipped = true
	holder:TweenPosition(UDim2.fromScale(0.5, -1.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1)
	ScreenGui.Enabled = true
	local loadingFinishedEvent = game:GetService("ReplicatedStorage"):WaitForChild("LoadingFinished")
	loadingFinishedEvent:Fire()
	script.Parent.LoadingScreenScript.Enabled = false
end)

local function start()
	for i = 1, #assets do
		ContentProvider:PreloadAsync({assets[i]})
		local percentage = math.floor(i / #assets * 100)

		holder.BarFrame.Assets.Text = "Assets Loaded: " .. i .. "/" .. #assets
		holder.BarFrame.Percentage.Text = percentage .. "%"
		holder.BarFrame.Frame.Bar:TweenSize(UDim2.fromScale(percentage / 100, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
	end

	wait(1)
	holder:TweenPosition(UDim2.fromScale(0.5, -1.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1)
	ScreenGui.Enabled = true
	local loadingFinishedEvent = game:GetService("ReplicatedStorage"):WaitForChild("LoadingFinished")
	loadingFinishedEvent:Fire()
end

local player = game.Players.LocalPlayer
local alreadyLoadedFlag = player:FindFirstChild("LoadingScreenShown")

if alreadyLoadedFlag and alreadyLoadedFlag.Value == true then
	script.Parent:Destroy()
	return
end

if not alreadyLoadedFlag then
	alreadyLoadedFlag = Instance.new("BoolValue")
	alreadyLoadedFlag.Name = "LoadingScreenShown"
	alreadyLoadedFlag.Value = true
	alreadyLoadedFlag.Parent = player
end


start()
