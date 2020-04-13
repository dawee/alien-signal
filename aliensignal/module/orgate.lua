local Module = require("aliensignal.module")

local OrGate = Module:extend()

function OrGate:new(slot, modules)
  Module.new(self, "orgate", slot, modules)
end

function OrGate:computeRightOutput(time)
  local leftInput = self:leftInput()
  local upInput = self:upInput()

  return leftInput and upInput and (leftInput:computeRightOutput(time) == 1 or upInput:computeDownOutput(time) == 1) and
    1 or
    0
end

return OrGate
