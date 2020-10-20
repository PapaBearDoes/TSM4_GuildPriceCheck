local TSM4_PC = select(2, ...)
--local L = LibStub("AceLocale-3.0"):GetLocale("TSM4_PriceCheck")
local L = LibStub("AceLocale-3.0"):NewLocale("TSM_PriceCheck", "enUS", true)

local Util = TSM4_PC:NewModule("Utils")

function Util:ConvertPriceToMoney(price, currency)
	local amount
	if price == nil then price = 0 end -- make sure it is a number
	if currency == "Raw" then
		amount = price
		return amount
	elseif currency == "Gold" then
		amount = floor(price/10000) -- divide price by 10000 to decide gold and floor it to get rid of hang overs
		return amount or 0 -- Make sure it always returns a number
	elseif currency == "Silver" then
		amount = floor(strsub(price, -4)/100) -- strsub will only see the last 4 numbers of a sentece and divide it by 100
		if string.len(amount) < 2  then amount = "0"..floor(strsub(price, -4)/100) end
		return amount
	elseif currency == "Copper" then
		amount = floor(strsub(price, -2)) -- no division needed for 10th's
		return amount or 0
	end
end

function Util:ConvertTime(Current, Past)
	local Current = Current
	local Past = Past
	local Difference = (Current - Past)
	return Difference
end

function Util:LastRunCheck()
	local Current = time()
	local Past = (TSM4_PC.LastRunDelayTime + TSM4_PC.db.global["LockOutTime"])
	if Current > Past then
		return "Yes"
	else
		return "No"
	end
end

function Util:TrimString(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function Util:StartsWith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function TSM4_PC:TriggeredEvent(message, recipient, channel)
	Util:Process(message, recipient, channel)
end

function Util:ValuesFor(marketPrice, marketName, itemCount)
	-- Market Prices --
	local marketRaw = Util:ConvertPriceToMoney(marketPrice,"Raw")
	local marketGold = Util:ConvertPriceToMoney(marketPrice,"Gold")
	local marketSilver = Util:ConvertPriceToMoney(marketPrice,"Silver")
	local marketCopper  = Util:ConvertPriceToMoney(marketPrice,"Copper")
	local multipliedMarketGold = Util:ConvertPriceToMoney(marketPrice*itemCount,"Gold")
	local multipliedMarketSilver = Util:ConvertPriceToMoney(marketPrice*itemCount,"Silver")
	local multipliedMarketCopper = Util:ConvertPriceToMoney(marketPrice*itemCount,"Copper")

	local icon = "g"
	local leftBracket = "["
	local rightBracket = "]"
	local gold = ","
	local copper = ""

	if TSM4_PC.db.global["UseRaidIcon"] then
		icon = "g{rt2}"
	end

	if not TSM4_PC.db.global["ShowBrackets"] then
		leftBracket = ": "
		rightBracket = ""
	end

	if TSM4_PC.db.global["ShowCopper"] then
		if itemCount > 1 then
			copper = multipliedMarketCopper
		else
			copper = marketCopper
		end

		gold = "g"

		if TSM4_PC.db.global["UseRaidIcon"] then
			icon = "c{rt2}"
		else
			icon = "c"
		end
	end

	if itemCount > 1 then
		message = marketName.." x"..itemCount..leftBracket..Util:FormatThousand(multipliedMarketGold)..gold.." "..multipliedMarketSilver.."s "..copper..icon..rightBracket
	else
		message = marketName..leftBracket..Util:FormatThousand(marketGold)..gold.." "..marketSilver.."s "..copper..icon..rightBracket
	end

	return message
end

function Util:SendMessage(message, recipient, channel)
	if channel == "Guild" then
		if TSM4_PC.db.global["GuildChannel"] == "None" then return end
		SendChatMessage(message, TSM4_PC.db.global["GuildChannel"], "Common", recipient)
	elseif channel == "Whisper" then
		SendChatMessage(message, "WHISPER", "Common", recipient)
	elseif channel == "Officer" then
		if TSM4_PC.db.global["OfficerChannel"] == "None" then return end
		SendChatMessage(message, TSM4_PC.db.global["OfficerChannel"], "Common", recipient)
	elseif channel == "Party" then
		if TSM4_PC.db.global["PartyChannel"] == "None" then return end
		SendChatMessage(message, TSM4_PC.db.global["PartyChannel"], "Common", recipient)
	elseif channel == "Say" then
		if TSM4_PC.db.global["Channel"] == "None" then return end
		SendChatMessage(message, TSM4_PC.db.global["Channel"], "Common", recipient)
	elseif channel == "BNET" then
		BNSendWhisper(recipient, message)
	end
end

function Util:FormatThousand(value)
	local s = string.format("%d", math.floor(value))
	local pos = string.len(s) % 3
	if pos == 0 then pos = 3 end
	return string.sub(s, 1, pos)
		.. string.gsub(string.sub(s, pos+1), "(...)", ",%1")
		--.. string.sub(string.format("%.2f", v - math.floor(v)), 2)
end