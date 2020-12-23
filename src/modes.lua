local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Is Tranqshot Mode? (default mode)
function SilentRotate:IsTranqMode()
    return not SilentRotate:IsRazMode() and not SilentRotate:IsLoathebMode() and not SilentRotate:IsDistractMode()
end

function SilentRotate:IsRazMode(mode)
    if (not mode) then mode = SilentRotate.currentMode end
    return mode == 'priestz'
end

function SilentRotate:IsLoathebMode(mode)
    if (not mode) then mode = SilentRotate.currentMode end
    return mode == 'healerz'
end

function SilentRotate:IsDistractMode(mode)
    if (not mode) then mode = SilentRotate.currentMode end
    return mode == 'roguez'
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

-- Return true if the class is recommended for a specific mode
-- If mode is nil, use the current mode instead
function SilentRotate:IsClassWanted(className, mode)
    if SilentRotate:IsRazMode(mode) then
        return className == 'PRIEST'
    elseif SilentRotate:IsLoathebMode(mode) then
        return className == 'PRIEST' or className == 'PALADIN' or className == 'SHAMAN' or className == 'DRUID'
    elseif SilentRotate:IsDistractMode(mode) then
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