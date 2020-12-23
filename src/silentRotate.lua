SilentRotate = select(2, ...)

local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

local parent = ...
SilentRotate.version = GetAddOnMetadata(parent, "Version")

-- Initialize addon - Shouldn't be call more than once
function SilentRotate:init()

    self:LoadDefaults()

    self.db = LibStub:GetLibrary("AceDB-3.0"):New("SilentRotateDb", self.defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "ProfilesChanged")

    self:CreateConfig()

    SilentRotate.hunterTable = {}
    SilentRotate.rotationTables = { rotation = {}, backup = {} }
    SilentRotate.enableDrag = true

    SilentRotate.raidInitialized = false
    SilentRotate.testMode = false

    SilentRotate:initGui()
    SilentRotate:updateRaidStatus()
    SilentRotate:applySettings()

    SilentRotate:initComms()

    SilentRotate:printMessage(L['LOADED_MESSAGE'])
end

-- Apply setting on profile change
function SilentRotate:ProfilesChanged()
	self.db:RegisterDefaults(self.defaults)
    self:applySettings()
end

-- Apply settings
function SilentRotate:applySettings()

    SilentRotate.mainFrame:ClearAllPoints()

    local config = SilentRotate.db.profile
    if config.point then
        SilentRotate.mainFrame:SetPoint(config.point, UIParent, 'BOTTOMLEFT', config.x, config.y)
    else
        SilentRotate.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    SilentRotate:updateDisplay()

    SilentRotate.mainFrame:EnableMouse(not SilentRotate.db.profile.lock)
    SilentRotate.mainFrame:SetMovable(not SilentRotate.db.profile.lock)
end

-- Print wrapper, just in case
function SilentRotate:printMessage(msg)
    print(msg)
end

-- Print message with colored prefix
function SilentRotate:printPrefixedMessage(msg)
    SilentRotate:printMessage(SilentRotate:colorText(SilentRotate.constants.printPrefix) .. msg)
end

-- Send a tranq annouce message to a given channel
function SilentRotate:sendAnnounceMessage(message, targetName)
    if SilentRotate.db.profile.enableAnnounces then
        SilentRotate:sendMessage(
            message,
            targetName,
            SilentRotate.db.profile.channelType,
            SilentRotate.db.profile.targetChannel
        )
    end
end

-- Send a rotation broadcast message
function SilentRotate:sendRotationSetupBroacastMessage(message)
    if SilentRotate.db.profile.enableAnnounces then
        SilentRotate:sendMessage(
            message,
            nil,
            SilentRotate.db.profile.rotationReportChannelType,
            SilentRotate.db.profile.setupBroadcastTargetChannel
        )
    end
end

-- Send a message to a given channel
function SilentRotate:sendMessage(message, targetName, channelType, targetChannel)
    local channelNumber
    if channelType == "CHANNEL" then
        channelNumber = GetChannelName(targetChannel)
    end
    SendChatMessage(string.format(message, targetName), channelType, nil, channelNumber or targetChannel)
end

SLASH_SILENTROTATE1 = "/sr"
SLASH_SILENTROTATE2 = "/silentrotate"
SlashCmdList["SILENTROTATE"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if (cmd == 'toggle') then
        SilentRotate:toggleDisplay()
    elseif (cmd == 'lock') then
        SilentRotate:lock(true)
    elseif (cmd == 'unlock') then
        SilentRotate:lock(false)
    elseif (cmd == 'backup') then
        SilentRotate:whisperBackup()
    elseif (cmd == 'rotate') then -- @todo decide if this should be removed or not
        SilentRotate:testRotation()
    elseif (cmd == 'test') then -- @todo: remove this
        SilentRotate:test()
    elseif (cmd == 'report') then
        SilentRotate:printRotationSetup()
    elseif (cmd == 'settings') then
        SilentRotate:openSettings()
    else
        SilentRotate:printHelp()
    end
end
--SlashCmdList["SR"] = SlashCmdList["SILENTROTATE"]

function SilentRotate:toggleDisplay()
    if (SilentRotate.mainFrame:IsShown()) then
        SilentRotate.mainFrame:Hide()
        SilentRotate:printMessage(L['TRANQ_WINDOW_HIDDEN'])
    else
        SilentRotate.mainFrame:Show()
    end
end

-- @todo: remove this
function SilentRotate:test()
    SilentRotate:printMessage('test')
    SilentRotate:toggleArcaneShotTesting()
end

-- Open ace settings
function SilentRotate:openSettings()
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    AceConfigDialog:Open("SilentRotate")
end

-- Sends rotation setup to raid channel
function SilentRotate:printRotationSetup()

    if (IsInRaid()) then
        SilentRotate:sendRotationSetupBroacastMessage('--- ' .. SilentRotate.constants.printPrefix .. SilentRotate:GetBroadcastHeaderText() .. ' ---', channel)

        if (SilentRotate.db.profile.useMultilineRotationReport) then
            SilentRotate:printMultilineRotation(SilentRotate.rotationTables.rotation)
        else
            SilentRotate:sendRotationSetupBroacastMessage(
                SilentRotate:buildGroupMessage(L['BROADCAST_ROTATION_PREFIX'] .. ' : ', SilentRotate.rotationTables.rotation)
            )
        end

        if (#SilentRotate.rotationTables.backup > 0) then
            SilentRotate:sendRotationSetupBroacastMessage(
                SilentRotate:buildGroupMessage(L['BROADCAST_BACKUP_PREFIX'] .. ' : ', SilentRotate.rotationTables.backup)
            )
        end
    end
end

-- Print the main rotation on multiple lines
function SilentRotate:printMultilineRotation(rotationTable, channel)
    local position = 1;
    for key, hunt in pairs(rotationTable) do
        SilentRotate:sendRotationSetupBroacastMessage(tostring(position) .. ' - ' .. hunt.name)
        position = position + 1;
    end
end

-- Serialize hunters names of a given rotation group
function SilentRotate:buildGroupMessage(prefix, rotationTable)
    local hunters = {}

    for key, hunt in pairs(rotationTable) do
        table.insert(hunters, hunt.name)
    end

    return prefix .. table.concat(hunters, ', ')
end

-- Print command options to chat
function SilentRotate:printHelp()
    local spacing = '   '
    SilentRotate:printMessage(SilentRotate:colorText('/silentrotate') .. ' commands options :')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('toggle') .. ' : Show/Hide the main window')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('lock') .. ' : Lock the main window position')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('unlock') .. ' : Unlock the main window position')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('settings') .. ' : Open SilentRotate settings')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('report') .. ' : Print the rotation setup to the configured channel')
    SilentRotate:printMessage(spacing .. SilentRotate:colorText('backup') .. ' : Whispers backup hunters to immediately tranq')
end

-- Adds color to given text
function SilentRotate:colorText(text)
    return '|cffffbf00' .. text .. '|r'
end

-- Check if unit is promoted
function SilentRotate:isHunterPromoted(name)

    local raidIndex = UnitInRaid(name)

    if (raidIndex) then
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(raidIndex)

        if (rank > 0) then
            return true
        end
    end

    return false
end

-- Toggle arcane shot testing mode
function SilentRotate:toggleArcaneShotTesting(disable)

    if (not disable and not SilentRotate.testMode) then
        SilentRotate:printPrefixedMessage(L['ARCANE_SHOT_TESTING_ENABLED'])
        SilentRotate.testMode = true

        -- Disable testing after 10 minutes
        C_Timer.After(600, function()
            SilentRotate:toggleArcaneShotTesting(true)
        end)
    else
        SilentRotate.testMode = false
        SilentRotate:printPrefixedMessage(L['ARCANE_SHOT_TESTING_DISABLED'])
    end

    SilentRotate:updateRaidStatus()
end