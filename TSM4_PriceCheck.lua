local TSM4_PC = select(2, ...)
--local TSM4_PC = LibStub("AceAddon-3.0"):NewAddon(TSM4_PC, "TSM4_PriceCheck", "AceConsole-3.0", "AceEvent-3.0")
--local AceGUI = LibStub("AceGUI-3.0")
--local L = LibStub("AceLocale-3.0"):GetLocale("TSM4_PriceCheck")
local L = LibStub("AceLocale-3.0"):NewLocale("TSM_PriceCheck", "enUS", true)

TSM4_PC.version = GetAddOnMetadata("TSM4_PriceCheck", "Version")

--- Default the saved variables
local savedDBDefaults = {
	global = {
		["AddonEnabled"] = true,
		["UseRaidIcon"] = true,
		["ShowCopper"] = false,
		["ShowBrackets"] = true,
		["Trigger"] = "?pc",
		["TriggerLength"] = 0,
		["LockOutTime"] = 5,
		["Channel"] = "None",
		["GuildChannel"] = "WHISPER",
		["PartyChannel"] = "WHISPER",
		["OfficerChannel"] = "WHISPER",
		["Region"] = "DBRegionMarketAvg",
		["MarketSource"] = "DBMarket",
		["MinBuyoutSource"] = "DBMinBuyout",
		["MarketText"] = "Server Mkt Avg",
		["MinText"] = "Server Min Buyout",
		["RegionalText"] = "Region Mkt Avg",
		["PapaPrice"] = "PapaBear's Selling Price"
	},
}

function TSM4_PC:OnInitialize()
	TSM4_PC.db = LibStub:GetLibrary("AceDB-3.0"):New("TSM4_PriceCheck", savedDBDefaults, true)
	TSM4_PC.db.global["TriggerLength"] = string.len(TSM4_PC.db.global["Trigger"])

	TSM4_PC.LastRunDelayTime = 0
	TSM4_PC.AddonDelayCheck = 0

	TSM4_PC:RegisterEvent("CHAT_MSG_GUILD")
	TSM4_PC:RegisterEvent("CHAT_MSG_WHISPER")
	TSM4_PC:RegisterEvent("CHAT_MSG_BN_WHISPER")
	TSM4_PC:RegisterEvent("CHAT_MSG_SAY")
	TSM4_PC:RegisterEvent("CHAT_MSG_PARTY")
	TSM4_PC:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	TSM4_PC:RegisterEvent("CHAT_MSG_OFFICER")

	for moduleName, module in pairs(TSM4_PC.modules) do
		TSM4_PC[moduleName] = module
	end

	TSM4_PC:RegisterModule()
end

function TSM4_PC:OnEnable()
end

function TSM4_PC:RegisterModule()
	TSM4_PC.moduleOptions = {callback="Options:Load"}
end

function TSM4_PC:CHAT_MSG_GUILD(_,MSG,Auth)
	TSM4_PC:TriggeredEvent(MSG,Auth,"Guild")
end

function TSM4_PC:CHAT_MSG_SAY(_,MSG,Auth)
	TSM4_PC:TriggeredEvent(MSG,Auth,"Say")
end

function TSM4_PC:CHAT_MSG_PARTY(_,MSG,Auth)
	TSM4_PC:TriggeredEvent(MSG,Auth,"Party")
end

function TSM4_PC:CHAT_MSG_PARTY_LEADER(_,MSG,Auth)
	TSM4_PC:TriggeredEvent(MSG,Auth,"Party")
end

function TSM4_PC:CHAT_MSG_OFFICER(_,MSG,Auth)
	TSM4_PC:TriggeredEvent(MSG,Auth,"Officer")
end

function TSM4_PC:CHAT_MSG_WHISPER(_,MSG,Auth)
	TSM4_PC:TriggeredEvent(MSG,Auth,"Whisper")
end

function TSM4_PC:CHAT_MSG_BN_WHISPER(_,message, _, _, _, _, _, _, _, _, _, _, _, presenceID)
	TSM4_PC:TriggeredEvent(message,presenceID,"BNET")
end