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

    SilentRotate.mainFrame.modeFrames = { ["hunterz"] = nil, ["priestz"] = nil, ["healerz"] = nil, ["roguez"] = nil }
    local commonModeWidth = SilentRotate.constants.mainFrameWidth/4
    SilentRotate:createSingleModeFrame("hunterz", L["FILTER_SHOW_HUNTERS"], 0*commonModeWidth, 1*commonModeWidth, SilentRotate:isTranqMode())
    SilentRotate:createSingleModeFrame("healerz", L["FILTER_SHOW_HEALERS"], 1*commonModeWidth, 2*commonModeWidth, SilentRotate:isLoathebMode())
    SilentRotate:createSingleModeFrame("roguez",  L["FILTER_SHOW_ROGUES"] , 2*commonModeWidth, 3*commonModeWidth, SilentRotate:isDistractMode())
    SilentRotate:createSingleModeFrame("priestz", L["FILTER_SHOW_PRIESTS"], 3*commonModeWidth, 4*commonModeWidth, SilentRotate:isRazMode())
    SilentRotate:applyModeFrameSettings()
end

-- Create single mode button
function SilentRotate:createSingleModeFrame(name, text, minX, maxX, enabled)
    local fontSize = SilentRotate.constants.modeFrameFontSize
    local margin = SilentRotate.constants.modeFrameMargin
    local mode = CreateFrame("Frame", nil, SilentRotate.mainFrame.modeFrame)
    mode:SetPoint('TOPLEFT', minX+margin, -(SilentRotate.constants.modeBarHeight-2*margin-fontSize)/2)
    mode:SetWidth(maxX-minX-2*margin)
    mode:SetHeight(SilentRotate.constants.modeBarHeight-2*margin)

    -- Set Texture
    mode.texture = mode:CreateTexture(nil, "BACKGROUND")
    if enabled then
        mode.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
    else
        mode.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end
    mode.texture:SetAllPoints()

    -- Set Text
    mode.text = mode:CreateFontString(nil, "ARTWORK")
    mode.text:SetFont("Fonts\\ARIALN.ttf", fontSize)
    mode.text:SetShadowColor(0,0,0,0.5)
    mode.text:SetShadowOffset(1,-1)
    mode.text:SetPoint('TOPLEFT',1,-1)
    mode.text:SetText(text)
    mode.text:SetTextColor(1,1,1,1)

    -- Register the OnMouseDown event ; nb. the OnClick event is exclusive to Buttons (which we aren't)
    mode:SetScript(
        "OnMouseDown",
        function()
            SilentRotate:activateMode(name)
        end
    )

    SilentRotate.mainFrame.modeFrames[name] = mode
end

-- Setup mode frame appearance, based on user-defined settings
function SilentRotate:applyModeFrameSettings()
    local modeFrameMapping = {
        {
            modeName = "hunterz",
            visibilityFlag = "tranqModeButton",
            textVariable = "tranqModeText",
        },
        {
            modeName = "healerz",
            visibilityFlag = "loathebModeButton",
            textVariable = "loathebModeText",
        },
        {
            modeName = "roguez",
            visibilityFlag = "distractModeButton",
            textVariable = "distractModeText",
        },
        {
            modeName = "priestz",
            visibilityFlag = "razModeButton",
            textVariable = "razModeText",
        },
    }

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

    hunter.frame.cooldownFrame:Hide()
end