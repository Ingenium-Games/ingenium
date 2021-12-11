-- ====================================================================================--

-- Globals and Require/Replace
math = require("glm")
math.randomseed(GetGameTimer())
--
c.Locale = conf.locale
c.Running = false
c.Loading = true