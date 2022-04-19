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

