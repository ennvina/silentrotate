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

-- Load history messages from config
function SilentRotate:loadHistory()
    for _, item in pairs(SilentRotate.db.profile.history.messages) do
        local mode = SilentRotate:getMode(item.modeName)
        if mode then
            local modeName = L["FILTER_SHOW_"..mode.modeNameUpper]
            local hrTime = item.timestamp
            local msg = item.text
            SilentRotate.historyFrame.backgroundFrame.textFrame:AddMessage(string.format("%s [%s] %s", modeName, hrTime, msg))
        end
    end
end

-- Clear messages on screen and in config
function SilentRotate.clearHistory()
    SilentRotate.historyFrame.backgroundFrame.textFrame:Clear()
    SilentRotate.db.profile.history.messages = {}
end

-- Show again messages that were hidden due to fading after a certain time
function SilentRotate.refreshHistory()
    SilentRotate.historyFrame.backgroundFrame.textFrame:ResetAllFadeTimes()
end
