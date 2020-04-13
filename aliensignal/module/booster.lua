local Module = require("aliensignal.module")

local Booster = Module:extend()

function Booster:new(slot, modules)
  Module.new(self, "booster", slot, modules)
end

function Booster:computeRightOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time * 2)
end

return Booster
