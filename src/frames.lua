local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Create main window
function SilentRotate:createMainFrame()
    SilentRotate.mainFrame = CreateFrame("Frame", 'mainFrame', UIParent)
    SilentRotate.mainFrame:SetWidth(SilentRotate.constants.mainFrameWidth)
    SilentRotate.mainFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight * 2 + SilentRotate.constants.titleBarHeight + SilentRotate.constants.modeBarHeight)
    SilentRotate.mainFrame:Show()

    SilentRotate.mainFrame:RegisterForDrag("LeftButton")
    SilentRotate.mainFrame:SetClampedToScreen(true)
    SilentRotate.mainFrame:SetScript("OnDragStart", function() SilentRotate.mainFrame:StartMoving() end)

    SilentRotate.mainFrame:SetScript(
        "OnDragStop",
        function()
            local config = SilentRotate.db.profile
            SilentRotate.mainFrame:StopMovingOrSizing()

            config.point = 'TOPLEFT'
            config.y = SilentRotate.mainFrame:GetTop()
            config.x = SilentRotate.mainFrame:GetLeft()
        end
    )
end

-- Create Title frame
function SilentRotate:createTitleFrame()
    SilentRotate.mainFrame.titleFrame = CreateFrame("Frame", 'rotationFrame', SilentRotate.mainFrame)
    SilentRotate.mainFrame.titleFrame:SetPoint('TOPLEFT')
    SilentRotate.mainFrame.titleFrame:SetPoint('TOPRIGHT')
    SilentRotate.mainFrame.titleFrame:SetHeight(SilentRotate.constants.titleBarHeight)

    SilentRotate.mainFrame.titleFrame.texture = SilentRotate.mainFrame.titleFrame:CreateTexture(nil, "BACKGROUND")
    SilentRotate.mainFrame.titleFrame.texture:SetColorTexture(SilentRotate.colors.darkGreen:GetRGB())
    SilentRotate.mainFrame.titleFrame.texture:SetAllPoints()

    SilentRotate.mainFrame.titleFrame.text = SilentRotate.mainFrame.titleFrame:CreateFontString(nil, "ARTWORK")
    SilentRotate.mainFrame.titleFrame.text:SetFont("Fonts\\ARIALN.ttf", 12)
    SilentRotate.mainFrame.titleFrame.text:SetShadowColor(0,0,0,0.5)
    SilentRotate.mainFrame.titleFrame.text:SetShadowOffset(1,-1)
    SilentRotate.mainFrame.titleFrame.text:SetPoint("LEFT",5,0)
    SilentRotate.mainFrame.titleFrame.text:SetText('SilentRotate')
    SilentRotate.mainFrame.titleFrame.text:SetTextColor(1,1,1,1)
end

-- Create title bar buttons
function SilentRotate:createButtons()

    local buttons = {
        {
            ['texture'] = 'Interface/Buttons/UI-Panel-MinimizeButton-Up',
            ['callback'] = SilentRotate.toggleDisplay,
            ['textCoord'] = {0.18, 0.8, 0.2, 0.8}
        },
        {
            ['texture'] = 'Interface/GossipFrame/BinderGossipIcon',
            ['callback'] = SilentRotate.openSettings
        },
        {
            ['texture'] = 'Interface/Buttons/UI-RefreshButton',
            ['callback'] = function()
                    SilentRotate:updateRaidStatus()
                    SilentRotate:resetRotation()
                    SilentRotate:sendSyncOrderRequest()
                end
        },
        {
            ['texture'] = 'Interface/Buttons/UI-GuildButton-MOTD-Up',
            ['callback'] = SilentRotate.printRotationSetup
        },
    }

    local position = 5

    for key, button in pairs(buttons) do
        SilentRotate:createButton(position, button.texture, button.callback, button.textCoord)
        position = position + 13
    end
end

-- Create a single button in the title bar
function SilentRotate:createButton(position, texture, callback, textCoord)

    local button = CreateFrame("Button", nil, SilentRotate.mainFrame.titleFrame)
    button:SetPoint('RIGHT', -position, 0)
    button:SetWidth(10)
    button:SetHeight(10)

    local normal = button:CreateTexture()
    normal:SetTexture(texture)
    normal:SetAllPoints()
    button:SetNormalTexture(normal)

    local highlight = button:CreateTexture()
    highlight:SetTexture(texture)
    highlight:SetAllPoints()
    button:SetHighlightTexture(highlight)

    if (textCoord) then
        normal:SetTexCoord(unpack(textCoord))
        highlight:SetTexCoord(unpack(textCoord))
    end

    button:SetScript("OnClick", callback)
end

-- Create Mode frame
function SilentRotate:createModeFrame()
    SilentRotate.mainFrame.modeFrame = CreateFrame("Frame", 'modeFrame', SilentRotate.mainFrame)
    SilentRotate.mainFrame.modeFrame:SetPoint('LEFT')
    SilentRotate.mainFrame.modeFrame:SetPoint('RIGHT')
    SilentRotate.mainFrame.modeFrame:SetPoint('TOP', 0, -SilentRotate.constants.titleBarHeight)
    SilentRotate.mainFrame.modeFrame:SetHeight(SilentRotate.constants.modeBarHeight)

    SilentRotate.mainFrame.modeFrame.texture = SilentRotate.mainFrame.modeFrame:CreateTexture(nil, "BACKGROUND")
    SilentRotate.mainFrame.modeFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    SilentRotate.mainFrame.modeFrame.texture:SetAllPoints()

    SilentRotate.mainFrame.modeFrames = {}
    local commonModeWidth = SilentRotate.constants.mainFrameWidth/3
    modeIndex = 0
    for modeName, mode in pairs(SilentRotate.modes) do
        SilentRotate:createSingleModeFrame(modeName, L["FILTER_SHOW_"..mode.modeNameUpper], modeIndex*commonModeWidth, (modeIndex+1)*commonModeWidth, SilentRotate.db.profile.currentMode == modeName)
        modeIndex = modeIndex+1
    end
    SilentRotate:applyModeFrameSettings()
end

-- Create single mode button
function SilentRotate:createSingleModeFrame(modeName, text, minX, maxX, enabled)
    local fontSize = SilentRotate.constants.modeFrameFontSize
    local margin = SilentRotate.constants.modeFrameMargin
    local modeFrame = CreateFrame("Frame", nil, SilentRotate.mainFrame.modeFrame)
    modeFrame:SetPoint('TOPLEFT', minX+margin, -(SilentRotate.constants.modeBarHeight-2*margin-fontSize)/2)
    modeFrame:SetWidth(maxX-minX-2*margin)
    modeFrame:SetHeight(SilentRotate.constants.modeBarHeight-2*margin)

    -- Set Texture
    modeFrame.texture = modeFrame:CreateTexture(nil, "BACKGROUND")
    if enabled then
        modeFrame.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
    else
        modeFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end
    modeFrame.texture:SetAllPoints()

    -- Set Text
    modeFrame.text = modeFrame:CreateFontString(nil, "ARTWORK")
    modeFrame.text:SetFont("Fonts\\ARIALN.ttf", fontSize)
    modeFrame.text:SetShadowColor(0,0,0,0.5)
    modeFrame.text:SetShadowOffset(1,-1)
    modeFrame.text:SetPoint('TOPLEFT',1,-1)
    modeFrame.text:SetText(text)
    modeFrame.text:SetTextColor(1,1,1,1)

    -- Register the OnMouseDown event ; nb. the OnClick event is exclusive to Buttons (which we aren't)
    modeFrame:SetScript(
        "OnMouseDown",
        function()
            SilentRotate:activateMode(modeName)
            SilentRotate:updateRaidStatus()
            SilentRotate:resetRotation()
            SilentRotate:sendSyncOrderRequest()
        end
    )

    SilentRotate.mainFrame.modeFrames[modeName] = modeFrame
end

-- Setup mode frame appearance, based on user-defined settings
function SilentRotate:applyModeFrameSettings()
    local modeFrameMapping = {}
    for modeName, mode in pairs(SilentRotate.modes) do
        table.insert(modeFrameMapping, {
            modeName = modeName,
            visibilityFlag = modeName.."ModeButton",
            textVariable = modeName.."ModeText",
        })
    end

    -- First, count how many buttons should be visible
    local nbButtonsVisible = 0
    for _, mapping in ipairs(modeFrameMapping) do
        local isVisible = SilentRotate.db.profile[mapping.visibilityFlag]
        if (isVisible) then nbButtonsVisible = nbButtonsVisible+1 end
    end

    if (nbButtonsVisible == 0) then
        -- Special case: no buttons visible
        if (not SilentRotate.mainFrame.modeFrame.text) then
            SilentRotate.mainFrame.modeFrame.text = SilentRotate.mainFrame.modeFrame:CreateFontString(nil, "ARTWORK")
            SilentRotate.mainFrame.modeFrame.text:SetPoint("LEFT",2,0)
            SilentRotate.mainFrame.modeFrame.text:SetTextColor(1,1,1,1)
            SilentRotate.mainFrame.modeFrame.text:SetFont("Fonts\\ARIALN.ttf", 11)
            SilentRotate.mainFrame.modeFrame.text:SetShadowColor(0,0,0,0.5)
            SilentRotate.mainFrame.modeFrame.text:SetShadowOffset(1,-1)
        else
            SilentRotate.mainFrame.modeFrame.text:Show()
        end
        SilentRotate.mainFrame.modeFrame.text:SetText(L["NO_MODE_AVAILABLE"])
        for _, mapping in ipairs(modeFrameMapping) do
            local modeName = mapping.modeName
            SilentRotate.mainFrame.modeFrames[modeName]:Hide()
        end
        return
    end

    if SilentRotate.mainFrame.modeFrame.text then
        SilentRotate.mainFrame.modeFrame.text:Hide()
    end

    local commonModeWidth = SilentRotate.constants.mainFrameWidth/nbButtonsVisible
    local minX = 0
    local maxX = commonModeWidth
    local fontSize = SilentRotate.constants.modeFrameFontSize
    local margin = SilentRotate.constants.modeFrameMargin

    for _, mapping in ipairs(modeFrameMapping) do
        local modeName = mapping.modeName
        local isVisible = SilentRotate.db.profile[mapping.visibilityFlag]
        local mode = SilentRotate.mainFrame.modeFrames[modeName]
        if (isVisible) then
            mode:Show()
            local text = SilentRotate.db.profile[mapping.textVariable]
            mode.text:SetText(text)
            mode:SetPoint('TOPLEFT', minX+margin, -(SilentRotate.constants.modeBarHeight-2*margin-fontSize)/2)
            mode:SetWidth(maxX-minX-2*margin)
            minX = maxX
            maxX = maxX + commonModeWidth
        else
            mode:Hide()
        end
    end
end

-- Create rotation frame
function SilentRotate:createRotationFrame()
    SilentRotate.mainFrame.rotationFrame = CreateFrame("Frame", 'rotationFrame', SilentRotate.mainFrame)
    SilentRotate.mainFrame.rotationFrame:SetPoint('LEFT')
    SilentRotate.mainFrame.rotationFrame:SetPoint('RIGHT')
    SilentRotate.mainFrame.rotationFrame:SetPoint('TOP', 0, -SilentRotate.constants.titleBarHeight-SilentRotate.constants.modeBarHeight)
    SilentRotate.mainFrame.rotationFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight)

    SilentRotate.mainFrame.rotationFrame.texture = SilentRotate.mainFrame.rotationFrame:CreateTexture(nil, "BACKGROUND")
    SilentRotate.mainFrame.rotationFrame.texture:SetColorTexture(0,0,0,0.5)
    SilentRotate.mainFrame.rotationFrame.texture:SetAllPoints()
end

-- Create backup frame
function SilentRotate:createBackupFrame()
    -- Backup frame
    SilentRotate.mainFrame.backupFrame = CreateFrame("Frame", 'backupFrame', SilentRotate.mainFrame)
    SilentRotate.mainFrame.backupFrame:SetPoint('TOPLEFT', SilentRotate.mainFrame.rotationFrame, 'BOTTOMLEFT', 0, 0)
    SilentRotate.mainFrame.backupFrame:SetPoint('TOPRIGHT', SilentRotate.mainFrame.rotationFrame, 'BOTTOMRIGHT', 0, 0)
    SilentRotate.mainFrame.backupFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight)

    -- Set Texture
    SilentRotate.mainFrame.backupFrame.texture = SilentRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    SilentRotate.mainFrame.backupFrame.texture:SetColorTexture(0,0,0,0.5)
    SilentRotate.mainFrame.backupFrame.texture:SetAllPoints()

    -- Visual separator
    SilentRotate.mainFrame.backupFrame.texture = SilentRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    SilentRotate.mainFrame.backupFrame.texture:SetColorTexture(0.8,0.8,0.8,0.8)
    SilentRotate.mainFrame.backupFrame.texture:SetHeight(1)
    SilentRotate.mainFrame.backupFrame.texture:SetWidth(60)
    SilentRotate.mainFrame.backupFrame.texture:SetPoint('TOP')
end

-- Create single hunter frame
function SilentRotate:createHunterFrame(hunter, parentFrame)
    hunter.frame = CreateFrame("Frame", nil, parentFrame)
    hunter.frame:SetHeight(SilentRotate.constants.hunterFrameHeight)

    -- Set Texture
    hunter.frame.texture = hunter.frame:CreateTexture(nil, "ARTWORK")
    hunter.frame.texture:SetTexture("Interface\\AddOns\\SilentRotate\\textures\\steel.tga")
    hunter.frame.texture:SetAllPoints()

    -- Set Text
    hunter.frame.text = hunter.frame:CreateFontString(nil, "ARTWORK")
    hunter.frame.text:SetPoint("LEFT",5,0)
    SilentRotate:setHunterName(hunter)

    SilentRotate:createCooldownFrame(hunter)
    SilentRotate:createBlindIconFrame(hunter)
    SilentRotate:configureHunterFrameDrag(hunter)

    if (SilentRotate.enableDrag) then
        SilentRotate:enableHunterFrameDragging(hunter, true)
    end
end

-- Create the cooldown frame
function SilentRotate:createCooldownFrame(hunter)

    -- Frame
    hunter.frame.cooldownFrame = CreateFrame("Frame", nil, hunter.frame)
    hunter.frame.cooldownFrame:SetPoint('LEFT', 5, 0)
    hunter.frame.cooldownFrame:SetPoint('RIGHT', -5, 0)
    hunter.frame.cooldownFrame:SetPoint('TOP', 0, -17)
    hunter.frame.cooldownFrame:SetHeight(3)

    -- background
    hunter.frame.cooldownFrame.background = hunter.frame.cooldownFrame:CreateTexture(nil, "ARTWORK")
    hunter.frame.cooldownFrame.background:SetColorTexture(0,0,0,1)
    hunter.frame.cooldownFrame.background:SetAllPoints()

    local statusBar = CreateFrame("StatusBar", nil, hunter.frame.cooldownFrame)
    statusBar:SetAllPoints()
    statusBar:SetMinMaxValues(0,1)
    statusBar:SetStatusBarTexture("Interface\\AddOns\\SilentRotate\\textures\\steel.tga")
    statusBar:GetStatusBarTexture():SetHorizTile(false)
    statusBar:GetStatusBarTexture():SetVertTile(false)
    statusBar:SetStatusBarColor(1, 0, 0)
    hunter.frame.cooldownFrame.statusBar = statusBar

    hunter.frame.cooldownFrame:SetScript(
        "OnUpdate",
        function(self, elapsed)
            self.statusBar:SetValue(GetTime())

            if (self.statusBar.expirationTime < GetTime()) then
                self:Hide()
            end
        end
    )

    local statusTick = hunter.frame.cooldownFrame:CreateTexture(nil, "OVERLAY")
    statusTick:SetColorTexture(1,0.8,0,1)
    statusTick:SetAllPoints()
    statusTick:Hide()
    hunter.frame.cooldownFrame.statusTick = statusTick

    hunter.frame.cooldownFrame:Hide()
end

-- Create the blind icon frame
function SilentRotate:createBlindIconFrame(hunter)

    -- Frame
    hunter.frame.blindIconFrame = CreateFrame("Frame", nil, hunter.frame)
    hunter.frame.blindIconFrame:SetPoint('RIGHT', -5, 0)
    hunter.frame.blindIconFrame:SetPoint('CENTER', 0, 0)
    hunter.frame.blindIconFrame:SetWidth(16)
    hunter.frame.blindIconFrame:SetHeight(16)

    -- Set Texture
    hunter.frame.blindIconFrame.texture = hunter.frame.blindIconFrame:CreateTexture(nil, "ARTWORK")
    local blind_filename = ""
--  local relativeHeight = GetScreenHeight()*UIParent:GetEffectiveScale()
    local relativeHeight = select(2,GetCurrentScaledResolution())*UIParent:GetEffectiveScale()
    if relativeHeight <= 1080 then
        blind_filename = "blind_32px.tga"
    else
        blind_filename = "blind_256px.tga"
    end
    hunter.frame.blindIconFrame.texture:SetTexture("Interface\\AddOns\\SilentRotate\\textures\\"..blind_filename)
    hunter.frame.blindIconFrame.texture:SetAllPoints()
--    hunter.frame.blindIconFrame.texture:SetTexCoord(0.15, 0.85, 0.15, 0.85);
    hunter.frame.blindIconFrame.texture:SetTexCoord(0, 1, 0, 1);

    -- Tooltip
    hunter.frame.blindIconFrame:SetScript("OnEnter", SilentRotate.onBlindIconEnter)
    hunter.frame.blindIconFrame:SetScript("OnLeave", SilentRotate.onBlindIconLeave)

    -- Drag & drop handlers
    hunter.frame.blindIconFrame:SetScript("OnDragStart", function(self, ...)
        ExecuteFrameScript(self:GetParent(), "OnDragStart", ...);
    end)
    hunter.frame.blindIconFrame:SetScript("OnDragStop", function(self, ...)
        ExecuteFrameScript(self:GetParent(), "OnDragStop", ...);
    end)

    hunter.frame.blindIconFrame:Hide()
end

-- Blind icon tooltip show
function SilentRotate:onBlindIconEnter()
    if (SilentRotate.db.profile.showBlindIconTooltip) then
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetText(L["TOOLTIP_PLAYER_WITHOUT_ADDON"])
        GameTooltip:AddLine(L["TOOLTIP_MAY_RUN_OUDATED_VERSION"])
        GameTooltip:AddLine(L["TOOLTIP_DISABLE_SETTINGS"])
        GameTooltip:Show()
    end
end

-- Blind icon tooltip hide
function SilentRotate:onBlindIconLeave(self, motion)
    GameTooltip:Hide()
end
