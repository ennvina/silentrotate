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
        setHunterFrameColor(hunter)

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
    setHunterFrameColor(hunter)
end

-- Set the hunter frame color regarding it's status
function setHunterFrameColor(hunter)

    local color = SilentRotate.colors.green

    if (not SilentRotate:isHunterOnline(hunter)) then
        color = SilentRotate.colors.gray
    elseif (not SilentRotate:isHunterAlive(hunter)) then
        color = SilentRotate.colors.red
    elseif (hunter.nextTranq) then
        color = SilentRotate.colors.purple
    end

    hunter.frame.texture:SetVertexColor(color:GetRGB())
end

function SilentRotate:startHunterCooldown(hunter, endTimeOfCooldown)
    if not endTimeOfCooldown then
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
