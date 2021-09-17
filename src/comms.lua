local SilentRotate = select(2, ...)

local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

-- Register comm prefix at initialization steps
function SilentRotate:initComms()

    SilentRotate.syncVersion = 0
    SilentRotate.syncLastSender = ''

    AceComm:RegisterComm(SilentRotate.constants.commsPrefix, SilentRotate.OnCommReceived)
end

-- Handle message reception and
function SilentRotate.OnCommReceived(prefix, data, channel, sender)

    if not UnitIsUnit('player', sender) then

        local success, message = AceSerializer:Deserialize(data)

        if (success) then
            if (message.mode ~= SilentRotate.db.profile.currentMode) then
                -- Received a message from another mode
                -- This may also happen if the message comes from an old version of the addon but it causes many problems so it's best to ignore the message
                -- In a future version, all modes will be working simultaneously, but that will be in a distant future (probably not before v1.0)
                return
            end

            if (message.type == SilentRotate.constants.commsTypes.tranqshotDone) then
                SilentRotate:receiveSyncTranq(prefix, message, channel, sender)
            elseif (message.type == SilentRotate.constants.commsTypes.syncOrder) then
                SilentRotate:receiveSyncOrder(prefix, message, channel, sender)
            elseif (message.type == SilentRotate.constants.commsTypes.syncRequest) then
                SilentRotate:receiveSyncRequest(prefix, message, channel, sender)
            end
        end
    end
end

-- Checks if a given version from a given sender should be applied
function SilentRotate:isVersionEligible(version, sender)
    return version > SilentRotate.syncVersion or (version == SilentRotate.syncVersion and sender < SilentRotate.syncLastSender)
end

-----------------------------------------------------------------------------------------------------------------------
-- Messaging functions
-----------------------------------------------------------------------------------------------------------------------

-- Proxy to send raid addon message
function SilentRotate:sendRaidAddonMessage(message)
    SilentRotate:sendAddonMessage(message, SilentRotate.constants.commsChannel)
end

-- Proxy to send whisper addon message
function SilentRotate:sendWhisperAddonMessage(message, name)
    SilentRotate:sendAddonMessage(message, 'WHISPER', name)
end

-- Broadcast a given message to the commsChannel with the commsPrefix
function SilentRotate:sendAddonMessage(message, channel, name)
    AceComm:SendCommMessage(
        SilentRotate.constants.commsPrefix,
        AceSerializer:Serialize(message),
        channel,
        name
    )
end

-----------------------------------------------------------------------------------------------------------------------
-- OUTPUT
-----------------------------------------------------------------------------------------------------------------------

-- Broadcast a tranqshot event
function SilentRotate:sendSyncTranq(hunter, fail, timestamp)
    local message = {
        ['type'] = SilentRotate.constants.commsTypes.tranqshotDone,
        ['mode'] = SilentRotate.db.profile.currentMode,
        ['timestamp'] = timestamp,
        ['player'] = hunter.GUID,
        ['fail'] = fail,
    }

    SilentRotate:sendRaidAddonMessage(message)
end

-- Broadcast current rotation configuration
function SilentRotate:sendSyncOrder(whisper, name)

    SilentRotate.syncVersion = SilentRotate.syncVersion + 1
    SilentRotate.syncLastSender = UnitName("player")

    local message = {
        ['type'] = SilentRotate.constants.commsTypes.syncOrder,
        ['mode'] = SilentRotate.db.profile.currentMode,
        ['version'] = SilentRotate.syncVersion,
        ['rotation'] = SilentRotate:getSimpleRotationTables(),
        ['addonVersion'] = SilentRotate.version,
    }

    if (whisper) then
        SilentRotate:sendWhisperAddonMessage(message, name)
    else
        SilentRotate:sendRaidAddonMessage(message, name)
    end
end

-- Broadcast a request for the current rotation configuration
function SilentRotate:sendSyncOrderRequest()

    local message = {
        ['type'] = SilentRotate.constants.commsTypes.syncRequest,
        ['mode'] = SilentRotate.db.profile.currentMode,
        ['addonVersion'] = SilentRotate.version,
    }

    SilentRotate:sendRaidAddonMessage(message)
end

-----------------------------------------------------------------------------------------------------------------------
-- INPUT
-----------------------------------------------------------------------------------------------------------------------

-- Tranqshot event received
function SilentRotate:receiveSyncTranq(prefix, message, channel, sender)

    local hunter = SilentRotate:getHunter(message.player)
    if (hunter == nil) then
        -- TODO maybe display a warning to the user because this should not happen in theory
        return
    end

    local notDuplicate = hunter.lastTranqTime <  GetTime() - SilentRotate.constants.duplicateTranqshotDelayThreshold

    if (notDuplicate) then
        SilentRotate:rotate(hunter, message.fail)
    end
end

-- Rotation configuration received
function SilentRotate:receiveSyncOrder(prefix, message, channel, sender)

    SilentRotate:updateRaidStatus()
    SilentRotate:updatePlayerAddonVersion(sender, message.addonVersion)

    if (SilentRotate:isVersionEligible(message.version, sender)) then
        SilentRotate.syncVersion = (message.version)
        SilentRotate.syncLastSender = sender

        SilentRotate:printPrefixedMessage('Received new rotation configuration from ' .. sender)
        SilentRotate:applyRotationConfiguration(message.rotation)
    end
end

-- Request to send current roration configuration received
function SilentRotate:receiveSyncRequest(prefix, message, channel, sender)
    SilentRotate:updatePlayerAddonVersion(sender, message.addonVersion)
    SilentRotate:sendSyncOrder(true, sender)
end
