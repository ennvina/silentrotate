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
    if SilentRotate:IsTranqMode() then
        if (spellName == tranqShot or (SilentRotate.testMode and spellName == arcaneShot)) then
            local hunter = SilentRotate:getHunter(nil, sourceGUID)
            if (event == "SPELL_CAST_SUCCESS") then
                SilentRotate:sendSyncTranq(hunter, false, timestamp)
                SilentRotate:rotate(hunter, false)
                if  (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceSuccessMessage, destName)
                end
            elseif (event == "SPELL_MISSED") then
                SilentRotate:sendSyncTranq(hunter, true, timestamp)
                SilentRotate:rotate(hunter, true)
                if  (sourceGUID == UnitGUID("player")) then
                    SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceFailMessage, destName)
                end
            end
        elseif (event == "SPELL_AURA_APPLIED" and SilentRotate:isBossFrenzy(spellName, sourceGUID) and SilentRotate:isPlayerNextTranq()) then
            SilentRotate:throwTranqAlert()
        elseif event == "UNIT_DIED" and SilentRotate:isTranqableBoss(destGUID) then
            SilentRotate:resetRotation()
        end
    elseif SilentRotate:IsRazMode() then
        -- TODO
    elseif SilentRotate:IsDistractMode() then
        if (event == "SPELL_CAST_SUCCESS" and SilentRotate:isDistractSpell(spellName)) then
            local hunter = SilentRotate:getHunter(nil, sourceGUID)
            SilentRotate:rotate(hunter, false)
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
function SilentRotate:UNIT_AURA(unitID)
    -- UNIT_AURA is used exclusively for Loatheb
    if not SilentRotate:IsLoathebMode() then return end

    for i=1,16 do
        local name, _,_,_,_, endTime ,_,_,_, spellId = UnitDebuff(unitID, i)
        if not name then break end
        if (SilentRotate:isLoathebDebuff(spellId) or (SilentRotate.testMode and spellId == 11196)) then -- 11196 is the spell ID of "Recently Bandaged"
            local hunter = SilentRotate:getHunter(nil, UnitGUID(unitID))
            if (hunter.frame.cooldownFrame.statusBar.expirationTime == endTime) then
                -- If the endTime matches exactly the expirationTime of the status bar, it means we are duplicating an already registered rotation
                break
            end
            SilentRotate:rotate(hunter, false, nil, endTime)
            if (UnitIsUnit(unitID, "player")) then
                SilentRotate:sendAnnounceMessage(SilentRotate.db.profile.announceLoathebMessage, UnitName(unitID))
            end
            break
        end
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
