local Module = require("aliensignal.module")

local AndGate = Module:extend()

function AndGate:new(slot, modules)
  Module.new(self, "andgate", slot, modules)

  self.displayableName = "AND Gate"
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
