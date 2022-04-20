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
                local mode = SilentRotate:getMode() -- @todo get hunter mode
                local menu = SilentRotate:populateMenu(frame.hunter, frame, mode)
                EasyMenu(menu, frame.context, "cursor", 0 , 0, "MENU");
            end
        end
    )
end

-- Check if a class/role fits a type of assignment
-- * either a class name ("HUNTER", etc.) to list a specific class only
-- * or "TANK" to select tanks, as designated by raid roster info's main tank or main assist
-- * or "HEAL" to select classes that can heal (independently of their spec)
-- * or "MANA" to select mana users (independently of their spec)
-- * or "REZ" to select classes who can resurrect (including druids)
-- * ...or an array of strings to select multiple classes or roles
function SilentRotate:doesPlayerFitAssignment(classFilename, role, assignmentType)
    if type(assignmentType) == 'table' then
        for _, subtype in ipairs(assignmentType) do
            if self:doesPlayerFitAssignment(classFilename, role, subtype) then
                return true
            end
        end
        return false
    end

    if assignmentType == 'TANK' then
        return role == 'MAINTANK' or role == 'MAINASSIST'
    elseif assignmentType == 'MANA' then
        return classFilename == 'MAGE'
            or classFilename == 'PRIEST'
            or classFilename == 'WARLOCK'
            or classFilename == 'DRUID'
            or classFilename == 'HUNTER'
            or classFilename == 'SHAMAN'
            or classFilename == 'PALADIN'
    elseif assignmentType == 'REZ' or assignmentType == 'HEAL' then
        return classFilename == 'PRIEST'
            or classFilename == 'DRUID'
            or classFilename == 'SHAMAN'
            or classFilename == 'PALADIN'
    elseif type(assignmentType) == 'string' then
        return classFilename == assignmentType
    end

    return false
end

-- Assign a player to another player for a specific mode
-- @param author The name of the player who initiates this assignment
-- @param actor  The name of the player who gets assigned
-- @param target The name of the player that the "actor" should focus on
-- @param modeName The mode for this assignment
-- @param time   When the assignment is done. If nil, GetTime() is used
-- The time is used to know detect false positives when blaming wrong targets
-- Otherwise if 1) player casts spell, 2) assignment changes, then we'd blame
function SilentRotate:assignPlayer(author, actor, target, modeName, timestamp)
    local mode = self:getMode(modeName)
    if not mode.assignment then
        mode.assignment = {}
        mode.assignedAt = {}
    end
    if mode.assignment[actor] ~= target then
        mode.assignment[actor] = target
        mode.assignedAt[actor] = timestamp or GetTime()

        -- Log to the History window
        local historyMessage
        if target then
            historyMessage = string.format(self:getHistoryPattern("HISTORY_ASSIGN_PLAYER"), author, actor, target)
        else
            historyMessage = string.format(self:getHistoryPattern("HISTORY_ASSIGN_NOBODY"), author, actor)
        end
        self:addHistoryMessage(historyMessage, mode)

        -- Update hunter frame to display the new target
        local hunter = self:getHunter(actor)
        if hunter then
            self:setHunterName(hunter)
        -- @todo else report an error
        end

        -- Share assignment with other raid members
        if author == UnitName("player") then
            self:sendSyncOrder()

            local questionTemplate = L["DIALOG_ASSIGNMENT_QUESTION1"].."\n\n"..L["DIALOG_ASSIGNMENT_QUESTION2"]
            local questionArgument = target
            if questionArgument then
                -- Add class color
                local _, _classFilename, _ = UnitClass(target)
                if _classFilename then
                    local _, _, _, _classColorHex = GetClassColor(_classFilename)
                    questionArgument = WrapTextInColorCode(target, _classColorHex)
                end
            else
                -- No target
                -- In practice, this code should not be used because the secure condition will return false
                questionArgument = L["CONTEXT_NOBODY"]
            end

            self:addSecureDialog("assignmentDialog",

                string.format(questionTemplate, questionArgument),

                L["DIALOG_ASSIGNMENT_CHANGE_FOCUS"],
                "focus",
                "unit",
                target,

                function()
                    -- Condition function, return true to open dialog box
                    local optionSuggestsToMatchFocus = SilentRotate.db.profile[modeName.."TrackFocus"]
                    local focusIsDifferentThanAssignment = UnitName("focus") ~= target
                    local hasSomeoneToFocus = target ~= nil -- Not interested in asking to "set focus to nobody"
                    return optionSuggestsToMatchFocus and focusIsDifferentThanAssignment and hasSomeoneToFocus
                end,

                "PLAYER_FOCUS_CHANGED",
                function()
                    -- Event function, return true to close dialog box
                    return UnitName("focus") == target
                end
            )
        end
    end
end

-- Get the map of actors and targets
-- key=actor, value=target
function SilentRotate:getAssignmentTable(modeName)
    local mode = self:getMode(modeName)

    if mode and mode.assignment then
        -- In its current state, mode.assignment is exactly what we're looking for
        return mode.assignment
    end

    return {}
end

-- Set the map of actors and targets
-- This function is called typically when receiving a sync order from another player
function SilentRotate:applyAssignmentConfiguration(assignment, sender, modeName)
    if not assignment then
        -- A nil assignment may happen especially if the sender has an old version
        -- Please note that an empty table {} will not return now
        -- An empty table is perfectly valid and will reset all assignments
        return
    end

    if sender == UnitName("player") then
        -- Prevent infinite loops
        return
    end

    local mode = self:getMode(modeName)

    -- First, unassign players who are not in the new list
    if mode.assignment then
        local actorsToReset = {}
        for actor, target in pairs(mode.assignment) do
            if target and not assignment[actor] then
                table.insert(actorsToReset, actor)
            end
        end
        for _, actor in ipairs(actorsToReset) do
            self:assignPlayer(sender, actor, nil, modeName)
        end
    end

    -- Then assign/re-assign players with the new ones
    for actor, target in pairs(assignment) do
        self:assignPlayer(sender, actor, target, modeName)
    end
end

-- Fill menu items, filtered by the value of mode.assignable:
-- - those who fit the class/role are "main players"
-- - those who don't are listed in a submenu "other players"
-- The "other players" is not a submenu in dungeons because a 5-player list is short enough
-- But they still are listed after the main players (i.e. main players appear on top)
function SilentRotate:populateMenu(hunter, frame, mode)

    local mainCandidates = {}
    local otherCandidates = {}

    local addCandidate = function(name, classFilename, role)
        if SilentRotate:doesPlayerFitAssignment(classFilename, role, mode.assignable) then
            table.insert(mainCandidates,  { name = name, classFilename = classFilename, role = role })
        else
            table.insert(otherCandidates, { name = name, classFilename = classFilename, role = role })
        end
    end

    -- Parse player list and put them either to the list of "main" candidates or "other" candidates
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

    local menu = {
        { text = string.format(L["CONTEXT_ASSIGN_TITLE"], hunter.name), isTitle = true }
    }

    local assignmentFound = false
    local addMenuItem = function(menu, text, classFilename, assignment)
        local menuText = text
        if classFilename then
            menuText = WrapTextInColorCode(text, select(4,GetClassColor(classFilename)))
        end

        local isAssigned
        if mode.assignment then
            isAssigned = mode.assignment[hunter.name] == assignment
        else
            isAssigned = assignment == nil
        end

        table.insert(menu, {
            text = menuText,
            checked = isAssigned,
            func = function(item)
                SilentRotate:assignPlayer(UnitName("player"), hunter.name, assignment, mode.modeName)
                if frame.context then frame.context:Hide() end
            end
        })

        if isAssigned then
            assignmentFound = true
        end
    end

    -- Always start with "Nobody", which is put into "<>" in case a raid member is actually called "Nobody"
    addMenuItem(menu, string.format("<%s>", L["CONTEXT_NOBODY"]), nil, nil)

    -- Add main candidates on top of the list (but after "<Nobody>")
    for _, candidate in ipairs(mainCandidates) do
        addMenuItem(menu, candidate.name, candidate.classFilename, candidate.name)
    end

    -- Then add other candidates, either as submenu (in raid) or main menu
    if IsInRaid() then
        local submenu = {}
        for _, candidate in ipairs(otherCandidates) do
            addMenuItem(submenu, candidate.name, candidate.classFilename, candidate.name)
        end
        if #submenu > 0 then -- Don't create the submenu if it is empty
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
    -- We could display "<Cancel>" to distinguish with a player called "Cancel"
    -- But everyone expects to see "Cancel" since the dawn of time, so we keep it
    -- Also, the "other players" submenu acts as a separator, which makes it less ambiguous
    table.insert(menu, {
        text = L["CONTEXT_CANCEL"],
        func = function() frame.context:Hide() end
    })

    return menu
end