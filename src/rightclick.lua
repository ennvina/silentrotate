local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Enable/disable right click for all hunter frames
function SilentRotate:enableRightClick(assignable)
    for key,hunter in pairs(SilentRotate.hunterTable) do
        SilentRotate:enableHunterFrameRightClick(hunter, assignable)
    end
end

-- Enable or disable right click for one hunter frame
function SilentRotate:enableHunterFrameRightClick(hunter, assignable)
    hunter.assignable = assignable
    hunter.frame:EnableMouse(hunter.assignable or hunter.movable)
    if hunter.frame.context then
        -- Close any remaining context menu
        hunter.frame.context:Hide()
        hunter.frame.context = nil
    end
end

-- Configure hunter frame right click behavior
function SilentRotate:configureHunterFrameRightClick(hunter)
    hunter.frame:SetScript(
        "OnMouseUp",
        function(frame, button)
            if not frame.hunter.assignable then
                return
            end
            if button == "RightButton" then
                -- Create the context menu
                -- If already created, re-create it from scratch
                if frame.context then
                    frame.context:Hide()
                    frame.context = nil
                end
                frame.context = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
                local mode = SilentRotate:getMode() -- @toto get hunter mode
                local menu = SilentRotate:populateMenu(frame.hunter, frame, mode)
                EasyMenu(menu, frame.context, "cursor", 0 , 0, "MENU");
            end
        end
    )
end

-- Fill menu items, filtered by the value of mode.assignable:
-- * either a class name ("HUNTER", etc.) to list a specific class only
-- * or "TANK" to select tanks, as designated by raid roster info's main tank or main assist
-- * or "HEAL" to select classes that can heal (independently of their spec)
-- * or "MANA" to select mana users (independently of their spec)
-- * or "REZ" to select classes who can resurrect (including druids)
-- * ...or an array of strings to select multiple classes or roles
-- Either way, a submenu "Other players" will list remaining players
-- The filter is disabled in dungeons because a 5-player list is short enough
-- Besides, the raid roster info does not exist outside of raids
function SilentRotate:populateMenu(hunter, frame, mode)

    local mainCandidates = {}
    local otherCandidates = {}

    local isMain = function(classFilename, role, assignable)
        if assignable == 'TANK' then
            return role == 'MAINTANK' or role == 'MAINASSIST'
        elseif assignable == 'MANA' then
            return classFilename == 'MAGE'
                or classFilename == 'PRIEST'
                or classFilename == 'WARLOCK'
                or classFilename == 'DRUID'
                or classFilename == 'HUNTER'
                or classFilename == 'SHAMAN'
                or classFilename == 'PALADIN'
        elseif assignable == 'REZ' or assignable == 'HEAL' then
            return classFilename == 'PRIEST'
                or classFilename == 'DRUID'
                or classFilename == 'SHAMAN'
                or classFilename == 'PALADIN'
        else
            return classFilename == assignable
        end
    end

    local addCandidate = function(name, classFilename, role)
        local pushToMain = false

        if type(mode.assignable) == 'string' then
            pushToMain = isMain(classFilename, role, mode.assignable)
        elseif type(mode.assignable) == 'table' then
            for _, value in pairs(mode.assignable) do
                pushToMain = isMain(classFilename, role, value)
                if pushToMain then break end
            end
        end

        if pushToMain then
            table.insert(mainCandidates,  { name = name, classFilename = classFilename, role = role })
        else
            table.insert(otherCandidates, { name = name, classFilename = classFilename, role = role })
        end
    end

    local playerCount = GetNumGroupMembers()
    if playerCount > 0 then
        for index = 1, playerCount do
            local name, rank, subgroup, level, class, classFilename, zone, online, isDead, role, isML = GetRaidRosterInfo(index)
            if name then
                addCandidate(name, classFilename, role)
            end
        end
    else
        local name = UnitName("player")
        local classFilename = select(2,UnitClass("player"))
        addCandidate(name, classFilename, nil)
        for i = 1, 4 do
            local name = UnitName("party"..i)
            if name then
                classFilename = select(2,UnitClass("party"..i))
                addCandidate(name, classFilename, nil)
            end
        end
    end

    local assignTo = function(hunter, target, modeName)
        local mode = SilentRotate:getMode(modeName)
        if not mode.assignment then
            mode.assignment = {}
        end
        if mode.assignment[hunter.name] ~= target then
            mode.assignment[hunter.name] = target
            -- @todo update hunter frame to display the new target
            -- @todo log assignment to the History window
            -- @todo share assignment with other raid members
            print(string.format("[%s] %s is assigned to %s", mode.modeNameFirstUpper, hunter.name, target or "<Nobody>"))
        else
            print(string.format("[%s] %s is re-assigned to the same %s", mode.modeNameFirstUpper, hunter.name, target or "<Nobody>"))
        end
    end

    local menu = {
        { text = string.format(L["CONTEXT_ASSIGN_TITLE"], hunter.name), isTitle = true }
    }

    local assignmentFound = false
    local addMenuItem = function(menu, text, classFilename, assignment)
        local menuText = text
        if classFilename then
            menuText = WrapTextInColorCode(text, select(4,GetClassColor(classFilename)))
        end

        local isAssigned = mode.assignment and mode.assignment[hunter.name] == assignment

        table.insert(menu, {
            text = menuText,
            checked = isAssigned,
            func = function(item)
                assignTo(hunter, assignment, mode.modeName)
                if frame.context then frame.context:Hide() end
            end
        })

        if isAssigned then
            assignmentFound = true
        end
    end

    -- Always start with "Nobody", put into "<>" in case a raid member is called "Nobody"
    addMenuItem(menu, string.format("<%s>", L["CONTEXT_NOBODY"]), nil, nil)

    -- Add main candidates on top of the list (but after "Nobody")
    for _, candidate in ipairs(mainCandidates) do
        addMenuItem(menu, candidate.name, candidate.classFilename, candidate.name)
    end

    -- Then add other candidates, either as submenu (in raid) or main menu
    if IsInRaid() then
        local submenu = {}
        for _, candidate in ipairs(otherCandidates) do
            addMenuItem(submenu, candidate.name, candidate.classFilename, candidate.name)
        end
        if #submenu > 0 then
            table.insert(menu, {
                text = L["CONTEXT_OTHERS"],
                hasArrow = true,
                menuList = submenu
            })
        end
    else
        for _, candidate in ipairs(otherCandidates) do
            addMenuItem(menu, candidate.name, candidate.classFilename, candidate.name)
        end
    end

    -- If there is an assignment but it was not found among raid or party members, show it anyway
    -- It may happend if a raid member left the group
    if mode.assignment and mode.assignment[hunter.name] and not assignmentFound then
        addMenuItem(menu, mode.assignment[hunter.name], nil, mode.assignment[hunter.name])
    end

    -- Always end with "Cancel"
    table.insert(menu, {
        text = L["CONTEXT_CANCEL"],
        func = function() frame.context:Hide() end
    })

    return menu
end