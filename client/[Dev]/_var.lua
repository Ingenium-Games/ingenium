-- ====================================================================================--
-- Globals and Require/Replace
math = require('glm')
math.randomseed(GetNetworkTime())
c = exports["ig.core"]:c()
--
Freecam = exports['freecam']
freecambool = false
--[[
Freecam.IsActive = exports['freecam']:IsActive()
Freecam.SetActive = exports['freecam']:SetActive(...)
Freecam.IsFrozen = exports['freecam']:IsFrozen()
Freecam.SetFrozen = exports['freecam']:SetFrozen(...)
Freecam.GetFov = exports['freecam']:GetFov()
Freecam.SetFov = exports['freecam']:SetFov(...)
Freecam.GetPosition = exports['freecam']:GetPosition()
Freecam.SetPosition = exports['freecam']:SetPosition(...)
Freecam.GetRotation = exports['freecam']:GetRotation()
Freecam.SetRotation = exports['freecam']:SetRotation(...)
Freecam.GetMatrix = exports['freecam']:GetMatrix()
Freecam.GetTarget = exports['freecam']:GetTarget()
Freecam.GetPitch = exports['freecam']:GetPitch()
Freecam.GetRoll = exports['freecam']:GetRoll()
Freecam.GetYaw = exports['freecam']:GetYaw()
Freecam.GetKeyboardControl = exports['freecam']:GetKeyboardControl()
Freecam.GetGamepadControl = exports['freecam']:GetGamepadControl()
Freecam.GetKeyboardSetting = exports['freecam']:GetKeyboardSetting()
Freecam.GetGamepadSetting = exports['freecam']:GetGamepadSetting()
Freecam.GetCameraSetting = exports['freecam']:GetCameraSetting()
Freecam.SetKeyboardControl = exports['freecam']:SetKeyboardControl(...)
Freecam.SetGamepadControl = exports['freecam']:SetGamepadControl(...)
Freecam.SetKeyboardSetting = exports['freecam']:SetKeyboardSetting(...)
Freecam.SetGamepadSetting = exports['freecam']:SetGamepadSetting(...)
Freecam.SetCameraSetting = exports['freecam']:SetCameraSetting(...)
]]--
--
Debug = {}
Debug.Enable = false