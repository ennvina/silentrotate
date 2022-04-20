local SilentRotate = select(2, ...)

-- Call secure function, if possible now
-- Otherwise queue it for next time player goes out of combat
--
-- @param secFunc Secure function to call
-- @param secFuncName (optional) Unique name of the secure function to queue
--
-- The unique name is used to overwrite a secure function to avoid calling
-- secure functions that conflict with each other
function SilentRotate:addSecureFunction(secFunc, secFuncName)
    if not InCombatLockdown() then
        secFunc()
        return
    end

    if self.secureFunctions == nil then
        self.secureFunctions = {}
    end

    if secFuncName then
        self.secureFunctions[secFuncName] = secFunc
    else
        table.insert(self.secureFunctions, secFunc)
    end
end

-- Call all queued secure functions
-- The queue is emptied afterwards
-- Nothing is done if player is in combat
function SilentRotate:callAllSecureFunctions()
    if type(self.secureFunctions) == 'table' and (not InCombatLockdown()) then
        for _, secFunc in pairs(self.secureFunctions) do
            secFunc()
        end
        self.secureFunctions = nil
    end
end

--[[
    Add a secure function that creates a dialog box with one "question" and two buttons

    The question is displayed in the central part of the dialog box
    The question usually ends with a question mark (?) but any text that invites the player to click is okay

    The first button answer and secure params of the secure action button
    A list of types and attribute names can be found here:
    https://wowpedia.org/wiki/SecureActionButtonTemplate#Action_types

    The second button is always "Close"

    Usually, the dialog box should be closed after clicking the first button
    The trivial solution would be to set a "onClick" script to close it
    But it's not really possible with secure action buttons
    More exactly, if we set this script we override the secure action itself

    One way to circumvent this limitation is to track an event with a callback
    The callback inspects the current state of the game, and returns true when the secure action has finished
    For example, if the secure type is "target":
    - the tracked event name could be "PLAYER_TARGET_CHANGED"
    - and the event callback could be function() return UnitName("target") == myNewFavoriteTarget end

    @param widgetName unique name of the widget, so that the same dialog does not stack twice

    @param question Text which invites the user to click the first button

    @param answer Text of the first button; should be as concise as possible
    @param secureType Type of the secure button e.g., "target" or "macro"
    @param secureAttr Attribute name of the action e.g., "unit" or "macrotext"
    @param secureValue Value of the secure attribute e.g., "targettarget" or "/dismount"

    @param condition (optional) Test function that opens the dialog box or not; by default the dialog is always open

    @param eventName (optional) Name of an event to track
    @param eventFunc (optional) Callback to invoke for the tracked event; if it returns true, the dialog is closed
]]

function SilentRotate:addSecureDialog(
    widgetName,
    question,
    answer, secureType, secureAttr, secureValue,
    condition,
    eventName, eventFunc
)
    self:addSecureFunction(function()
        if type(condition) == 'function' then
            if not condition() then
                -- Hide the previous dialog box with the same name, if any
                if type(self.secureDialogs) == 'table' and self.secureDialogs[widgetName] then
                    self.secureDialogs[widgetName].closeFunc()
                    self.secureDialogs[widgetName] = nil -- Useless in theory, because done by closeFunc()
                end

                return
            end
        end

        local spacing = 24
        local buttonWidth = 128
        local buttonHeight = 21

        -- Main frame of the dialog
        local dialogFrame = CreateFrame("Frame", widgetName.."_dialogFrame", UIParent)
        dialogFrame:Hide()
        dialogFrame:SetFrameStrata("DIALOG")
        dialogFrame:SetPoint("CENTER", UIParent, "CENTER", 0, UIParent:GetHeight()/4)
        dialogFrame:SetSize(444, 120)
        -- Add background
        local dialogBorder = CreateFrame("Frame", nil, dialogFrame, "DialogBorderOpaqueTemplate")
        dialogBorder:SetAllPoints(dialogFrame)
        dialogFrame.dialogBorder = dialogBorder
        dialogFrame:SetFixedFrameStrata(true)
        dialogFrame:SetFixedFrameLevel(true)
        -- Make the dialog movable on left click, clamped to screen
        dialogFrame:EnableMouse(true)
        dialogFrame:SetMovable(true)
        dialogFrame:SetClampedToScreen(true)
        dialogFrame:RegisterForDrag("LeftButton")
        dialogFrame:SetScript("OnDragStart", function() dialogFrame:StartMoving() end)
        dialogFrame:SetScript("OnDragStop",  function() dialogFrame:StopMovingOrSizing() end)

        -- Central text
        local centralText = dialogFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        centralText:SetSize(290, 0)
        centralText:SetPoint("TOP", 0, -spacing)
        centralText:SetText(question)
        dialogFrame.centralText = centralText

        -- First button
        local firstButton = CreateFrame("Button", widgetName.."_firstButton", dialogFrame, "SecureActionButtonTemplate")
        firstButton:SetPoint("BOTTOMRIGHT", dialogFrame, "BOTTOM", -spacing, spacing)
        firstButton:SetSize(buttonWidth, buttonHeight)
        firstButton:SetNormalFontObject(GameFontNormal)
        firstButton:SetHighlightFontObject(GameFontHighlight)
        firstButton:SetNormalTexture(130763) -- "Interface\\Buttons\\UI-DialogBox-Button-Up"
        firstButton:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
        firstButton:SetPushedTexture(130761) -- "Interface\\Buttons\\UI-DialogBox-Button-Down"
        firstButton:GetPushedTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
        firstButton:SetHighlightTexture(130762) -- "Interface\\Buttons\\UI-DialogBox-Button-Highlight"
        firstButton:GetHighlightTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
        firstButton:SetText(answer)
        -- Set secure action
        firstButton:SetAttribute("type", secureType)
        firstButton:SetAttribute(secureAttr, secureValue)
        dialogFrame.firstButton = firstButton

        -- Second button
        local secondButton = CreateFrame("Button", widgetName.."_firstButton", dialogFrame)
        secondButton:SetPoint("BOTTOMLEFT", dialogFrame, "BOTTOM", spacing, spacing)
        secondButton:SetSize(buttonWidth, buttonHeight)
        secondButton:SetNormalFontObject(GameFontNormal)
        secondButton:SetHighlightFontObject(GameFontHighlight)
        secondButton:SetNormalTexture(130763) -- "Interface\\Buttons\\UI-DialogBox-Button-Up"
        secondButton:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
        secondButton:SetPushedTexture(130761) -- "Interface\\Buttons\\UI-DialogBox-Button-Down"
        secondButton:GetPushedTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
        secondButton:SetHighlightTexture(130762) -- "Interface\\Buttons\\UI-DialogBox-Button-Highlight"
        secondButton:GetHighlightTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
        secondButton:SetText(CLOSE)
        dialogFrame.secondButton = secondButton

        -- Add a "fade from white" animation to insist that the dialog box just appeared
        -- It is especially useful when there are multiple assignments in a row, telling the player:
        -- "Hey, maybe you didn't see it because the dialog didn't change much, but there's something new to check"
        local fadeDuration = 0.4
        local fadeFromWhite = function(frame, inset)
            local fadeFromWhiteFrame = frame:CreateTexture(nil, "OVERLAY")
            fadeFromWhiteFrame:SetPoint("BOTTOMLEFT", inset, inset)
            fadeFromWhiteFrame:SetPoint("TOPRIGHT", -inset, -inset)
            fadeFromWhiteFrame:SetColorTexture(1,1,1)
            fadeFromWhiteFrame:SetAlpha(0)
            local fader = fadeFromWhiteFrame:CreateAnimationGroup()
            local anim = fader:CreateAnimation("Alpha")
            anim:SetDuration(fadeDuration)
            anim:SetFromAlpha(0.8)
            anim:SetToAlpha(0)
            return fader
        end
        dialogFrame.faders = {
            fadeFromWhite(dialogFrame, 11),
            fadeFromWhite(firstButton, 3),
            fadeFromWhite(secondButton, 3)
        }

        local closeFunc = function()
            dialogFrame:Hide()
            if type(eventName) == 'string' then
                dialogFrame:UnregisterEvent(eventName)
                dialogFrame:SetScript("OnEvent", nil)
            end
            if self.secureDialogs[widgetName] == dialogFrame then
                self.secureDialogs[widgetName] = nil
            end
        end
        dialogFrame.closeFunc = closeFunc

        -- Store the dialog frame, and destroy any previous dialog with the same name but keep its position
        if type(self.secureDialogs) == 'table' then
            if self.secureDialogs[widgetName] then
                dialogFrame:SetPoint(
                    "BOTTOMLEFT",
                    self.secureDialogs[widgetName]:GetLeft(),
                    self.secureDialogs[widgetName]:GetTop()-self.secureDialogs[widgetName]:GetHeight()
                )
                self.secureDialogs[widgetName].closeFunc()
                self.secureDialogs[widgetName] = nil -- Useless in theory, because done by closeFunc()
            end
        else
            self.secureDialogs = {}
        end
        self.secureDialogs[widgetName] = dialogFrame

        -- Close button simply closes dialog box
        secondButton:SetScript("OnClick", closeFunc)

        -- If an event must be tracked, track it
        if type(eventName) == 'string' and type(eventFunc) == 'function' then
            dialogFrame:RegisterEvent(eventName)
            dialogFrame:SetScript(
                "OnEvent",
                function(self, event, ...)
                    if eventFunc(...) then
                        dialogFrame:UnregisterEvent(eventName)
                        closeFunc()
                    end
                end
            )
        end

        -- When everything is set, show the dialog box and start the fade from white
        dialogFrame:Show()
        for _, fader in ipairs(dialogFrame.faders) do
            fader:Play()
        end

    end,
    widgetName.."_function")
end
