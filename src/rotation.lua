local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Adds hunter to global table and one of the two rotation tables
function SilentRotate:registerHunter(hunterName)

    -- Initialize hunter 'object'
    local hunter = {}
    hunter.name = hunterName
    hunter.GUID = UnitGUID(hunterName)
    hunter.frame = nil
    hunter.nextTranq = false
    hunter.lastTranqTime = 0

    -- Add to global list
    table.insert(SilentRotate.hunterTable, hunter)

    -- Add to rotation or backup group depending on rotation group size
    if (#SilentRotate.rotationTables.rotation > 2) then
        table.insert(SilentRotate.rotationTables.backup, hunter)
    else
        table.insert(SilentRotate.rotationTables.rotation, hunter)
    end

    SilentRotate:drawHunterFrames()

    return hunter
end

-- Removes a hunter from all lists
function SilentRotate:removeHunter(deletedHunter)

    -- Clear from global list
    for key, hunter in pairs(SilentRotate.hunterTable) do
        if (hunter.name == deletedHunter.name) then
            SilentRotate:hideHunter(hunter)
            table.remove(SilentRotate.hunterTable, key)
            break
        end
    end

    -- clear from rotation lists
    for key, hunterTable in pairs(SilentRotate.rotationTables) do
        for subkey, hunter in pairs(hunterTable) do
            if (hunter.name == deletedHunter.name) then
                table.remove(hunterTable, subkey)
            end
        end
    end

    SilentRotate:drawHunterFrames()
end

-- Update the rotation list once a tranq has been done.
-- The parameter is the hunter that used it's tranq (successfully or not)
function SilentRotate:rotate(lastHunter, fail, rotateWithoutCooldown, endTimeOfCooldown)

    -- Default value to false
    fail = fail or false

    local playerName, realm = UnitName("player")
    local hunterRotationTable = SilentRotate:getHunterRotationTable(lastHunter)
    local hasPlayerFailed = playerName == lastHunter.name and fail

    lastHunter.lastTranqTime = GetTime()

    -- Do not trigger cooldown when rotation from a dead or disconnected status
    if (rotateWithoutCooldown ~= true) then
        SilentRotate:startHunterCooldown(lastHunter, endTimeOfCooldown)
    end

    if (hunterRotationTable == SilentRotate.rotationTables.rotation) then
        local nextHunter = SilentRotate:getNextRotationHunter(lastHunter)

        if (nextHunter ~= nil) then

            SilentRotate:setNextTranq(nextHunter)

            if (SilentRotate:isHunterTranqCooldownReady(nextHunter)) then
                if (#SilentRotate.rotationTables.backup < 1) then
                    -- if (hasPlayerFailed) then
                    --     SendChatMessage(SilentRotate.db.profile.whisperFailMessage, 'WHISPER', nil, nextHunter.name)
                    -- end

                    if (fail and nextHunter.name == playerName) then
                        SilentRotate:throwTranqAlert()
                    end
                end
            end
        end
    end

    if (fail) then
        -- if (hasPlayerFailed) then
        --     SilentRotate:whisperBackup()
        -- end

        if (SilentRotate:getHunterRotationTable(SilentRotate:getHunter(playerName)) == SilentRotate.rotationTables.backup) then
            SilentRotate:throwTranqAlert()
        end
    end
end

-- Whisper fail message to all backup except player
function SilentRotate:whisperBackup()
    local name, realm = UnitName("player")
    for key, backupHunter in pairs(SilentRotate.rotationTables.backup) do
        if (backupHunter.name ~= name) then
            SendChatMessage(SilentRotate.db.profile.whisperFailMessage, 'WHISPER', nil, backupHunter.name)
        end
    end
end

-- Removes all nextTranq flags and set it true for next shooter
function SilentRotate:setNextTranq(nextHunter)
    for key, hunter in pairs(SilentRotate.rotationTables.rotation) do
        if (hunter.name == nextHunter.name) then
            hunter.nextTranq = true

            if (nextHunter.name == UnitName("player")) and SilentRotate.db.profile.enableNextToTranqSound then
                PlaySoundFile(SilentRotate.constants.sounds.nextToTranq)
            end
        else
            hunter.nextTranq = false
        end

        SilentRotate:refreshHunterFrame(hunter)
    end
end

-- Check if the player is the next in position to tranq
function SilentRotate:isPlayerNextTranq()

    local player = SilentRotate:getHunter(nil, UnitGUID("player"))

    -- Non hunter user
    if (player == nil) then
        return false
    end

    if (not player.nextTranq) then

        local isRotationInitialized = false;
        local rotationTable = SilentRotate.rotationTables.rotation

        -- checking if a hunter is flagged nextTranq
        for key, hunter in pairs(rotationTable) do
            if (hunter.nextTranq) then
                isRotationInitialized = true;
                break
            end
        end

        -- First in rotation has to tranq if not one is flagged
        if (not isRotationInitialized and SilentRotate:getHunterIndex(player, rotationTable) == 1) then
            return true
        end

    end

    return player.nextTranq
end

-- Find and returns the next hunter that will tranq base on last shooter
function SilentRotate:getNextRotationHunter(lastHunter)

    local rotationTable = SilentRotate.rotationTables.rotation
    local nextHunter
    local lastHunterIndex = 1

    -- Finding last hunter index in rotation
    for key, hunter in pairs(rotationTable) do
        if (hunter.name == lastHunter.name) then
            lastHunterIndex = key
            break
        end
    end

    -- Search from last hunter index if not last on rotation
    if (lastHunterIndex < #rotationTable) then
        for index = lastHunterIndex + 1 , #rotationTable, 1 do
            local hunter = rotationTable[index]
            if (SilentRotate:isEligibleForNextTranq(hunter)) then
                nextHunter = hunter
                break
            end
        end
    end

    -- Restart search from first index
    if (nextHunter == nil) then
        for index = 1 , lastHunterIndex, 1 do
            local hunter = rotationTable[index]
            if (SilentRotate:isEligibleForNextTranq(hunter)) then
                nextHunter = hunter
                break
            end
        end
    end

    -- If no hunter in the rotation match the alive/online/CD criteria
    -- Pick the hunter with the lowest cooldown
    if (nextHunter == nil and #rotationTable > 0) then
        local latestTranq = GetTime() + 1
        for key, hunter in pairs(rotationTable) do
            if (SilentRotate:isHunterAliveAndOnline(hunter) and hunter.lastTranqTime < latestTranq) then
                nextHunter = hunter
                latestTranq = hunter.lastTranqTime
            end
        end
    end

    return nextHunter
end

-- Init/Reset rotation status, next tranq is the first hunter on the list
function SilentRotate:resetRotation()
    for key, hunter in pairs(SilentRotate.rotationTables.rotation) do
        hunter.nextTranq = false
        SilentRotate:refreshHunterFrame(hunter)
    end
end

-- @todo: remove this | TEST FUNCTION - Manually rotate hunters for test purpose
function SilentRotate:testRotation()

    for key, hunter in pairs(SilentRotate.rotationTables.rotation) do
        if (hunter.nextTranq) then
            SilentRotate:rotate(hunter, false)
            break
        end
    end
end

-- Check if a hunter is already registered
function SilentRotate:isHunterRegistered(GUID)

    -- @todo refactor this using SilentRotate:getHunter(name, GUID)
    for key,hunter in pairs(SilentRotate.hunterTable) do
        if (hunter.GUID == GUID) then
            return true
        end
    end

    return false
end

-- Return our hunter object from name or GUID
function SilentRotate:getHunter(name, GUID)

    -- Known limitation: if both name and GUID are set but do not correspond to the same unit, results are undefined

    if (GUID ~= nil) then
        for key,hunter in pairs(SilentRotate.hunterTable) do
            if (hunter.GUID == GUID) then
                return hunter
            end
        end
    end

    if (name ~= nil) then
        for key,hunter in pairs(SilentRotate.hunterTable) do
            if (hunter.name == name) then
                return hunter
            end
        end
    end

    return nil
end

-- Iterate over hunter list and purge hunter that aren't in the group anymore
function SilentRotate:purgeHunterList()

    local change = false
    local huntersToRemove = {}

    for key,hunter in pairs(SilentRotate.hunterTable) do

        if  (
                -- Is unit in the party? "player" is always accepted
                ( not UnitInParty(hunter.name) and not UnitIsUnit(hunter.name, "player") )
            or
                -- Is the class required for the current mode?
                -- The 'select' result must be in parentheses to prevent argument bleeding
                not SilentRotate:isPlayerWanted(hunter.name, nil, nil)
            ) then
            table.insert(huntersToRemove, hunter)
        end
    end

    if (#huntersToRemove > 0) then
        for key,hunter in ipairs(huntersToRemove) do
            SilentRotate:unregisterUnitEvents(hunter)
            SilentRotate:removeHunter(hunter)
        end
        SilentRotate:drawHunterFrames()
    end

end

-- Update the status of one hunter
function SilentRotate:updateUnitStatus(name, classFilename, subgroup)

    local GUID = UnitGUID(name)
    local hunter

    if SilentRotate:isPlayerWanted(name, (classFilename), nil) then

        local registered = SilentRotate:isHunterRegistered(GUID)

        if (not registered) then
            if (not InCombatLockdown()) then
                hunter = SilentRotate:registerHunter(name)
                SilentRotate:registerUnitEvents(hunter)
                registered = true
            end
        else
            hunter = SilentRotate:getHunter(nil, GUID)
        end

        if (registered) then
            hunter.subgroup = subgroup
            SilentRotate:updateHunterStatus(hunter)
        end

    end

end

-- Iterate over all raid members to find hunters and update their status
function SilentRotate:updateRaidStatus()

    if (SilentRotate:isInPveRaid()) then

        local playerCount = GetNumGroupMembers()

        if (playerCount > 0) then
            for index = 1, playerCount, 1 do
                local name, rank, subgroup, level, class, classFilename, zone, online, isDead, role, isML = GetRaidRosterInfo(index)

                -- Players name might be nil at loading
                if (name ~= nil) then
                    SilentRotate:updateUnitStatus(name, classFilename, subgroup)
                end
            end
        else
            local name = UnitName("player")
            local classFilename = select(2,UnitClass("player"))
            SilentRotate:updateUnitStatus(name, classFilename, 1)
            for i = 1, 4 do
                local name = UnitName("party"..i)
                if (name) then
                    classFilename = select(2,UnitClass("party"..i))
                    SilentRotate:updateUnitStatus(name, classFilename, 1)
                end
            end
        end

        if (not SilentRotate.raidInitialized) then
            if (not SilentRotate.db.profile.doNotShowWindowOnRaidJoin) then
                SilentRotate:updateDisplay()
            end
            SilentRotate:sendSyncOrderRequest()
            SilentRotate.raidInitialized = true
        end
    else
        if(SilentRotate.raidInitialized == true) then
            SilentRotate:updateDisplay()
            SilentRotate.raidInitialized = false
        end
    end

    SilentRotate:purgeHunterList()
end

-- Update hunter status
function SilentRotate:updateHunterStatus(hunter)

    -- Jump to the next hunter if the current one is dead or offline
    if (hunter.nextTranq and (not SilentRotate:isHunterAliveAndOnline(hunter))) then
        SilentRotate:rotate(hunter, false, true)
    end

    SilentRotate:refreshHunterFrame(hunter)
end

-- Moves given hunter to the given position in the given group (ROTATION or BACKUP)
function SilentRotate:moveHunter(hunter, group, position)

    local originTable = SilentRotate:getHunterRotationTable(hunter)
    local originIndex = SilentRotate:getHunterIndex(hunter, originTable)

    local destinationTable = SilentRotate.rotationTables.rotation
    local finalIndex = position

    if (group == 'BACKUP') then
        destinationTable = SilentRotate.rotationTables.backup
        -- Remove nextTranq flag when moved to backup
        hunter.nextTranq = false
    end

    -- Setting originalIndex
    local sameTableMove = originTable == destinationTable

    -- Defining finalIndex
    if (sameTableMove) then
        if (position > #destinationTable or position == 0) then
            if (#destinationTable > 0) then
                finalIndex = #destinationTable
            else
                finalIndex = 1
            end
        end
    else
        if (position > #destinationTable + 1 or position == 0) then
            if (#destinationTable > 0) then
                finalIndex = #destinationTable  + 1
            else
                finalIndex = 1
            end
        end
    end

    if (sameTableMove) then
        if (originIndex ~= finalIndex) then
            table.remove(originTable, originIndex)
            table.insert(originTable, finalIndex, hunter)
        end
    else
        table.remove(originTable, originIndex)
        table.insert(destinationTable, finalIndex, hunter)
    end

    SilentRotate:drawHunterFrames()
end

-- Find the table that contains given hunter (rotation or backup)
function SilentRotate:getHunterRotationTable(hunter)
    if (SilentRotate:tableContains(SilentRotate.rotationTables.rotation, hunter)) then
        return SilentRotate.rotationTables.rotation
    end
    if (SilentRotate:tableContains(SilentRotate.rotationTables.backup, hunter)) then
        return SilentRotate.rotationTables.backup
    end
end

-- Returns a hunter's index in the given table
function SilentRotate:getHunterIndex(hunter, table)
    local originIndex = 0

    for key, loopHunter in pairs(table) do
        if (hunter.name == loopHunter.name) then
            originIndex = key
            break
        end
    end

    return originIndex
end

-- Builds simple rotation tables containing only hunters names
function SilentRotate:getSimpleRotationTables()

    local simpleTables = { rotation = {}, backup = {} }

    for key, rotationTable in pairs(SilentRotate.rotationTables) do
        for _, hunter in pairs(rotationTable) do
            table.insert(simpleTables[key], hunter.name)
        end
    end

    return simpleTables
end

-- Apply a simple rotation configuration
function SilentRotate:applyRotationConfiguration(rotationsTables)

    for key, rotationTable in pairs(rotationsTables) do

        local group = 'ROTATION'
        if (key == 'backup') then
            group = 'BACKUP'
        end

        for index, hunterName in pairs(rotationTable) do
            local hunter = SilentRotate:getHunter(hunterName)
            if (hunter) then
                SilentRotate:moveHunter(hunter, group, index)
            end
        end
    end
end

-- Display an alert and play a sound when the player should immediatly tranq
function SilentRotate:throwTranqAlert()
    RaidNotice_AddMessage(RaidWarningFrame, L['TRANQ_NOW_LOCAL_ALERT_MESSAGE'], ChatTypeInfo["RAID_WARNING"])

    if (SilentRotate.db.profile.enableTranqNowSound) then
        PlaySoundFile(SilentRotate.constants.sounds.alarms[SilentRotate.db.profile.tranqNowSound])
    end
end
