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
    SilentRotate:updateBlindIcon(hunter)
end

-- Toggle blind icon display based on addonVersion
function SilentRotate:updateBlindIcon(hunter)
    if (
        not SilentRotate.db.profile.showBlindIcon or
        hunter.addonVersion ~= nil or
        hunter.name == UnitName('player') or
        not SilentRotate:isHunterOnline(hunter)
    ) then
        hunter.frame.blindIconFrame:Hide()
    else
        hunter.frame.blindIconFrame:Show()
    end
end

-- Refresh all blind icons
function SilentRotate:refreshBlindIcons()
    for _, hunter in pairs(SilentRotate.hunterTable) do
        SilentRotate:updateBlindIcon(hunter)
    end
end

-- Set the hunter frame color regarding it's status
function SilentRotate:setHunterFrameColor(hunter)

    local color = SilentRotate:getUserDefinedColor('neutral')

    if (not SilentRotate:isHunterOnline(hunter)) then
        color = SilentRotate:getUserDefinedColor('offline')
    elseif (not SilentRotate:isHunterAlive(hunter)) then
        color = SilentRotate:getUserDefinedColor('dead')
    elseif (hunter.nextTranq) then
        color = SilentRotate:getUserDefinedColor('active')
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

    if (SilentRotate.db.profile.prependIndex) then
        local rowIndex = 0
        local rotationTable = SilentRotate.rotationTables.rotation
        for index = 1, #rotationTable, 1 do
            local candidate = rotationTable[index]
            if (candidate ~= nil and candidate.name == hunter.name) then
                rowIndex = index
                break
            end
        end
        if (rowIndex > 0) then
            local indexText = string.format("%s.", rowIndex)
            local color = SilentRotate:getUserDefinedColor('indexPrefix')
            newText = color:WrapTextInColorCode(indexText)..newText
        end
    end

    local targetName
    local targetMode
    if SilentRotate.db.profile.appendTarget and hunter.targetGUID then
        targetName = select(6, GetPlayerInfoByGUID(hunter.targetGUID))
        if not hunter.buffName or hunter.buffName == "" or not hunter.endTimeOfEffect or hunter.endTimeOfEffect == 0 then
            targetMode = 'not_a_buff'
        elseif GetTime() > hunter.endTimeOfEffect  then
            targetMode = 'buff_expired'
        elseif not SilentRotate:findAura(targetName, hunter.buffName) then
            targetMode = 'buff_lost'
        else
            targetMode = 'has_buff'
        end
    end
    local showTarget = targetName and targetName ~= "" and targetMode and (targetMode == 'not_a_buff' or targetMode == 'has_buff' or not SilentRotate.db.profile.appendTargetBuffOnly)
    hunter.showingTarget = showTarget

    if (SilentRotate.db.profile.appendGroup and hunter.subgroup) then
        if not showTarget or not SilentRotate.db.profile.appendTargetNoGroup then -- Do not append the group if the target name hides the group for clarity
            local groupText = string.format(SilentRotate.db.profile.groupSuffix, hunter.subgroup)
            local color = SilentRotate:getUserDefinedColor('groupSuffix')
            newText = newText.." "..color:WrapTextInColorCode(groupText)
        end
    end

    if showTarget then
        newText = newText..SilentRotate.colors['white']:WrapTextInColorCode(">")
        local targetColorName
        if      targetMode == 'buff_expired' then   targetColorName = 'darkGray'
        elseif  targetMode == 'buff_lost' then      targetColorName = 'red'
        elseif  targetMode == 'has_buff' then       targetColorName = 'green'
        else                                        targetColorName = 'white'
        end
        newText = newText..SilentRotate.colors[targetColorName]:WrapTextInColorCode(targetName)
    end

    if (newFont ~= currentFont or newOutline ~= currentOutline) then
        hunter.frame.text:SetFont(newFont, 12, newOutline)
    end
    if (newText ~= currentText) then
        hunter.frame.text:SetText(newText)
    end
    if (newText ~= currentText or newOutline ~= currentOutline) then
        if (SilentRotate.db.profile.useNameOutline) then
            hunter.frame.text:SetShadowOffset(0, 0)
        else
            hunter.frame.text:SetShadowColor(0, 0, 0, shadowOpacity)
            hunter.frame.text:SetShadowOffset(1, -1)
        end
    end

end

function SilentRotate:startHunterCooldown(hunter, endTimeOfCooldown, endTimeOfEffect, targetGUID, buffName)
    if not endTimeOfCooldown or endTimeOfCooldown == 0 then
        local duration = SilentRotate:getModeDuration()
        endTimeOfCooldown = GetTime() + duration
    end

    if not endTimeOfEffect or endTimeOfEffect == 0 then
        local effectDuration = SilentRotate:getModeEffectDuration()
        if effectDuration then
            endTimeOfEffect = GetTime() + effectDuration
        else
            endTimeOfEffect = 0
        end
    end
    hunter.endTimeOfEffect = endTimeOfEffect

    hunter.frame.cooldownFrame.statusBar:SetMinMaxValues(GetTime(), endTimeOfCooldown)
    hunter.frame.cooldownFrame.statusBar.expirationTime = endTimeOfCooldown
    if endTimeOfCooldown and endTimeOfEffect and GetTime() < endTimeOfCooldown and GetTime() < endTimeOfEffect and endTimeOfEffect < endTimeOfCooldown then
        local tickWidth = 3
        local x = hunter.frame.cooldownFrame:GetWidth()*(endTimeOfEffect-GetTime())/(endTimeOfCooldown-GetTime())
        if x < 5 then
            -- If the tick is too early, it is graphically undistinguishable from the beginning of the cooldown bar, so don't bother displaying the tick
            hunter.frame.cooldownFrame.statusTick:Hide()
        else
            local xmin = x-tickWidth/2
            local xmax = xmin + tickWidth
            hunter.frame.cooldownFrame.statusTick:ClearAllPoints()
            hunter.frame.cooldownFrame.statusTick:SetPoint('TOPLEFT', xmin, 0)
            hunter.frame.cooldownFrame.statusTick:SetPoint('BOTTOMRIGHT', xmax-hunter.frame.cooldownFrame:GetWidth(), 0)
            hunter.frame.cooldownFrame.statusTick:Show()
        end
    else
        -- If there is no tick or the tick is beyond the cooldown bar, do not display the tick
        hunter.frame.cooldownFrame.statusTick:Hide()
    end
    hunter.frame.cooldownFrame:Show()

    hunter.targetGUID = targetGUID
    hunter.buffName = buffName
    if targetGUID and SilentRotate.db.profile.appendTarget then
        SilentRotate:setHunterName(hunter)
        if buffName and endTimeOfEffect > GetTime() then

            -- Create a ticker to refresh the name on a regular basis, for as long as the target name is displayed
            if not hunter.nameRefreshTicker or hunter.nameRefreshTicker:IsCancelled() then
                local nameRefreshInterval = 0.5
                hunter.nameRefreshTicker = C_Timer.NewTicker(nameRefreshInterval, function()
                    SilentRotate:setHunterName(hunter)
                    -- hunter.showingTarget is computed in the setHunterName() call; use this variable to tell when to stop refreshing
                    if not hunter.showingTarget then
                        hunter.nameRefreshTicker:Cancel()
                    end
                end)
            end

            -- Also create a timer that will be triggered shortly after the expiration time of the buff
            if hunter.nameRefreshTimer and not hunter.nameRefreshTimer:IsCancelled() then
                hunter.nameRefreshTimer:Cancel()
            end
            hunter.nameRefreshTimer = C_Timer.NewTimer(endTimeOfEffect - GetTime() + 1, function()
                SilentRotate:setHunterName(hunter)
            end)
        end
    else
        hunter.buffName = ""
        hunter.endTimeOfEffect = 0
        endTimeOfEffect = 0
    end
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
