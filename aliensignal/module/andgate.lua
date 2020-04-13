local Module = require("aliensignal.module")

local AndGate = Module:extend()

function AndGate:new(slot, modules)
  Module.new(self, "andgate", slot, modules)
end

function AndGate:computeRightOutput(time)
  local leftInput = self:leftInput()
  local upInput = self:upInput()

  return leftInput and upInput and leftInput:computeRightOutput(time) == 1 and upInput:computeDownOutput(time) == 1 and
    1 or
    0
end

return AndGate
