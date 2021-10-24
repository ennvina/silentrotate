local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Add one message to current history and save it to config
-- @param message   Message to add
-- @param mode      The mode object corresponding to the message
-- @param timestamp The server time; if nil, then GetServerTime() is used
function SilentRotate:addHistoryMessage(msg, mode, timestamp)
    local modeName = L["FILTER_SHOW_"..mode.modeNameUpper]
    local hrTime = date("%H:%M:%S", timestamp or GetServerTime())
    SilentRotate.historyFrame.backgroundFrame.textFrame:AddMessage(string.format("%s [%s] %s", modeName, hrTime, msg))
    table.insert(SilentRotate.db.profile.history.messages, { mode = mode.modeName, timestamp = hrTime, text = msg })
end

-- Add one message for a spell cast
-- If destName is nil, there is no target
function SilentRotate:addHistorySpellMessage(sourceName, destName, spellName, failed, mode, timestamp)
    local msg
    if failed then
        msg = string.format(L["HISTORY_SPELLCAST_FAILURE"], sourceName, spellName, destName)
    elseif destName then
        msg = string.format(L["HISTORY_SPELLCAST_SUCCESS"], sourceName, spellName, destName)
    else
        msg = string.format(L["HISTORY_SPELLCAST_NOTARGET"], sourceName, spellName)
    end
    self:addHistoryMessage(msg, mode, timestamp)
end

-- Add one message for a debuff applied
function SilentRotate:addHistoryDebuffMessage(unitName, spellName, mode, timestamp)
    local msg = string.format(L["HISTORY_DEBUFF_RECEIVED"], unitName, spellName)
    self:addHistoryMessage(msg, mode, timestamp)
end

-- Load history messages from config
function SilentRotate:loadHistory()
    for _, item in pairs(SilentRotate.db.profile.history.messages) do
        local mode = SilentRotate:getMode(item.mode)
        if mode then
            local modeName = L["FILTER_SHOW_"..mode.modeNameUpper]
            local hrTime = item.timestamp
            local msg = item.text
            SilentRotate.historyFrame.backgroundFrame.textFrame:AddMessage(string.format("%s [%s] %s", modeName, hrTime, msg))
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
