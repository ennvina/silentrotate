local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Add one message to current history and save it to config
-- @param message   Message to add
-- @param mode      The mode object corresponding to the message
function SilentRotate:addHistoryMessage(msg, mode)
    local modeName = WrapTextInColorCode(L["FILTER_SHOW_"..mode.modeNameUpper], self:getModeColor(mode))
    local timestamp = GetTime()
    local hrTime = date("%H:%M:%S", GetServerTime())
    SilentRotate.historyFrame.backgroundFrame.textFrame:AddMessage(string.format("%s [%s] %s", modeName, hrTime, msg))
    table.insert(SilentRotate.db.profile.history.messages, {
        mode = mode.modeName,
        timestamp = timestamp,
        humanReadableTime = hrTime,
        text = msg
    })
end

-- Add one message for a spell cast
-- If destName is nil, there is no target
function SilentRotate:addHistorySpellMessage(hunter, sourceName, destName, spellName, failed, mode)
    local msg
    if type(mode.customHistoryFunc) == 'function' then
        msg = mode.customHistoryFunc(mode, hunter, sourceName, destName, spellName, failed)
    elseif failed then
        msg = string.format(self:getHistoryPattern("HISTORY_SPELLCAST_FAILURE"), sourceName, spellName, destName)
    elseif mode.announceArg == 'sourceGroup' then
        msg = string.format(self:getHistoryPattern("HISTORY_SPELLCAST_SUCCESS"), sourceName, spellName, string.format(L['DEFAULT_GROUP_SUFFIX_MESSAGE'], hunter.subgroup or 0))
    elseif destName then
        msg = string.format(self:getHistoryPattern("HISTORY_SPELLCAST_SUCCESS"), sourceName, spellName, destName)
    else
        msg = string.format(self:getHistoryPattern("HISTORY_SPELLCAST_NOTARGET"), sourceName, spellName)
    end
    self:addHistoryMessage(msg, mode)
end

-- Add one message for a debuff applied
function SilentRotate:addHistoryDebuffMessage(hunter, unitName, spellName, mode)
    local msg
    if type(mode.customHistoryFunc) == 'function' then
        msg = mode.customHistoryFunc(mode, hunter, nil, destName, spellName)
    else
        msg = string.format(self:getHistoryPattern("HISTORY_DEBUFF_RECEIVED"), unitName, spellName)
    end
    self:addHistoryMessage(msg, mode)
end

function SilentRotate:getHistoryPattern(localeKey)
    local colorBegin = "|cffb3b3b3"
    local colorEnd = "|r"
    return colorBegin..L[localeKey]:gsub("(%%s)", colorEnd.."%1"..colorBegin):gsub("||([^|]*)||", colorEnd.."%1"..colorBegin)..colorEnd
end

-- Load history messages from config
function SilentRotate:loadHistory()
    for _, item in pairs(SilentRotate.db.profile.history.messages) do
        local mode = SilentRotate:getMode(item.mode)
        if mode then
            local modeName = WrapTextInColorCode(L["FILTER_SHOW_"..mode.modeNameUpper], self:getModeColor(mode))
            local hrTime = item.humanReadableTime
            local msg = item.text
            SilentRotate.historyFrame.backgroundFrame.textFrame:AddMessage(string.format("%s [%s] %s", modeName, hrTime, msg))
            -- Hack the timestamp so that fading actually relates to when the message was added
            SilentRotate.historyFrame.backgroundFrame.textFrame.historyBuffer:GetEntryAtIndex(1).timestamp = item.timestamp
        end
    end
end

-- Clear messages on screen and in config
function SilentRotate:clearHistory()
    SilentRotate.historyFrame.backgroundFrame.textFrame:Clear()
    SilentRotate.db.profile.history.messages = {}
end

-- Set time until fadeout starts, in seconds
function SilentRotate:setHistoryTimeVisible(duration)
    if type(duration) ~= 'number' then
        duration = tonumber(duration)
    end
    if type(duration) == 'number' and duration >= 0 then
        SilentRotate.historyFrame.backgroundFrame.textFrame:SetTimeVisible(duration)
    end
end

-- Show again messages that were hidden due to fading after a certain time
function SilentRotate:respawnHistory()
    SilentRotate.historyFrame.backgroundFrame.textFrame:ResetAllFadeTimes()
end

-- Set the font size for displaying log messages
function SilentRotate:setHistoryFontSize(fontSize)
    local fontFace = SilentRotate.constants.history.fontFace
    SilentRotate.historyFrame.backgroundFrame.textFrame:SetFont(fontFace, fontSize)
end

-- Track the buff provided by the hunter and trigger history events when the buffs expires or is lost
function SilentRotate:trackHistoryBuff(hunter)
    if hunter and hunter.historyTrackerTicker then
        -- Start by clearing any remaining ticker
        hunter.historyTrackerTicker:Cancel()
        hunter.historyTrackerTicker = nil
    end

    if not hunter or not hunter.buffName or not hunter.targetGUID or not hunter.endTimeOfEffect then
        -- Cannot work without sufficient information
        return
    end

    local mode = SilentRotate:getMode() -- @todo get mode from hunter
    if not mode or mode.buffCanReturn then
        -- Do not bother with returnable buffs: we never know if they are really gone
        return
    end

    local targetName, buffMode = SilentRotate:getHunterTarget(hunter)
    if buffMode == 'not_a_buff' then
        -- Nothinig to track
        return
    elseif buffMode == 'buff_expired' then
        -- Track already ended: buff expired
        local msg = string.format(self:getHistoryPattern('HISTORY_SPELLCAST_EXPIRE'), hunter.buffName, targetName)
        self:addHistoryMessage(msg, mode)
        return
    else -- buffMode == 'has_buff' or buffMode == 'buff_lost'
        -- If the buff is (supposedly) already lost, maybe it is due to client-server lag
        -- So we wait for the next timer tick before deciding whether the buff is really lost
        local refreshInterval = 1.5
        hunter.historyTrackerMode = mode.modeName
        hunter.historyTrackerTicker = C_Timer.NewTicker(refreshInterval, function()
            local targetName, buffMode = SilentRotate:getHunterTarget(hunter)
            local msg
            if buffMode == 'buff_lost' then
                msg = string.format(self:getHistoryPattern('HISTORY_SPELLCAST_CANCEL'), hunter.buffName, targetName)
            elseif buffMode == 'buff_expired' then
                msg = string.format(self:getHistoryPattern('HISTORY_SPELLCAST_EXPIRE'), hunter.buffName, targetName)
            end
            if msg then
                local mode = SilentRotate:getMode(hunter.historyTrackerMode)
                if mode then
                    self:addHistoryMessage(msg, mode)
                end
                hunter.historyTrackerTicker:Cancel()
                hunter.historyTrackerTicker = nil
            end
        end)
    end
end
