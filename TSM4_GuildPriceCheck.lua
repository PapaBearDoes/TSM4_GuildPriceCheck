local TSM4_GPC = select(2, ...)
--local TSM4_GPC = LibStub("AceAddon-3.0"):NewAddon(TSM4_GPC, "TSM4_GuildPriceCheck", "AceConsole-3.0", "AceEvent-3.0")
--local AceGUI = LibStub("AceGUI-3.0")
--local L = LibStub("AceLocale-3.0"):GetLocale("TSM4_GuildPriceCheck")
local L = LibStub("AceLocale-3.0"):NewLocale("TSM4_GuildPriceCheck", "enUS", true)

TSM4_GPC.version = GetAddOnMetadata("TSM4_GuildPriceCheck", "Version")

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

function TSM4_GPC:OnInitialize()
	TSM4_GPC.db = LibStub:GetLibrary("AceDB-3.0"):New("TSM4_GuildPriceCheck", savedDBDefaults, true)
	TSM4_GPC.db.global["TriggerLength"] = string.len(TSM4_GPC.db.global["Trigger"])

	TSM4_GPC.LastRunDelayTime = 0
	TSM4_GPC.AddonDelayCheck = 0

	TSM4_GPC:RegisterEvent("CHAT_MSG_GUILD")
	TSM4_GPC:RegisterEvent("CHAT_MSG_WHISPER")
	TSM4_GPC:RegisterEvent("CHAT_MSG_BN_WHISPER")
	TSM4_GPC:RegisterEvent("CHAT_MSG_SAY")
	TSM4_GPC:RegisterEvent("CHAT_MSG_PARTY")
	TSM4_GPC:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	TSM4_GPC:RegisterEvent("CHAT_MSG_OFFICER")

	for moduleName, module in pairs(TSM4_GPC.modules) do
		TSM4_GPC[moduleName] = module
	end

	TSM4_GPC:RegisterModule()
end

function TSM4_GPC:OnEnable()
end

function TSM4_GPC:RegisterModule()
	TSM4_GPC.moduleOptions = {callback="Options:Load"}
end

function TSM4_GPC:CHAT_MSG_GUILD(_,MSG,Auth)
	TSM4_GPC:TriggeredEvent(MSG,Auth,"Guild")
end

function TSM4_GPC:CHAT_MSG_SAY(_,MSG,Auth)
	TSM4_GPC:TriggeredEvent(MSG,Auth,"Say")
end

function TSM4_GPC:CHAT_MSG_PARTY(_,MSG,Auth)
	TSM4_GPC:TriggeredEvent(MSG,Auth,"Party")
end

function TSM4_GPC:CHAT_MSG_PARTY_LEADER(_,MSG,Auth)
	TSM4_GPC:TriggeredEvent(MSG,Auth,"Party")
end

function TSM4_GPC:CHAT_MSG_OFFICER(_,MSG,Auth)
	TSM4_GPC:TriggeredEvent(MSG,Auth,"Officer")
end

function TSM4_GPC:CHAT_MSG_WHISPER(_,MSG,Auth)
	TSM4_GPC:TriggeredEvent(MSG,Auth,"Whisper")
end

function TSM4_GPC:CHAT_MSG_BN_WHISPER(_,message, _, _, _, _, _, _, _, _, _, _, _, presenceID)
	TSM4_GPC:TriggeredEvent(message,presenceID,"BNET")
end
