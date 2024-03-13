local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Create main window
function SilentRotate:createMainFrame()
    local mainFrame = CreateFrame("Frame", 'mainFrame', UIParent)

    mainFrame:SetWidth(SilentRotate.db.profile.windows[1].width)
    mainFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight * 2 + SilentRotate.constants.titleBarHeight + SilentRotate.constants.modeBarHeight)
    mainFrame:Show()

    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetClampedToScreen(true)
    mainFrame:SetScript("OnDragStart", function() mainFrame:StartMoving() end)

    mainFrame.windowIndex = SilentRotate.mainFrames and #(SilentRotate.mainFrames)+1 or 1

    mainFrame:SetScript(
        "OnDragStop",
        function()
            mainFrame:StopMovingOrSizing()

            local config = SilentRotate.db.profile.windows[mainFrame.windowIndex]
            config.point = 'TOPLEFT'
            config.y = mainFrame:GetTop()
            config.x = mainFrame:GetLeft()
        end
    )

    if not SilentRotate.mainFrames then
        SilentRotate.mainFrames = { mainFrame }
    else
        table.insert(SilentRotate.mainFrames, mainFrame)
        SilentRotate.db.profile.windows[mainFrame.windowIndex] = SilentRotate.db.profile.windows[1]
    end

    return mainFrame
end

-- Create history window
function SilentRotate:createHistoryFrame()
    local historyFrame = CreateFrame("Frame", 'mainFrame', UIParent)

    historyFrame:SetWidth(SilentRotate.db.profile.history.width)
    historyFrame:SetHeight(SilentRotate.db.profile.history.height)
    historyFrame:Show()

    historyFrame:RegisterForDrag("LeftButton")
    historyFrame:SetClampedToScreen(true)
    historyFrame:SetScript("OnDragStart", function() historyFrame:StartMoving() end)

    historyFrame:SetScript(
        "OnDragStop",
        function()
            historyFrame:StopMovingOrSizing()

            local config = SilentRotate.db.profile
            config.history.point = 'TOPLEFT'
            config.history.y = historyFrame:GetTop()
            config.history.x = historyFrame:GetLeft()
        end
    )

    SilentRotate.historyFrame = historyFrame
    return historyFrame
end

-- Create Title frame
function SilentRotate:createTitleFrame(baseFrame, subtitle)
    local titleFrame = CreateFrame("Frame", 'rotationFrame', baseFrame)
    titleFrame:SetPoint('TOPLEFT')
    titleFrame:SetPoint('TOPRIGHT')
    titleFrame:SetHeight(SilentRotate.constants.titleBarHeight)

    titleFrame.texture = titleFrame:CreateTexture(nil, "BACKGROUND")
    titleFrame.texture:SetColorTexture(SilentRotate.colors.darkGreen:GetRGB())
    titleFrame.texture:SetAllPoints()

    titleFrame.text = titleFrame:CreateFontString(nil, "ARTWORK")
    titleFrame.text:SetFont("Fonts\\ARIALN.ttf", 12, "")
    titleFrame.text:SetShadowColor(0,0,0,0.5)
    titleFrame.text:SetShadowOffset(1,-1)
    titleFrame.text:SetPoint("LEFT",5,0)
    if subtitle then
        titleFrame.text:SetText(string.format('SilentRotate - %s', subtitle))
    else
        titleFrame.text:SetText('SilentRotate')
    end
    titleFrame.text:SetTextColor(1,1,1,1)

    baseFrame.titleFrame = titleFrame
    return titleFrame
end

-- Create resizer for width and height
function SilentRotate:createCornerResizer(baseFrame, windowConfig)
    baseFrame:SetResizable(true)

    local resizer = CreateFrame("Button", nil, baseFrame, "PanelResizeButtonTemplate")

    resizer:SetPoint("BOTTOMRIGHT")

    local minWidth = 200
    local minHeight = 50
    local maxWidth = 800
    local maxHeight = 1000
    resizer:Init(baseFrame, minWidth, minHeight, maxWidth, maxHeight)

    resizer:SetOnResizeStoppedCallback(function(frame)
        windowConfig.width = frame:GetWidth()
        windowConfig.height = frame:GetHeight()
    end)

    if not baseFrame.resizers then
        baseFrame.resizers = { ["BOTTOMRIGHT"] = resizer }
    else
        baseFrame.resizers["BOTTOMRIGHT"] = resizer
    end
    return resizer
end

-- Create resizers for width only
function SilentRotate:createHorizontalResizer(baseFrame, windowConfig, side, backgroundFrame, dynamicBottomBackgroundFrame)
    baseFrame:SetResizable(true)

    local resizer = CreateFrame("Frame", nil, baseFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
    resizer:SetFrameStrata("HIGH")

    resizer:SetPoint(side)

    resizer:SetWidth(8)

    resizer:SetPoint("TOP", backgroundFrame or baseFrame, "TOP")
    resizer:SetPoint("BOTTOM", backgroundFrame or baseFrame, "BOTTOM")

    -- Special case if there is the bottom point is attached to a frame which can be shown/hidden
    if dynamicBottomBackgroundFrame then
        if dynamicBottomBackgroundFrame:IsVisible() then
            resizer:SetPoint("BOTTOM", dynamicBottomBackgroundFrame, "BOTTOM")
        end
        if not baseFrame.resizers then
            -- Attach to visibility if not done yet
            -- It assumes horizontal resizers are only stacked between each other
            -- (see footnote at the end of this method)
            -- It also assumes all resizers of the same base attach to the same sub-frames
            dynamicBottomBackgroundFrame:SetScript("OnShow", function(frame)
                for _side, _frame in pairs(baseFrame.resizers) do
                    _frame:SetPoint("BOTTOM", dynamicBottomBackgroundFrame, "BOTTOM")
                end
            end)
            dynamicBottomBackgroundFrame:SetScript("OnHide", function(frame)
                for _side, _frame in pairs(baseFrame.resizers) do
                    _frame:SetPoint("BOTTOM", backgroundFrame, "BOTTOM")
                end
            end)
        end
    end

    resizer:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = nil,
        tile = true, tileSize = 16, edgeSize = 1,
        insets = { left = 3, right = 3, top = 5, bottom = 5 }
    })
    resizer:SetBackdropColor(1, 1, 1, 0)
    resizer:SetScript("OnEnter", function(frame)
        frame:SetBackdropColor(1, 1, 1, 0.8)
    end)
    resizer:SetScript("OnLeave", function(frame)
        frame:SetBackdropColor(1, 1, 1, 0)
    end)

    resizer:SetScript("OnMouseDown", function(frame)
        baseFrame:StartSizing(side)
    end)

    resizer:SetScript("OnMouseUp", function(frame)
        baseFrame:StopMovingOrSizing()

        windowConfig.x = baseFrame:GetLeft()
        windowConfig.width = baseFrame:GetWidth()
    end)

    if not baseFrame.resizers then
        local minWidth = 100
        local maxWidth = 500

        baseFrame:SetScript("OnSizeChanged", function(frame, width, height)
            -- Clamp width
            if width < minWidth then
                width = minWidth
                baseFrame:SetWidth(width)
            elseif width > maxWidth then
                width = maxWidth
                baseFrame:SetWidth(width)
            end

            -- Resize other UI elements which may depend on it
            if baseFrame.dropHintFrame then
                baseFrame.dropHintFrame:SetWidth(width - 10)
                -- Hack: we know mode frame settings must be re-applied when there is a drophint
                SilentRotate:applyModeFrameSettings(baseFrame, width)
            end
        end)

        baseFrame.resizers = { [side] = resizer }
    else
        -- No need to re-attach to baseFrame's OnSizeChanged if a resizer is already here
        -- Nonetheless, it assumes that horizontal resizers can be stacked between each other
        -- But horizontal resizers are not stacked with corner resizers
        baseFrame.resizers[side] = resizer
    end
    return resizer
end

-- Create title bar buttons for main frame
function SilentRotate:createMainFrameButtons(baseFrame)
    local buttons = {
        {
            texture = {
                normal = 'Interface/Buttons/UI-Panel-MinimizeButton-Up',
                pushed = 'Interface/Buttons/UI-Panel-MinimizeButton-Down',
                highlight = 'Interface/Buttons/UI-Panel-MinimizeButton-Highlight',
            },
            callback = SilentRotate.toggleDisplay,
            texCoord = {0.08, 0.9, 0.1, 0.9},
        },
        {
            texture = 'Interface/GossipFrame/BinderGossipIcon',
            callback = SilentRotate.toggleSettings,
            tooltip = L["BUTTON_SETTINGS"],
        },
        {
            texture = 'Interface/Buttons/UI-RefreshButton',
            callback = function()
                    SilentRotate:updateRaidStatus()
                    SilentRotate:resetRotation()
                    SilentRotate:sendSyncOrderRequest()
                end,
            tooltip = L["BUTTON_RESET_ROTATION"],
        },
        {
            texture = 'Interface/Buttons/UI-GuildButton-MOTD-Up',
            callback = SilentRotate.printRotationSetup,
            tooltip = L["BUTTON_PRINT_ROTATION"],
        },
        {
            texture = 'Interface/Buttons/UI-GuildButton-OfficerNote-Up',
            callback = SilentRotate.toggleHistory,
            tooltip = L["BUTTON_HISTORY"],
        },
    }

    return SilentRotate:createButtons(baseFrame, buttons)
end

-- Create title bar buttons for main frame
function SilentRotate:createHistoryFrameButtons(baseFrame)
    local buttons = {
        {
            texture = {
                normal = 'Interface/Buttons/UI-Panel-MinimizeButton-Up',
                pushed = 'Interface/Buttons/UI-Panel-MinimizeButton-Down',
                highlight = 'Interface/Buttons/UI-Panel-MinimizeButton-Highlight',
            },
            callback = SilentRotate.toggleHistory,
            texCoord = {0.08, 0.9, 0.1, 0.9},
        },
        {
            texture = 'Interface/GossipFrame/BinderGossipIcon',
            callback = SilentRotate.toggleSettings,
            tooltip = L["BUTTON_SETTINGS"],
        },
        {
            texture = 'Interface/Buttons/UI-RefreshButton',
            callback = SilentRotate.respawnHistory,
            tooltip = L["BUTTON_RESPAWN_HISTORY"],
        },
        {
            texture = {
                normal = 'Interface/Buttons/CancelButton-Up',
                pushed = 'Interface/Buttons/CancelButton-Down',
                highlight = 'Interface/Buttons/CancelButton-Highlight',
            },
            callback = SilentRotate.clearHistory,
            texCoord = {0.2, 0.8, 0.2, 0.8},
            tooltip = L["BUTTON_CLEAR_HISTORY"],
        },
    }

    return SilentRotate:createButtons(baseFrame, buttons)
end

-- Create title bar buttons
function SilentRotate:createButtons(baseFrame, buttons)
    local position = 5

    for key, button in pairs(buttons) do
        SilentRotate:createButton(baseFrame, position, button.texture, button.callback, button.texCoord, button.tooltip)
        position = position + 15
    end
end

-- Create a single button in the title bar
function SilentRotate:createButton(baseFrame, position, texture, callback, texCoord, tooltip)

    local button = CreateFrame("Button", nil, baseFrame)
    button:SetPoint('RIGHT', -position, 0)
    button:SetWidth(14)
    button:SetHeight(14)

    if type(texture) == 'string' then
        texture = {
            normal = texture,
            highlight = texture,
            pushed = texture,
        }
    end

    local normal = button:CreateTexture()
    normal:SetTexture(texture.normal)
    normal:SetAllPoints()
    button:SetNormalTexture(normal)

    local highlight = button:CreateTexture()
    highlight:SetTexture(texture.highlight)
    highlight:SetAllPoints()
    button:SetHighlightTexture(highlight)

    local pushed = button:CreateTexture()
    pushed:SetTexture(texture.pushed)
    pushed:SetAllPoints()
    button:SetPushedTexture(pushed)

    if (texCoord) then
        normal:SetTexCoord(unpack(texCoord))
        highlight:SetTexCoord(unpack(texCoord))
        pushed:SetTexCoord(unpack(texCoord))
    end

    button:SetScript("OnClick", callback)

    if tooltip then
        button:SetScript("OnEnter", function()
            GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
            GameTooltip_SetTitle(GameTooltip, tooltip)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return button
end

-- Create scroll frame with text button
function SilentRotate:createTextFrame(baseFrame)
    local constants = SilentRotate.constants.history
    local textFrame = CreateFrame("ScrollingMessageFrame", nil, baseFrame)

    local margin = constants.margin
    textFrame:SetPoint('BOTTOMLEFT', margin, margin)
    textFrame:SetPoint('TOPRIGHT', -margin, -margin)

    local fontFace = constants.fontFace
    local fontSize = constants.fontSize
    textFrame:SetFont(fontFace, fontSize, "")
    textFrame:SetTextColor(1,1,1,1)
    textFrame:SetShadowColor(0,0,0,1)
    textFrame:SetShadowOffset(1,-1)
    textFrame:SetJustifyH("LEFT")

    textFrame:SetTimeVisible(SilentRotate.constants.history.defaultTimeVisible)

    baseFrame.textFrame = textFrame
    return textFrame
end

-- Create Mode frame
function SilentRotate:createModeFrame(baseFrame)
    local modeFrame = CreateFrame("Frame", 'modeFrame', baseFrame)
    modeFrame:SetPoint('LEFT')
    modeFrame:SetPoint('RIGHT')
    modeFrame:SetPoint('TOP', 0, -SilentRotate.constants.titleBarHeight)
    modeFrame:SetHeight(SilentRotate.constants.modeBarHeight)

    modeFrame.texture = modeFrame:CreateTexture(nil, "BACKGROUND")
    modeFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    modeFrame.texture:SetAllPoints()

    baseFrame.modeFrame = modeFrame
    baseFrame.modeFrames = {}
    local commonModeWidth = SilentRotate.db.profile.windows[1].width/3
    local modeIndex = 0
    for modeName, mode in pairs(SilentRotate.modes) do
        SilentRotate:createSingleModeFrame(baseFrame, modeName, L["FILTER_SHOW_"..mode.modeNameUpper], modeIndex*commonModeWidth, (modeIndex+1)*commonModeWidth, SilentRotate.db.profile.currentMode == modeName)
        modeIndex = modeIndex+1
    end
    SilentRotate:applyModeFrameSettings(baseFrame)

    return modeFrame
end

-- Create single mode button
function SilentRotate:createSingleModeFrame(baseFrame, modeName, text, minX, maxX, enabled)
    local fontSize = SilentRotate.constants.modeFrameFontSize
    local margin = SilentRotate.constants.modeFrameMargin
    local modeFrame = CreateFrame("Frame", nil, baseFrame.modeFrame)
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
    modeFrame.text:SetFont("Fonts\\ARIALN.ttf", fontSize, "")
    modeFrame.text:SetShadowColor(0,0,0,0.5)
    modeFrame.text:SetShadowOffset(1,-1)
    modeFrame.text:SetPoint('TOPLEFT',1,-1)
    modeFrame.text:SetText(text)
    modeFrame.text:SetTextColor(1,1,1,1)

    -- Register the OnMouseDown event ; nb. the OnClick event is exclusive to Buttons (which we aren't)
    modeFrame:SetScript(
        "OnMouseDown",
        function()
            SilentRotate:activateMode(modeName, baseFrame)
            SilentRotate:updateRaidStatus()
            SilentRotate:resetRotation()
            SilentRotate:sendSyncOrderRequest()
        end
    )

    baseFrame.modeFrames[modeName] = modeFrame

    return modeFrame
end

-- Setup mode frame appearance, based on user-defined settings
function SilentRotate:applyModeFrameSettings(mainFrame, width)
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

    local modeFrameText = mainFrame.modeFrame and mainFrame.modeFrame.text
    if (nbButtonsVisible == 0) then
        -- Special case: no buttons visible
        if (not modeFrameText) then
            modeFrameText = mainFrame.modeFrame:CreateFontString(nil, "ARTWORK")
            modeFrameText:SetPoint("LEFT",2,0)
            modeFrameText:SetTextColor(1,1,1,1)
            modeFrameText:SetFont("Fonts\\ARIALN.ttf", 11, "")
            modeFrameText:SetShadowColor(0,0,0,0.5)
            modeFrameText:SetShadowOffset(1,-1)
            mainFrame.modeFrame.text = modeFrameText
        else
            modeFrameText:Show()
        end
        modeFrameText:SetText(L["NO_MODE_AVAILABLE"])
        for _, mapping in ipairs(modeFrameMapping) do
            local modeName = mapping.modeName
            mainFrame.modeFrames[modeName]:Hide()
        end
        return
    end

    if modeFrameText then
        modeFrameText:Hide()
    end

    local commonModeWidth = (width or SilentRotate.db.profile.windows[1].width)/nbButtonsVisible
    local minX = 0
    local maxX = commonModeWidth
    local fontSize = SilentRotate.constants.modeFrameFontSize
    local margin = SilentRotate.constants.modeFrameMargin

    for _, mapping in ipairs(modeFrameMapping) do
        local modeName = mapping.modeName
        local isVisible = SilentRotate.db.profile[mapping.visibilityFlag]
        local mode = mainFrame.modeFrames[modeName]
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

-- Create background frame
function SilentRotate:createBackgroundFrame(baseFrame, offsetY, height, noAnchorBottom, frameName)
    if not frameName then frameName = 'backgroundFrame' end

    local backgroundFrame = CreateFrame("Frame", frameName, baseFrame)
    backgroundFrame:SetPoint('LEFT')
    backgroundFrame:SetPoint('RIGHT')
    backgroundFrame:SetPoint('TOP', 0, -offsetY)
    if not noAnchorBottom then
        backgroundFrame:SetPoint('BOTTOM')
    end
    backgroundFrame:SetHeight(height-offsetY)

    backgroundFrame.texture = backgroundFrame:CreateTexture(nil, "BACKGROUND")
    backgroundFrame.texture:SetColorTexture(0,0,0,0.5)
    backgroundFrame.texture:SetAllPoints()

    baseFrame[frameName] = backgroundFrame
    return backgroundFrame
end

-- Create rotation frame
function SilentRotate:createRotationFrame(baseFrame)
    local offsetY = SilentRotate.constants.titleBarHeight+SilentRotate.constants.modeBarHeight
    local height = SilentRotate.constants.rotationFramesBaseHeight
    local noAnchorBottom = true
    return SilentRotate:createBackgroundFrame(baseFrame, offsetY, height, noAnchorBottom, 'rotationFrame')
end

-- Create backup frame
function SilentRotate:createBackupFrame(baseFrame, rotationFrame)
    -- Backup frame
    local backupFrame = CreateFrame("Frame", 'backupFrame', baseFrame)
    backupFrame:SetPoint('TOPLEFT', rotationFrame, 'BOTTOMLEFT', 0, 0)
    backupFrame:SetPoint('TOPRIGHT', rotationFrame, 'BOTTOMRIGHT', 0, 0)
    backupFrame:SetHeight(SilentRotate.constants.rotationFramesBaseHeight)

    -- Set Texture
    backupFrame.texture = backupFrame:CreateTexture(nil, "BACKGROUND")
    backupFrame.texture:SetColorTexture(0,0,0,0.5)
    backupFrame.texture:SetAllPoints()

    -- Visual separator
    backupFrame.texture = backupFrame:CreateTexture(nil, "BACKGROUND")
    backupFrame.texture:SetColorTexture(0.8,0.8,0.8,0.8)
    backupFrame.texture:SetHeight(1)
    backupFrame.texture:SetWidth(60)
    backupFrame.texture:SetPoint('TOP')

    baseFrame.backupFrame = backupFrame
    return backupFrame
end

-- Create single hunter frame
function SilentRotate:createHunterFrame(hunter, parentFrame, mainFrame)
    hunter.frame = CreateFrame("Frame", nil, parentFrame)
    hunter.frame:SetHeight(SilentRotate.constants.hunterFrameHeight)
    hunter.frame.GUID = hunter.GUID

    -- Set Texture
    hunter.frame.texture = hunter.frame:CreateTexture(nil, "ARTWORK")
    hunter.frame.texture:SetTexture("Interface\\AddOns\\SilentRotate\\textures\\steel.tga")
    hunter.frame.texture:SetAllPoints()

    -- Tooltip
    hunter.frame:SetScript("OnEnter", SilentRotate.onHunterEnter)
    hunter.frame:SetScript("OnLeave", SilentRotate.onHunterLeave)

    -- Set Text
    hunter.frame.text = hunter.frame:CreateFontString(nil, "ARTWORK")
    hunter.frame.text:SetPoint("LEFT",5,0)
    SilentRotate:setHunterName(hunter)

    SilentRotate:createCooldownFrame(hunter)
    SilentRotate:createBlindIconFrame(hunter)
    SilentRotate:configureHunterFrameDrag(hunter, mainFrame)
    SilentRotate:configureHunterFrameRightClick(hunter)

    if (SilentRotate.enableDrag) then
        SilentRotate:enableHunterFrameDragging(hunter, true)
    end
    local mode = SilentRotate:getMode() -- @todo get mode of hunter frame
    if mode and mode.assignable then
        SilentRotate:enableHunterFrameRightClick(hunter, true)
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

            local hunter = SilentRotate:getHunter(self:GetParent().GUID)
            if hunter and hunter.expirationTime and GetTime() > hunter.expirationTime then
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
function SilentRotate.onBlindIconEnter(frame)
    if (SilentRotate.db.profile.showBlindIconTooltip) then
        GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetText(L["TOOLTIP_PLAYER_WITHOUT_ADDON"])
        GameTooltip:AddLine(L["TOOLTIP_MAY_RUN_OUDATED_VERSION"])
        GameTooltip:AddLine(L["TOOLTIP_DISABLE_SETTINGS"])
        GameTooltip:Show()
    end
end

-- Blind icon tooltip hide
function SilentRotate.onBlindIconLeave(frame, motion)
    GameTooltip:Hide()
end

-- Hunter frame tooltip show
function SilentRotate.onHunterEnter(frame)
    local mode = SilentRotate:getMode()
    if mode and mode.tooltip then
        local tooltip
        if type(mode.tooltip) == 'string' then
            tooltip = mode.tooltip
        elseif type(mode.tooltip) == 'function' then
            local hunter = SilentRotate:getHunter(frame.GUID)
            tooltip = mode.tooltip(mode, hunter)
        end
        if tooltip then
            GameTooltip:SetOwner(frame, "ANCHOR_TOP")
            GameTooltip:SetText(tooltip)
            GameTooltip:Show()
        end

    else
        local hunter = SilentRotate:getHunter(frame.GUID)
        if hunter then
            local getAssignmentAndTarget = function(hunter)
                local assignmentText, targetText

                local assignment, _ = SilentRotate:getHunterAssignment(hunter)
                if assignment then
                    assignmentText = string.format(L['TOOLTIP_ASSIGNED_TO'], assignment)
                end

                local lastTarget, buffMode = SilentRotate:getHunterTarget(hunter)
                if lastTarget and lastTarget ~= '' and buffMode and buffMode ~= 'not_a_buff' then
                    if buffMode == 'has_buff' then
                        targetText = string.format(L['TOOLTIP_EFFECT_CURRENT'], lastTarget)
                    else
                        targetText = string.format(L['TOOLTIP_EFFECT_PAST'], lastTarget)
                    end
                end

                return assignmentText, targetText
            end

            if (hunter.endTimeOfEffect and GetTime() < hunter.endTimeOfEffect) or (hunter.expirationTime and GetTime() < hunter.expirationTime) then
                local tooltipRefreshFunc = function()
                    local effectRemaining = hunter and hunter.endTimeOfEffect-GetTime() or 0
                    local cooldownRemaining = hunter and hunter.expirationTime-GetTime() or 0

                    local assignmentText, targetText = getAssignmentAndTarget(hunter)

                    local text = ''
                    local appendText = function(newtext)
                        if text ~= '' then
                            text = text..'\n'
                        end
                        text = text..newtext
                    end
                    if assignmentText then
                        appendText(assignmentText)
                    end
                    if targetText then
                        appendText(targetText)
                    end

                    if effectRemaining > 0 or cooldownRemaining > 0 then
                        local hrEffect
                        if effectRemaining > 60 then
                            hrEffect = string.format(L['TOOLTIP_DURATION_MINUTES'], ceil(effectRemaining/60))
                        elseif effectRemaining > 0 then
                            hrEffect = string.format(L['TOOLTIP_DURATION_SECONDS'], ceil(effectRemaining))
                        end
                        if hrEffect then
                            -- The effect is not real if the buff was lost
                            local _, buffMode = SilentRotate:getHunterTarget(hunter)
                            if buffMode == 'buff_lost' then
                                local mode = SilentRotate:getMode() -- @todo get mode of hunter
                                if mode and not mode.buffCanReturn then
                                    hrEffect = nil
                                end
                            end
                        end

                        local hrCooldown
                        if cooldownRemaining > 60 then
                            hrCooldown = string.format(L['TOOLTIP_DURATION_MINUTES'], ceil(cooldownRemaining/60))
                        elseif cooldownRemaining > 0 then
                            hrCooldown = string.format(L['TOOLTIP_DURATION_SECONDS'], ceil(cooldownRemaining))
                        end

                        if hrEffect then
                            appendText(string.format(L['TOOLTIP_EFFECT_REMAINING'], hrEffect))
                        end
                        if hrCooldown then
                            appendText(string.format(L['TOOLTIP_COOLDOWN_REMAINING'], hrCooldown))
                        end 
                    end
                    if text ~= '' then
                        GameTooltip:SetText(text)
                    else
                        frame.tooltipRefreshTicker:Cancel()
                        frame.tooltipRefreshTicker = nil
                        GameTooltip:Hide()
                    end
                end

                if not frame.tooltipRefreshTicker or frame.tooltipRefreshTicker:IsCancelled() then
                    local refreshInterval = 0.5
                    frame.tooltipRefreshTicker = C_Timer.NewTicker(refreshInterval, tooltipRefreshFunc)
                end

                GameTooltip:SetOwner(frame, "ANCHOR_TOP")
                tooltipRefreshFunc()
                GameTooltip:Show()
            else
                local assignmentText, targetText = getAssignmentAndTarget(hunter)
                if assignmentText or targetText then
                    local text = ''
                    if not assignmentText then
                        text = targetText
                    elseif not targetText then
                        text = assignmentText
                    else
                        text = assignmentText..'\n'..targetText
                    end
                    GameTooltip:SetOwner(frame, "ANCHOR_TOP")
                    GameTooltip:SetText(text)
                    GameTooltip:Show()
                end
            end
        end
    end
end

-- Hunter frame tooltip hide
function SilentRotate.onHunterLeave(frame, motion)
    GameTooltip:Hide() -- @TODO hide only if it was shown
    if frame.tooltipRefreshTicker then
        frame.tooltipRefreshTicker:Cancel()
        frame.tooltipRefreshTicker = nil
    end
end
