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
-- * or "TANK" to select tanks, as designated by the raid roster info
-- * or "MANA" to select mana users (independently of their spec)
-- * or "REZ" to select classes who can resurrect
-- * ...or an array of strings to select multiple classes or roles
-- Either way, a submenu "Other players" will list remaining players
-- The filter is disabled in dungeons because a 5-player list is short enough
function SilentRotate:populateMenu(hunter, frame, mode)

    local assignTo = function(hunter, target)
        hunter.assignment = target
        -- @todo update hunter frame to display the new target
        -- @todo log assignment to the History window
        -- @todo share assignment with other raid members
        print(string.format("[%s] %s is assigned to %s", mode.modeNameFirstUpper, hunter.name, target or "<Nobody>"))
    end

    local menu = {
        { text = string.format("Assign %s to:", hunter.name), isTitle = true },
        { text = "<Nobody>", checked = not hunter.assignment, func = function() assignTo(hunter, nil) end }
    }

    -- @todo populate based on mode
    table.insert(menu, {
        text = WrapTextInColorCode("Option 1", select(4,GetClassColor("HUNTER"))),
        checked = false,
        func = function(item) print("You've chosen option 1"); end
        })
    table.insert(menu, {
        text = "Option 2",
        func = function() print("You've chosen option 2"); end
        })
    table.insert(menu, {
        text = "More Options",
        hasArrow = true,
            menuList = {
                { text = "Option 3", func = function() print("You've chosen option 3"); end }
            } 
        })

    table.insert(menu, {
        text = "Cancel",
        func = function() frame.context:Hide() end
        })

    return menu
end