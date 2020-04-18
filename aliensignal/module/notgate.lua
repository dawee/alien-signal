local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local NotGate = Module:extend()

function NotGate:new(slot, modules)
  Module.new(self, "notgate", slot, modules)

  self.displayableName = "NOT Gate"
  self.description =
    "This module reverts the input signal. If the input gives 0, it returns 1. If the input gives 1, it returns 0."
  self.requirements = {
    {3, Junk.Headset()},
    {1, Junk.LightBulb()},
    {1, Junk.MappleSirupCan()}
  }
end

function NotGate:computeRightOutput(time, increment)
  local leftInput = self:leftInput()

  if not leftInput or leftInput:computeRightOutput(time, increment) == nil then
    return 0
  elseif leftInput:computeRightOutput(time, increment) == 0 then
    return 1
  else
    return 0
  end
end

return NotGate
