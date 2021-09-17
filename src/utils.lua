local SilentRotate = select(2, ...)

-- Check if a table contains the given element
function SilentRotate:tableContains(table, element)

    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end

    return false
end

-- Checks if a hunter is alive
function SilentRotate:isHunterAlive(hunter)
    return UnitIsFeignDeath(hunter.name) or not UnitIsDeadOrGhost(hunter.name)
end

-- Checks if a hunter is offline
function SilentRotate:isHunterOnline(hunter)
    return UnitIsConnected(hunter.name)
end

-- Checks if a hunter is online and alive
function SilentRotate:isHunterAliveAndOnline(hunter)
    return SilentRotate:isHunterOnline(hunter) and SilentRotate:isHunterAlive(hunter)
end

-- Checks if a hunter tranqshot is ready
function SilentRotate:isHunterTranqCooldownReady(hunter)
    return hunter.lastTranqTime <= GetTime() - 20
end

-- Checks if a hunter is elligible to tranq next
function SilentRotate:isEligibleForNextTranq(hunter)

    local isCooldownShortEnough = hunter.lastTranqTime <= GetTime() - SilentRotate.constants.minimumCooldownElapsedForEligibility

    return SilentRotate:isHunterAliveAndOnline(hunter) and isCooldownShortEnough
end

-- Checks if a hunter is in a battleground
function SilentRotate:isPlayerInBattleground()
    return UnitInBattleground('player') ~= nil
end

-- Checks if a hunter is in a PvE raid
function SilentRotate:isInPveRaid()
    return SilentRotate.testMode or IsInRaid() and not SilentRotate:isPlayerInBattleground()
end

function SilentRotate:getPlayerNameFont()
    if (GetLocale() == "zhCN" or GetLocale() == "zhTW") then
        return "Fonts\\ARHei.ttf"
    end

    return "Fonts\\ARIALN.ttf"
end

function SilentRotate:getIdFromGuid(guid)
    local type, _, _, _, _, mobId, _ = strsplit("-", guid or "")
    return type, tonumber(mobId)
end

-- Checks if the spell and the mob match a boss frenzy
function SilentRotate:isBossFrenzy(spellName, guid)

    local bosses = SilentRotate.constants.bosses
    local type, mobId = SilentRotate:getIdFromGuid(guid)

    if (type == "Creature") then
        for bossId, frenzy in pairs(bosses) do
            if (bossId == mobId and spellName == GetSpellInfo(frenzy)) then
                return true
            end
        end
    end

    return false
end

-- Checks if the mob is a tranq-able boss
function SilentRotate:isTranqableBoss(guid)

    local bosses = SilentRotate.constants.bosses
    local type, mobId = SilentRotate:getIdFromGuid(guid)

    if (type == "Creature") then
        for bossId, frenzy in pairs(bosses) do
            if (bossId == mobId) then
                return true
            end
        end
    end

    return false
end

-- Checks if the spell is a boss frenzy
function SilentRotate:isFrenzy(spellName)

    local bosses = SilentRotate.constants.bosses

    for bossId, frenzy in pairs(bosses) do
        if (spellName == GetSpellInfo(frenzy)) then
            return true
        end
    end

    return false
end

-- Checks if the spell is the Loatheb debuff
function SilentRotate:isLoathebDebuff(spellId)

    local ids = SilentRotate.constants.loatheb

    for _, id in ipairs(ids) do
        if (spellId == id) then
            return true
        end
    end

    return false
end

-- Checks if the spell is the Rogue Distract
function SilentRotate:isDistractSpell(spellName)
    return spellName == SilentRotate.constants.distract
end

-- Checks if the spell is the Priest Fear Ward
function SilentRotate:isFearWardSpell(spellName)
    return spellName == SilentRotate.constants.fearWard
end

-- Checks if the spell is the Hunter Misdirection
function SilentRotate:isMisdiSpell(spellName)
    return spellName == SilentRotate.constants.misdi
end

-- Checks if the spell is the Warrior Challenging Shout or Druid Challenging Road
function SilentRotate:isAoeTauntSpell(spellName)

    local names = SilentRotate.constants.aoeTaunt

    for _, name in ipairs(names) do
        if (spellName == name) then
            return true
        end
    end

    return false
end

-- Get a user-defined color or create it now
function SilentRotate:getUserDefinedColor(colorName)

    local color = SilentRotate.colors[colorName]

    if (not color) then
        -- Create the color based on profile
        -- This should happen once, at start
        local profileColorName
        if (colorName == "groupSuffix") then
            profileColorName = "groupSuffixColor"
        elseif (colorName == "indexPrefix") then
            profileColorName = "indexPrefixColor"
        else
            profileColorName = (colorName or "").."BackgroundColor"
        end

        if (SilentRotate.db.profile[profileColorName]) then
            color = CreateColor(
                SilentRotate.db.profile[profileColorName][1],
                SilentRotate.db.profile[profileColorName][2],
                SilentRotate.db.profile[profileColorName][3]
            )
        else
            print("[SilentRotate] Unknown color constant "..(colorName or "''"))
        end

        SilentRotate.colors[colorName] = color
    end

    return color
end
