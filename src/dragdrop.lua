local SilentRotate = select(2, ...)

-- Enable drag & drop for all hunter frames
function SilentRotate:enableListSorting()
    for key,hunter in pairs(SilentRotate.hunterTable) do
        SilentRotate:enableHunterFrameDragging(hunter, true)
    end
end

-- Enable or disable drag & drop for the hunter frame
function SilentRotate:enableHunterFrameDragging(hunter, movable)
    hunter.frame:EnableMouse(movable)
    hunter.frame:SetMovable(movable)
end

-- configure hunter frame drag behavior
function SilentRotate:configureHunterFrameDrag(hunter)

    hunter.frame:RegisterForDrag("LeftButton")
    hunter.frame:SetClampedToScreen(true)

    hunter.frame:SetScript(
        "OnDragStart",
        function()
            hunter.frame:StartMoving()
            hunter.frame:SetFrameStrata("HIGH")

            hunter.frame:SetScript(
                "OnUpdate",
                function ()
                    SilentRotate:setDropHintPosition(hunter.frame)
                end
            )

            SilentRotate.mainFrame.dropHintFrame:Show()
            SilentRotate.mainFrame.backupFrame:Show()
        end
    )

    hunter.frame:SetScript(
        "OnDragStop",
        function()
            hunter.frame:StopMovingOrSizing()
            hunter.frame:SetFrameStrata(SilentRotate.mainFrame:GetFrameStrata())
            SilentRotate.mainFrame.dropHintFrame:Hide()

            -- Removes the onUpdate event used for drag & drop
            hunter.frame:SetScript("OnUpdate", nil)

            if (#SilentRotate.rotationTables.backup < 1) then
                SilentRotate.mainFrame.backupFrame:Hide()
            end

            local group, position = SilentRotate:getDropPosition(hunter.frame)
            SilentRotate:handleDrop(hunter, group, position)
            SilentRotate:sendSyncOrder(false)
        end
    )
end

function SilentRotate:getDragFrameHeight(hunterFrame)
    return math.abs(hunterFrame:GetTop() - SilentRotate.mainFrame.rotationFrame:GetTop())
end

-- create and initialize the drop hint frame
function SilentRotate:createDropHintFrame()

    local hintFrame = CreateFrame("Frame", nil, SilentRotate.mainFrame.rotationFrame)

    hintFrame:SetPoint('TOP', SilentRotate.mainFrame.rotationFrame, 'TOP', 0, 0)
    hintFrame:SetHeight(SilentRotate.constants.hunterFrameHeight)
    hintFrame:SetWidth(SilentRotate.constants.mainFrameWidth - 10)

    hintFrame.texture = hintFrame:CreateTexture(nil, "BACKGROUND")
    hintFrame.texture:SetColorTexture(SilentRotate.colors.white:GetRGB())
    hintFrame.texture:SetAlpha(0.7)
    hintFrame.texture:SetPoint('LEFT')
    hintFrame.texture:SetPoint('RIGHT')
    hintFrame.texture:SetHeight(2)

    hintFrame:Hide()

    SilentRotate.mainFrame.dropHintFrame = hintFrame
end

-- Set the drop hint frame position to match dragged frame position
function SilentRotate:setDropHintPosition(hunterFrame)

    local hunterFrameHeight = SilentRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = SilentRotate.constants.hunterFrameSpacing
    local hintPosition = 0

    local group, position = SilentRotate:getDropPosition(hunterFrame)

    if (group == 'ROTATION') then
        if (position == 0) then
            hintPosition = -2
        else
            hintPosition = (position) * (hunterFrameHeight + hunterFrameSpacing) - hunterFrameSpacing / 2;
        end
    else
        hintPosition = SilentRotate.mainFrame.rotationFrame:GetHeight()

        if (position == 0) then
            hintPosition = hintPosition - 2
        else
            hintPosition = hintPosition + (position) * (hunterFrameHeight + hunterFrameSpacing) - hunterFrameSpacing / 2;
        end
    end

    SilentRotate.mainFrame.dropHintFrame:SetPoint('TOP', 0 , -hintPosition)
end

-- Compute drop group and position
function SilentRotate:getDropPosition(hunterFrame)

    local height = SilentRotate:getDragFrameHeight(hunterFrame)
    local group = 'ROTATION'
    local position = 0

    local hunterFrameHeight = SilentRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = SilentRotate.constants.hunterFrameSpacing

    -- Dragged frame is above rotation frames
    if (hunterFrame:GetTop() > SilentRotate.mainFrame.rotationFrame:GetTop()) then
        height = 0
    end

    position = floor(height / (hunterFrameHeight + hunterFrameSpacing))

    -- Dragged frame is bellow rotation frame
    if (height > SilentRotate.mainFrame.rotationFrame:GetHeight()) then

        group = 'BACKUP'

        -- Removing rotation frame size from calculation, using it's height as base hintPosition offset
        height = height - SilentRotate.mainFrame.rotationFrame:GetHeight()

        if (height > SilentRotate.mainFrame.backupFrame:GetHeight()) then
            -- Dragged frame is bellow backup frame
            position = #SilentRotate.rotationTables.backup
        else
            position = floor(height / (hunterFrameHeight + hunterFrameSpacing))
        end
    end

    return group, position
end

-- Compute the table final position from the drop position
function SilentRotate:handleDrop(hunter, group, position)

    local originTable = SilentRotate:getHunterRotationTable(hunter)
    local originIndex = SilentRotate:getHunterIndex(hunter, originTable)

    local destinationTable = SilentRotate.rotationTables.rotation
    local finalPosition = 1

    if (group == "BACKUP") then
        destinationTable = SilentRotate.rotationTables.backup
    end

    if (destinationTable == originTable) then

        if (position == originIndex or position == originIndex - 1 ) then
            finalPosition = originIndex
        else
            if (position > originIndex) then
                finalPosition = position
            else
                finalPosition = position + 1
            end
        end

    else
        finalPosition = position + 1
    end

    SilentRotate:moveHunter(hunter, group, finalPosition)
end
