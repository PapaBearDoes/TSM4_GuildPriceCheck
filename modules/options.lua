local TSM4_GPC = select(2, ...)
local TSM4_GPC = LibStub("AceAddon-3.0"):NewAddon(TSM4_GPC, "TSM4_GuildPriceCheck", "AceConsole-3.0", "AceEvent-3.0")
--local L = LibStub("AceLocale-3.0"):GetLocale("TSM4_GuildPriceCheck")
local L = LibStub("AceLocale-3.0"):NewLocale("TSM4_GuildPriceCheck", "enUS", true)

local Opts = TSM4_GPC:NewModule("Opts", "AceConsole-3.0")

function Opts:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("TSM4_GuildPriceCheck")
end

function Opts:SetTrigger(info, input)
    self.db.global.Trigger = input
		print("Set trigger to ", input)
end

function Opts:SetEnableAddon(info, input)
		self.db.global.AddonEnabled = true
		print("GuildPriceCheck is now enabled")
end

function Opts:GetAddonEnabled(info)
		return self.db.global.AddonEnabled
end

function Opts:SetDisableAddon(info, input)
		self.db.global.AddonEnabled = false
		print("GuildPriceCheck is now disabled")
end

function Opts:SetRaidIcon(info, input)
		if Opts:GetRaidIcon(info) == false then
			print("Raid icon will now be used")
			self.db.global.UseRaidIcon = true
		else print("Raid icon is now disabled")
			self.db.global.UseRaidIcon = false
		end
end

function Opts:GetRaidIcon(info)
		return self.db.global.UseRaidIcon
end

function Opts:GetShowCopper(info)
		return self.db.global.ShowCopper
end

function Opts:SetShowCopper(info)
	if Opts:GetShowCopper(info) == false then
		print("Copper will now be shown")
		self.db.global.ShowCopper = true
	else print("Copper will now be hidden")
		self.db.global.ShowCopper = false
	end
end

function Opts:GetShowBrackets(info)
		return self.db.global.ShowBrackets
end

function Opts:SetShowBrackets(info)
	if Opts:GetShowBrackets(info) == false then
		print("Brackets will now be shown")
		self.db.global.ShowBrackets = true
	else print("Brackets will now be hidden")
		self.db.global.ShowBrackets = false
	end
end

function Opts:SetGuildChannel(info, input)
	input = strupper(input)
	if (input == 'GUILD' or input == 'OFFICER' or input == 'WHISPER' or input == 'PARTY') then
    self.db.global.GuildChannel = input
		print("Set reply for guild messages to ", input)
	else
		print("Incorrect channel name. Guild message reply channel was not changed.")
	end
end

function Opts:SetPartyChannel(info, input)
	input = strupper(input)
	if (input == 'GUILD' or input == 'OFFICER' or input == 'WHISPER' or input == 'PARTY') then
    self.db.global.PartyChannel = input
		print("Set reply for Party messages to ", input)
	else
		print("Incorrect channel name. Party message reply channel was not changed.")
	end
end

function Opts:SetOfficerChannel(info, input)
	input = strupper(input)
	if (input == 'GUILD' or input == 'OFFICER' or input == 'WHISPER' or input == 'PARTY') then
    self.db.global.OfficerChannel = input
		print("Set reply for Officer messages to ", input)
	else
		print("Incorrect channel name. Officer message reply channel was not changed.")
	end
end

local options = {
    name = "TSM4_GuildPriceCheck",
    handler = Opts,
    type = 'group',
    args = {
			--trigger
        trigger = {
            type = 'input',
            name = 'Trigger',
            desc = '/pc trigger triggerkey',
            set = 'SetTrigger',
        },
				--AddonEnabled
				enable = {
						type = 'toggle',
						name = 'Enable Addon',
						desc = '/pc enable',
						set = 'SetEnableAddon',
						get = 'GetAddonEnabled',
				},
				--AddonDisabled
				disable = {
						type = 'toggle',
						name = 'Disable Addon',
						desc = '/pc disable',
						set = 'SetDisableAddon',
						get = 'GetAddonEnabled',
				},
				--UseRaidIcon
				useraidicon = {
						type = 'toggle',
						name = 'Use Raid Icon',
						desc = '/pc useraidicon',
						set = 'SetRaidIcon',
						get = 'GetRaidIcon',
				},
				--ShowCopper
				showcopper = {
						type = 'toggle',
						name = 'Show Copper on prices',
						desc = '/pc showcopper',
						set = 'SetShowCopper',
						get = 'GetShowCopper',
				},
				--ShowBrackets
				showbrackets = {
						type = 'toggle',
						name = 'Show brackets around prices',
						desc = '/pc showbrackets',
						set = 'SetShowBrackets',
						get = 'GetShowBrackets'
				},
				--GuildChannel
				guildchannel = {
						type = 'input',
						name = 'Channel to reply for guild messages',
						desc = '/pc guild CHANNEL',
						set = 'SetGuildChannel',
				},
				--PartyChannel
				partychannel = {
						type = 'input',
						name = 'Channel to reply for party messages',
						desc = '/pc party CHANNEL',
						set = 'SetPartyChannel',
				},
				--OfficerChannel
				officerchannel = {
						type = 'input',
						name = 'Channel to reply for officer messages',
						desc = '/pc officer CHANNEL',
						set = 'SetOfficerChannel',
				},
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("TSM4_GuildPriceCheck", options, {"pc"})
