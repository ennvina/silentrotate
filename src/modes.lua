local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Is Tranqshot Mode? (default mode)
function SilentRotate:IsTranqMode()
    return not SilentRotate:IsRazMode() and not SilentRotate:IsLoathebMode() and not SilentRotate:IsDistractMode()
end

function SilentRotate:IsRazMode()
    return SilentRotate.currentMode == 'priestz'
end

function SilentRotate:IsLoathebMode()
    return SilentRotate.currentMode == 'healerz'
end

function SilentRotate:IsDistractMode()
    return SilentRotate.currentMode == 'roguez'
end

-- Activate the specific mode
function SilentRotate:activateMode(modeName)
    if modeName == SilentRotate.currentMode then return end

    oldFrame = SilentRotate.mainFrame.modeFrames[SilentRotate.currentMode]
    if oldFrame then
        oldFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end

    newFrame = SilentRotate.mainFrame.modeFrames[modeName]
    if newFrame then
        SilentRotate.currentMode = modeName
        newFrame.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
        SilentRotate:updateRaidStatus()
    end
end

function SilentRotate:IsClassWanted(className)
    if SilentRotate:IsRazMode() then
        return className == 'PRIEST'
    elseif SilentRotate:IsLoathebMode() then
        return className == 'PRIEST' or className == 'PALADIN' or className == 'SHAMAN' or className == 'DRUID'
    elseif SilentRotate:IsDistractMode() then
        return className == 'ROGUE'
    end
    return className == 'HUNTER' -- hunter is the default mode
end

function SilentRotate:GetBroadcastHeaderText()
    if SilentRotate:IsRazMode() then
        return L['BROADCAST_HEADER_TEXT_RAZUVIOUS']
    elseif SilentRotate:IsLoathebMode() then
        return L['BROADCAST_HEADER_TEXT_LOATHEB']
    elseif SilentRotate:IsDistractMode() then
        return L['BROADCAST_HEADER_TEXT_DISTRACT']
    end
    return L['BROADCAST_HEADER_TEXT']
end