local SilentRotate = select(2, ...)

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
-- * or "MANA" to select mana users (independently of their spec)
-- * or "REZ" to select classes who can resurrect
-- * ...or an array of strings to select multiple classes or roles
-- Either way, a submenu "Other players" will list remaining players
-- The filter is disabled in dungeons because a 5-player list is short enough
-- Besides, the raid roster info does not exist outside of raids
function SilentRotate:populateMenu(hunter, frame, mode)

    local mainCandidates = {}
    local otherCandidates = {}

    local addCandidate = function(name, classFilename, role)
        -- @todo push to mainCandidates or otherCandidates
        table.insert(mainCandidates, { name = name, classFilename = classFilename, role = role })
    end

    local playerCount = GetNumGroupMembers()
    if playerCount > 0 then
        for index = 1, playerCount, 1 do
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

    local assignTo = function(hunter, target)
        hunter.assignment = target
        -- @todo update hunter frame to display the new target
        -- @todo log assignment to the History window
        -- @todo share assignment with other raid members
        print(string.format("[%s] %s is assigned to %s", mode.modeNameFirstUpper, hunter.name, target or "<Nobody>"))
    end

    local menu = {
        { text = string.format("Assign %s to:", hunter.name), isTitle = true }
    }

    local addMenuItem = function(menu, text, classFilename, assignment)
        table.insert(menu, {
            text = classFilename and WrapTextInColorCode(text, select(4,GetClassColor(classFilename))) or text,
            checked = hunter.assignment == assignment,
            func = function(item) assignTo(hunter, assignment) end
        })
    end

    addMenuItem(menu, "<Nobody>", nil, nil)

    -- @todo populate based on mode
    for _, candidate in ipairs(mainCandidates) do
        addMenuItem(menu, candidate.name, candidate.classFilename, candidate.name)
    end
    if IsInRaid() then
        local submenu = {}
        for _, candidate in ipairs(otherCandidates) do
            addMenuItem(submenu, candidate.name, candidate.classFilename, candidate.name)
        end
        if #submenu > 0 then
            table.insert(menu, {
                text = "Other players",
                hasArrow = true,
                menuList = submenu
            })
        end
    else
        for _, candidate in ipairs(otherCandidates) do
            addMenuItem(menu, candidate.name, candidate.classFilename, candidate.name)
        end
    end

    table.insert(menu, {
        text = "Cancel",
        func = function() frame.context:Hide() end
    })

    return menu
end