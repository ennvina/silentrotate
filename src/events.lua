local SilentRotate = select(2, ...)

local tranqShot = GetSpellInfo(19801)
local arcaneShot = GetSpellInfo(14287)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("UNIT_AURA")

eventFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if (event == "PLAYER_LOGIN") then
            SilentRotate:init()
            self:UnregisterEvent("PLAYER_LOGIN")

            -- Delayed raid update because raid data is unreliable at PLAYER_LOGIN
            C_Timer.After(5, function()
                SilentRotate:updateRaidStatus()
            end)
        else
            SilentRotate[event](SilentRotate, ...)
        end
    end
)

function SilentRotate:COMBAT_LOG_EVENT_UNFILTERED()

    -- @todo : Improve this with register / unregister event to save ressources
    -- Avoid parsing combat log when not able to use it
    if not SilentRotate.raidInitialized then return end
    -- Avoid parsing combat log when outside instance if test mode isn't enabled
    if not SilentRotate.testMode and not IsInInstance() then return end

    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

    -- @todo try to refactor a bit
    if SilentRotate:isTranqMode() then
        if (spellName == tranqShot or (SilentRotate.testMode and spellName == arcaneShot)) then
            local hunter = SilentRotate:getHunter(sourceGUID)
            if (event == "SPELL_CAST_SUCCESS") then
                SilentRotate:sendSyncTranq(hunter, false, timestamp)
                SilentRotate:rotate(hunter, false, nil, nil, nil, destGUID)
                if (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceTranqshotSuccessMessage, destName)
                end
            elseif (event == "SPELL_MISSED") then
                SilentRotate:sendSyncTranq(hunter, true, timestamp)
                SilentRotate:rotate(hunter, true, nil, nil, nil, destGUID)
                if (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceTranqshotFailMessage, destName)
                end
            end
        elseif (event == "SPELL_AURA_APPLIED" and SilentRotate:isBossFrenzy(spellName, sourceGUID) and SilentRotate:isPlayerNextTranq()) then
            SilentRotate:throwTranqAlert()
        elseif event == "UNIT_DIED" and SilentRotate:isTranqableBoss(destGUID) then
            SilentRotate:resetRotation()
        end
    elseif SilentRotate:isRazMode() then
        -- TODO
    elseif SilentRotate:isDistractMode() then
        if SilentRotate:isDistractSpell(spellName) then
            local hunter = SilentRotate:getHunter(sourceGUID)
            if (event == "SPELL_CAST_SUCCESS") then
                SilentRotate:sendSyncTranq(hunter, false, timestamp)
                SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate.testMode and destGUID or nil)
                if (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceDistractSuccessMessage)
                end
            elseif (event == "SPELL_MISSED") then
                SilentRotate:sendSyncTranq(hunter, true, timestamp)
                SilentRotate:rotate(hunter, true, nil, nil, nil, SilentRotate.testMode and destGUID or nil)
                if (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceDistractFailMessage)
                end
            end
        end
    elseif SilentRotate:isAoeTauntMode() then
        if SilentRotate:isAoeTauntSpell(spellName) then
            local hunter = SilentRotate:getHunter(sourceGUID)
            if (event == "SPELL_CAST_SUCCESS") then
                SilentRotate:sendSyncTranq(hunter, false, timestamp)
                SilentRotate:rotate(hunter, false, nil, nil, nil, SilentRotate.testMode and destGUID or nil, SilentRotate.testMode and spellName or nil)
                if (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceAoeTauntSuccessMessage)
                end
            elseif (event == "SPELL_MISSED") then
                SilentRotate:sendSyncTranq(hunter, true, timestamp)
                SilentRotate:rotate(hunter, true, nil, nil, nil, SilentRotate.testMode and destGUID or nil, SilentRotate.testMode and spellName or nil)
                if (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceAoeTauntFailMessage)
                end
            end
        end
    elseif SilentRotate:isFearWardMode() then
        if (event == "SPELL_CAST_SUCCESS" and SilentRotate:isFearWardSpell(spellName)) then
            local hunter = SilentRotate:getHunter(sourceGUID)
            SilentRotate:sendSyncTranq(hunter, false, timestamp)
            SilentRotate:rotate(hunter, false, nil, nil, nil, destGUID, spellName)
            if (sourceGUID == UnitGUID("player")) then
                SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceFearWardMessage, destName)
            end
        end
    elseif SilentRotate:isMisdiMode() then
        if (event == "SPELL_CAST_SUCCESS" and SilentRotate:isMisdiSpell(spellName)) then
            local hunter = SilentRotate:getHunter(sourceGUID)
            SilentRotate:sendSyncTranq(hunter, false, timestamp)
            SilentRotate:rotate(hunter, false, nil, nil, nil, destGUID, spellName)
            if (sourceGUID == UnitGUID("player")) then
                SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceMisdiMessage, destName)
            end
        end
    end
end

-- Raid group has changed
function SilentRotate:GROUP_ROSTER_UPDATE()
    SilentRotate:updateRaidStatus()
end

-- Player left combat
function SilentRotate:PLAYER_REGEN_ENABLED()
    SilentRotate:updateRaidStatus()
end

-- Player changed its main target
function SilentRotate:PLAYER_TARGET_CHANGED()
    if (SilentRotate.db.profile.showWindowWhenTargetingBoss) then
        if (SilentRotate:isTranqableBoss(UnitGUID("target")) and not UnitIsDead('target')) then
            SilentRotate.mainFrame:Show()
        end
    end
end

-- One of the auras of the unitID has changed (gained, faded)
function SilentRotate:UNIT_AURA(unitID, isEcho)

    -- UNIT_AURA is used exclusively to Loatheb
    if not SilentRotate:isLoathebMode() then return end

    -- Whether the unit really got the debuff or not, it's pointless if the unit is not tracked (e.g. not a healer)
    local hunter = SilentRotate:getHunter(UnitGUID(unitID))
    if not hunter then return end
    local previousExpirationTime = hunter.frame.cooldownFrame.statusBar.expirationTime

    if not isEcho then
        -- Try again in 1 second to secure lags between UNIT_AURA and the actual aura applied
        -- But set the isEcho flag so that the repetition will not be repeated over and over
        C_Timer.After(1, function()
            SilentRotate:UNIT_AURA(unitID, true)
        end)
    end

    -- Loop through the unit's debuffs to check if s/he is affected by Loatheb's Corrupted Mind
    local maxNbDebuffs = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and 16 or 40
    for i=1,maxNbDebuffs do
        local name, _,_,_,_, endTime ,_,_,_, spellId = UnitDebuff(unitID, i)
        if not name then
            -- name is not defined, meaning there is no other debuff left
            break
        end
        -- At this point:
        -- name and spellId correspond to the debuff at index i
        -- endTime knows exactly when the debuff ends if unitID is the player, i.e. if UnitIsUnit(unitID, "player")
        -- endTime is set to 0 is unitID is not the player ; this is a known limitation in WoW Classic that makes buff/debuff duration much harder to track
        if (SilentRotate:isLoathebDebuff(spellId) or (SilentRotate.testMode and spellId == 11196)) then -- 11196 is the spell ID of "Recently Bandaged"
            if (endTime and endTime > 0 and previousExpirationTime == endTime) then
                -- If the endTime matches exactly the previous expirationTime of the status bar, it means we are duplicating an already registered rotation
                return
            end
            if (previousExpirationTime and GetTime() < previousExpirationTime) then
                -- If the current time is before the previously seen expirationTime for this player, it means the debuff was already registered
                return
            end
            -- Send the rotate order, this is the most important part of the addon
            SilentRotate:rotate(hunter, false, nil, endTime)
            if (UnitIsUnit(unitID, "player")) then
                -- Announce to the channel selected in the addon options, but announce only ourselves
                SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceLoathebMessage, UnitName(unitID))
            end
            return
        end
    end

    -- The unit is not affected by Corrupted Mind: reset its expiration time
    if previousExpirationTime and previousExpirationTime > 0 then
        hunter.frame.cooldownFrame.statusBar.expirationTime = 0
    end
end

-- Register single unit events for a given hunter
function SilentRotate:registerUnitEvents(hunter)

    hunter.frame:RegisterUnitEvent("PARTY_MEMBER_DISABLE", hunter.name)
    hunter.frame:RegisterUnitEvent("PARTY_MEMBER_ENABLE", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_HEALTH", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_CONNECTION", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_FLAGS", hunter.name)

    hunter.frame:SetScript(
        "OnEvent",
        function(self, event, ...)
            SilentRotate:updateHunterStatus(hunter)
        end
    )

end

-- Unregister single unit events for a given hunter
function SilentRotate:unregisterUnitEvents(hunter)
    hunter.frame:UnregisterEvent("PARTY_MEMBER_DISABLE")
    hunter.frame:UnregisterEvent("PARTY_MEMBER_ENABLE")
    hunter.frame:UnregisterEvent("UNIT_HEALTH_FREQUENT")
    hunter.frame:UnregisterEvent("UNIT_CONNECTION")
    hunter.frame:UnregisterEvent("UNIT_FLAGS")
end
