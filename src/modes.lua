local Addon = select(1, ...)
local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Get the mode from a mode name
-- If modeName is nil, get the current mode
local function getMode(modeName)
    if not modeName then
        modeName = SilentRotate.db.profile.currentMode
    end

    if modeName and modeName:sub(-1) == 'z' then -- All old mode names end with 'z'
        modeName = SilentRotate.backwardCompatibilityModeMap[modeName]
    end

    -- return the mode object, or TranqShot as the default mode if no mode is set
    return SilentRotate.modes[modeName or SilentRotate.modes.tranqShot.modeName]
end

function SilentRotate:isTranqShotMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.tranqShot.modeName
end

function SilentRotate:isLoathebMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.loatheb.modeName
end

function SilentRotate:isDistractMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.distract.modeName
end

function SilentRotate:isFearWardMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.fearWard.modeName
end

function SilentRotate:isAoeTauntMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.aoeTaunt.modeName
end

function SilentRotate:isMisdiMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.misdi.modeName
end

function SilentRotate:isBloodlustMode(modeName)
    local mode = getMode(modeName)
    return mode and mode.modeName == SilentRotate.modes.bloodlust.modeName
end

-- Activate the specific mode
function SilentRotate:activateMode(modeName)
    local currentMode = getMode()
    local paramMode = getMode(modeName)
    if currentMode.modeName == paramMode.modeName then return end

    oldFrame = SilentRotate.mainFrame.modeFrames[currentMode.modeName]
    if oldFrame then
        oldFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end

    newFrame = SilentRotate.mainFrame.modeFrames[modeName]
    if newFrame then
        SilentRotate.db.profile.currentMode = modeName
        newFrame.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
        SilentRotate:updateRaidStatus()
        local AceConfigDialog = LibStub("AceConfigDialog-3.0")
        AceConfigDialog:ConfigTableChanged("", Addon)
    end
end

-- Return true if the player is recommended for a specific mode
-- If className is nil, the class is fetched from the unit
-- If mode is nil, use the current mode instead
function SilentRotate:isPlayerWanted(unit, className, modeName)
    if className == nil then
        className = (select(2,UnitClass(unit)))
    end

    local mode = getMode(modeName)
    if mode and mode.wanted then
        if type(mode.wanted) == 'string' then
            return className == mode.wanted
        elseif type(mode.wanted == 'function') then
            return mode.wanted(unit, className)
        end
    end

    return nil

    -- if SilentRotate:isLoathebMode(mode) then
    --     return className == 'PRIEST' or className == 'PALADIN' or className == 'SHAMAN' or className == 'DRUID'
    -- elseif SilentRotate:isDistractMode(mode) then
    --     return className == 'ROGUE'
    -- elseif SilentRotate:isFearWardMode(mode) then
    --     return className == 'PRIEST' and (select(2,UnitRace(unit)) == 'Dwarf' or WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC)
    -- elseif SilentRotate:isAoeTauntMode(mode) then
    --     return className == 'WARRIOR' or className == 'DRUID'
    -- elseif SilentRotate:isMisdiMode(mode) then
    --     return className == 'HUNTER'
    -- elseif SilentRotate:isBloodlustMode(mode) then
    --     return className == 'SHAMAN'
    -- end
    -- return className == 'HUNTER' -- hunter is the default mode
end

-- Get the default duration known for a specific mode
-- If mode is nil, use the current mode instead
function SilentRotate:getModeCooldown(modeName)
    local mode = getMode(modeName)

    if mode and mode.cooldown then
        if type(mode.cooldown) == 'number' then
            return mode.cooldown
        elseif type(mode.cooldown) == 'function' then
            return mode.cooldown()
        end
    end

    return nil
    -- local duration
    -- if SilentRotate:isTranqShotMode() then
    --     duration = 20 -- Cooldown of Hunter's Tranquilizing Shot
    -- elseif SilentRotate:isLoathebMode() then
    --     duration = 60 -- Corrupted Mind debuff that prevents healing spells
    -- elseif SilentRotate:isDistractMode() then
    --     duration = 30 -- Cooldown of Rogue's Distract
    -- elseif SilentRotate:isFearWardMode() then
    --     if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    --         duration = 30
    --     else
    --         duration = 180
    --     end
    -- elseif SilentRotate:isAoeTauntMode() then
    --     duration = 600 -- Cooldown of Warrior's Challenging Shout and Druid's Challenging Roar
    -- elseif SilentRotate:isMisdiMode() then
    --     duration = 120 -- Cooldown of Hunter's Misdirection
    -- elseif SilentRotate:isBloodlustMode() then
    --     duration = 600 -- Cooldown of Shaman's Bloodlust/Heroism
    -- else
    --     duration = 0 -- Duration should have no meaning for other modes
    -- end

    -- return duration
end

-- Get the default duration known for an effect (e.g. buff) given by a specific mode
-- If mode is nil, use the current mode instead
-- If the mode provides no effect, the returned duration is zero
function SilentRotate:getModeEffectDuration(modeName)
    local mode = getMode(modeName)

    if mode and mode.effectDuration then
        if type(mode.effectDuration) == 'number' then
            return mode.effectDuration
        elseif type(mode.effectDuration) == 'function' then
            return mode.effectDuration()
        end
    end

    return nil

    -- local duration
    -- if SilentRotate:isDistractMode() then
    --     duration = 10
    -- elseif SilentRotate:isFearWardMode() then
    --     if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    --         duration = 600
    --     else
    --         duration = 180
    --     end
    -- elseif SilentRotate:isAoeTauntMode() then
    --     duration = 6
    -- elseif SilentRotate:isMisdiMode() then
    --     duration = 30
    -- elseif SilentRotate:isBloodlustMode() then
    --     duration = 40
    -- else
    --     duration = 0 -- Other modes provide no specific buff/debuff
    -- end

    -- return duration
end

-- Each mode has a specific Broadcast text so that it does not conflict with other modes
function SilentRotate:getBroadcastHeaderText()
    local mode = getMode()

    if mode and type(mode.modeName) == 'string' then
        return L['BROADCAST_HEADER_TEXT_'..mode.modeNameUpper]
    end

    return ''
end