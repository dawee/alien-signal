local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local Booster = Module:extend()

function Booster:new(slot, modules)
  Module.new(self, "booster", slot, modules)

  self.displayableName = "Booster"
  self.description = "This module multiplies the frequency of the signal by 2."
  self.requirements = {
    {2, Junk.Coin()}
  }
end

function Booster:computeRightOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time * 2, increment)
end

return Booster
