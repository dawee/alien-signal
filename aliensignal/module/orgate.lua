local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local OrGate = Module:extend()

function OrGate:new(slot, modules)
  Module.new(self, "orgate", slot, modules)

  self.displayableName = "OR Gate"
  self.description = "This gate will only return 1 if at least one of left input or right output equals 1"
  self.requirements = {
    {3, Junk.Shield()},
    {1, Junk.LightBulb()},
    {1, Junk.MapleSyrupCan()}
  }
end

function OrGate:computeRightOutput(time, increment)
  local leftInput = self:leftInput()
  local upInput = self:upInput()

  return leftInput and upInput and
    (leftInput:computeRightOutput(time, increment) == 1 or upInput:computeDownOutput(time, increment) == 1) and
    1 or
    0
end

return OrGate
