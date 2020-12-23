local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Initialize GUI frames. Shouldn't be called more than once
function SilentRotate:initGui()

    SilentRotate:createMainFrame()
    SilentRotate:createTitleFrame()
    SilentRotate:createButtons()
    SilentRotate:createModeFrame()
    SilentRotate:createRotationFrame()
    SilentRotate:createBackupFrame()

    SilentRotate:drawHunterFrames()
    SilentRotate:createDropHintFrame()
    SilentRotate:createRulerFrame()

    SilentRotate:updateDisplay()
end

-- Show/Hide main window based on user settings
function SilentRotate:updateDisplay()

    if (SilentRotate:isInPveRaid()) then
        SilentRotate.mainFrame:Show()
    else
        if (SilentRotate.db.profile.hideNotInRaid) then
            SilentRotate.mainFrame:Hide()
        end
    end
end

-- render / re-render hunter frames to reflect table changes.
function SilentRotate:drawHunterFrames()

    -- Different height to reduce spacing between both groups
    SilentRotate.mainFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight + SilentRotate.constants.titleBarHeight)
    SilentRotate.mainFrame.rotationFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight)

    SilentRotate:drawList(SilentRotate.rotationTables.rotation, SilentRotate.mainFrame.rotationFrame)

    if (#SilentRotate.rotationTables.backup > 0) then
        SilentRotate.mainFrame:SetHeight(SilentRotate.mainFrame:GetHeight() + SilentRotate.constants.rotationFramesBaseHeight)
    end

    SilentRotate.mainFrame.backupFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight)
    SilentRotate:drawList(SilentRotate.rotationTables.backup, SilentRotate.mainFrame.backupFrame)

end

-- Handle the render of a single hunter frames group
function SilentRotate:drawList(hunterList, parentFrame)

    local index = 1
    local hunterFrameHeight = SilentRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = SilentRotate.constants.hunterFrameSpacing

    if (#hunterList < 1 and parentFrame == SilentRotate.mainFrame.backupFrame) then
        parentFrame:Hide()
    else
        parentFrame:Show()
    end

    for key,hunter in pairs(hunterList) do

        -- Using existing frame if possible
        if (hunter.frame == nil) then
            SilentRotate:createHunterFrame(hunter, parentFrame)
        else
            hunter.frame:SetParent(parentFrame)
        end

        hunter.frame:ClearAllPoints()
        hunter.frame:SetPoint('LEFT', 10, 0)
        hunter.frame:SetPoint('RIGHT', -10, 0)

        -- Setting top margin
        local marginTop = 10 + (index - 1) * (hunterFrameHeight + hunterFrameSpacing)
        hunter.frame:SetPoint('TOP', parentFrame, 'TOP', 0, -marginTop)

        -- Handling parent windows height increase
        if (index == 1) then
            parentFrame:SetHeight(parentFrame:GetHeight() + hunterFrameHeight)
            SilentRotate.mainFrame:SetHeight(SilentRotate.mainFrame:GetHeight() + hunterFrameHeight)
        else
            parentFrame:SetHeight(parentFrame:GetHeight() + hunterFrameHeight + hunterFrameSpacing)
            SilentRotate.mainFrame:SetHeight(SilentRotate.mainFrame:GetHeight() + hunterFrameHeight + hunterFrameSpacing)
        end

        -- SetColor
        SilentRotate:setHunterFrameColor(hunter)

        hunter.frame:Show()
        hunter.frame.hunter = hunter

        index = index + 1
    end
end

-- Hide the hunter frame
function SilentRotate:hideHunter(hunter)
    if (hunter.frame ~= nil) then
        hunter.frame:Hide()
    end
end

-- Refresh a single hunter frame
function SilentRotate:refreshHunterFrame(hunter)
    SilentRotate:setHunterFrameColor(hunter)
    SilentRotate:setHunterName(hunter)
end

-- Set the hunter frame color regarding it's status
function SilentRotate:setHunterFrameColor(hunter)

    local color = SilentRotate.colors.lightGray

    if (not SilentRotate:isHunterOnline(hunter)) then
        color = SilentRotate.colors.darkGray
    elseif (not SilentRotate:isHunterAlive(hunter)) then
        color = SilentRotate.colors.red
    elseif (hunter.nextTranq) then
        color = SilentRotate.colors.purple
    end

    hunter.frame.texture:SetVertexColor(color:GetRGB())
end

-- Set the hunter's name regarding its class and group index
function SilentRotate:setHunterName(hunter)

    local currentText = hunter.frame.text:GetText()
    local currentFont, _, currentOutline = hunter.frame.text:GetFont()

    local newText = hunter.name
    local newFont = SilentRotate:getPlayerNameFont()
    local newOutline = SilentRotate.db.profile.useNameOutline and "OUTLINE" or ""
    local hasClassColor = false
    local shadowOpacity = 1.0

    if (SilentRotate.db.profile.useClassColor) then
        local _, _classFilename, _ = UnitClass(hunter.name)
        if (_classFilename) then
            if (_classFilename == "PRIEST") then
                shadowOpacity = 1.0
            elseif (_classFilename == "ROGUE" or _classFilename == "PALADIN") then
                shadowOpacity = 0.8
            else
                shadowOpacity = 0.6
            end
            local _, _, _, _classColorHex = GetClassColor(_classFilename)
            newText = WrapTextInColorCode(hunter.name, _classColorHex)
            hasClassColor = true
        end
    end

    if (SilentRotate.db.profile.appendGroup and hunter.subgroup) then
        local groupText = string.format(SilentRotate.db.profile.groupSuffix, hunter.subgroup)
        local color = SilentRotate.colors.groupSuffix
        if (not color) then
print("groupSuffix color is created")
            -- Create the color based on profile
            -- This should happen once, at start
            color = CreateColor(
                SilentRotate.db.profile.groupSuffixColor[1],
                SilentRotate.db.profile.groupSuffixColor[2],
                SilentRotate.db.profile.groupSuffixColor[3]
            )
            SilentRotate.colors.groupSuffix = color
        end
        newText = newText.." "..color:WrapTextInColorCode(groupText)
    end

    if (newFont ~= currentFont or newOutline ~= currentOutline) then
print("Updating font of", hunter.name)
        hunter.frame.text:SetFont(newFont, 12, newOutline)
    end
    if (newText ~= currentText) then
print("Updating text of", hunter.name)
        hunter.frame.text:SetText(newText)
    end
    if (newText ~= currentText or newOutline ~= currentOutline) then
print("Updating shadow of", hunter.name)
        if (SilentRotate.db.profile.useNameOutline) then
            hunter.frame.text:SetShadowOffset(0, 0)
        else
            hunter.frame.text:SetShadowColor(0, 0, 0, shadowOpacity)
            hunter.frame.text:SetShadowOffset(1, -1)
        end
    end

end

function SilentRotate:startHunterCooldown(hunter, endTimeOfCooldown)
    if not endTimeOfCooldown or endTimeOfCooldown == 0 then
        local duration = 20
        if SilentRotate:IsLoathebMode() then
            duration = 60
        elseif SilentRotate:IsDistractMode() then
            duration = 30
        end
        endTimeOfCooldown = GetTime() + duration
    end

    hunter.frame.cooldownFrame.statusBar:SetMinMaxValues(GetTime(), endTimeOfCooldown)
    hunter.frame.cooldownFrame.statusBar.expirationTime = endTimeOfCooldown
    hunter.frame.cooldownFrame:Show()
end

-- Lock/Unlock the mainFrame position
function SilentRotate:lock(lock)
    SilentRotate.db.profile.lock = lock
    SilentRotate:applySettings()

    if (lock) then
        SilentRotate:printMessage(L['WINDOW_LOCKED'])
    else
        SilentRotate:printMessage(L['WINDOW_UNLOCKED'])
    end
end
