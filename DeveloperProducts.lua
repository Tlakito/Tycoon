local marketplaceService = game:GetService("MarketplaceService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local cash1k = 3245426247
local cash10k = 3245426641
local cash50k = 3245427212
local cash100k = 3245430155
local cash250k = 3245430608
local cash1m = 3245432052

local subs1k = 3246559877
local subs10k = 3245446670
local subs50k = 3245456491
local subs100k = 3245456977
local subs250k = 3246560985
local subs1m = 3246562295

local function processReceipt(receiptInfo)
	
	local player = players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	local leaderstats = player:FindFirstChild("leaderstats")
	
	if player then
		if receiptInfo.ProductId == cash1k then
			if leaderstats and leaderstats:FindFirstChild("Money") then
				leaderstats.Money.Value = leaderstats.Money.Value + 1000
			end
		end
		
		if receiptInfo.ProductId == cash10k then
			if leaderstats and leaderstats:FindFirstChild("Money") then
				leaderstats.Money.Value = leaderstats.Money.Value + 10000
			end
		end
		
		if receiptInfo.ProductId == cash50k then
			if leaderstats and leaderstats:FindFirstChild("Money") then
				leaderstats.Money.Value = leaderstats.Money.Value + 50000
			end
		end
		
		if receiptInfo.ProductId == cash100k then
			if leaderstats and leaderstats:FindFirstChild("Money") then
				leaderstats.Money.Value = leaderstats.Money.Value + 100000
			end
		end
		
		if receiptInfo.ProductId == cash250k then
			if leaderstats and leaderstats:FindFirstChild("Money") then
				leaderstats.Money.Value = leaderstats.Money.Value + 250000
			end
		end
		
		if receiptInfo.ProductId == cash1m then
			if leaderstats and leaderstats:FindFirstChild("Money") then
				leaderstats.Money.Value = leaderstats.Money.Value + 1000000
			end
		end
		
		if receiptInfo.ProductId == subs1k then
			if leaderstats and leaderstats:FindFirstChild("Subscribers") then
				leaderstats.Subscribers.Value = leaderstats.Subscribers.Value + 1000
			end
		end
		
		if receiptInfo.ProductId == subs10k then
			if leaderstats and leaderstats:FindFirstChild("Subscribers") then
				leaderstats.Subscribers.Value = leaderstats.Subscribers.Value + 10000
			end
		end
		
		if receiptInfo.ProductId == subs50k then
			if leaderstats and leaderstats:FindFirstChild("Subscribers") then
				leaderstats.Subscribers.Value = leaderstats.Subscribers.Value + 50000
			end
		end
		
		if receiptInfo.ProductId == subs100k then
			if leaderstats and leaderstats:FindFirstChild("Subscribers") then
				leaderstats.Subscribers.Value = leaderstats.Subscribers.Value + 100000
			end
		end
		
		if receiptInfo.ProductId == subs250k then
			if leaderstats and leaderstats:FindFirstChild("Subscribers") then
				leaderstats.Subscribers.Value = leaderstats.Subscribers.Value + 250000
			end
		end
		
		if receiptInfo.ProductId == subs1m then
			if leaderstats and leaderstats:FindFirstChild("Subscribers") then
				leaderstats.Subscribers.Value = leaderstats.Subscribers.Value + 1000000
			end
		end
	end
	
	replicatedStorage.REs.PurchaseSound:FireClient(player)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

marketplaceService.ProcessReceipt = processReceipt
