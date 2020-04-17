local Module = require("aliensignal.module")

local Booster = Module:extend()

function Booster:new(slot, modules)
  Module.new(self, "booster", slot, modules)

  self.displayableName = "Booster"
end

function Booster:computeRightOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time * 2, increment)
end

return Booster
