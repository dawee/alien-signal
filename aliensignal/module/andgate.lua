local Color = require("aliensignal.color")
local Module = require("aliensignal.module")

local AndGate = Module:extend()

function AndGate:new(slot, modules)
  Module.new(self, "andgate", slot, modules)

  self.displayableName = "AND Gate"
  self.description = "This gate will only return 1 if both left input and right output equals 1"
end

function AndGate:computeRightOutput(time, increment)
  local leftInput = self:leftInput()
  local upInput = self:upInput()

  return leftInput and upInput and leftInput:computeRightOutput(time, increment) == 1 and
    upInput:computeDownOutput(time, increment) == 1 and
    1 or
    0
end

return AndGate
