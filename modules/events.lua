local TSM4_PC = select(2, ...)
--local L = LibStub("AceLocale-3.0"):GetLocale("TSM4_PriceCheck")
local L = LibStub("AceLocale-3.0"):NewLocale("TSM_PriceCheck", "enUS", true)

local Events = TSM4_PC:NewModule("Events", "AceEvent-3.0")
local Util = TSM4_PC:GetModule("Utils")

function Util:Process(message, recipient, channel)
	if TSM4_PC.db.global["AddonEnabled"] == false then return end
	
	local AddonEnabled = TSM4_PC.db.global["AddonEnabled"] --- check it
	local GuildChannel = TSM4_PC.db.global["GuildChannel"] --- Only used for guild channel
	message = string.lower(message)

	if Util:StartsWith(message, TSM4_PC.db.global["Trigger"]) == false then
		return
	end

	--- Price Get --
	local itemString  = Util:TrimString(string.sub(message, TSM4_PC.db.global["TriggerLength"]+1)) -- sub the item
	local itemCountIndex, endPos, itemCount, restOfString = string.find(itemString, '(%d+)')

	if itemCount == nil or itemCountIndex > 1 then
		itemCount = 1
	else
		itemCount = tonumber(itemCount)
		if itemCount < 1 then
			itemCount = 1
		end
	end

	local itemID  = TSM_API.ToItemString(itemString)

	local priceMarket = TSM_API.GetCustomPriceValue(TSM4_PC.db.global["MarketSource"], itemID)
	local priceMin = TSM_API.GetCustomPriceValue(TSM4_PC.db.global["MinBuyoutSource"], itemID)
	local priceRegion = TSM_API.GetCustomPriceValue(TSM4_PC.db.global["Region"], itemID)

	if priceMarket == nil then
		priceMarket = TSM_API.GetCustomPriceValue(TSM4_PC.db.global["MarketSource"], itemID)
	end
	if priceMin == nil then
		priceMin = TSM_API.GetCustomPriceValue(TSM4_PC.db.global["MinBuyoutSource"], itemID)
	end
	if priceRegion == nil then
		priceRegion = TSM_API.GetCustomPriceValue(TSM4_PC.db.global["Region"], itemID)
	end

	if itemID == nil then
		return
	end

	-----------------------------------------------------------------

	if priceMarket == nil and priceMin == nil and priceRegion == nil then
		Util:SendMessage("I have not yet seen that item, sorry!", recipient, channel)
		return
	end

	if Util:LastRunCheck() == "Yes" then
		if priceRegion ~= nil then
			Util:SendMessage(Util:ValuesFor(priceRegion, TSM4_PC.db.global["RegionalText"], itemCount), recipient, channel)
		end

		if priceMarket ~= nil then
			Util:SendMessage(Util:ValuesFor(priceMarket, TSM4_PC.db.global["MarketText"], itemCount), recipient, channel)
		end

		if priceMin ~= nil then
			Util:SendMessage(Util:ValuesFor(priceMin, TSM4_PC.db.global["MinText"], itemCount), recipient, channel)
		end

		TSM4_PC.LastRunDelayTime = time()
	else
		return
	end
end