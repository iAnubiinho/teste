-- Initialization File - Locale and Bridge Setup

lib.locale()

-- Check for lunar_bridge dependency
local dependencyOk, errorMessage = lib.checkDependency("lunar_bridge", "1.3.0")

if not dependencyOk then
    Wait(5000)
    error(errorMessage)
end

-- Initialize bridge objects
if IsDuplicityVersion() then
    -- Server-side initialization
    LR = exports.lunar_bridge:getObject()
    Utils = LR.Utils
    Dispatch = LR.Dispatch
    Utils.checkVersion(GetCurrentResourceName())
else
    -- Client-side initialization
    LR = exports.lunar_bridge:getObject()
    Utils = LR.Utils
end