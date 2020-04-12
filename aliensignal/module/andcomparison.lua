local Module = require("aliensignal.module")

local AndComparison = Module:extend()

function AndComparison:new(slot, modules)
  Module.new(self, "andcomparison", slot, modules)
end

function AndComparison:computeRightOutput(time)
  local leftInput = self:leftInput()
  local upInput = self:upInput()

  return leftInput and upInput and leftInput:computeRightOutput(time) == 1 and upInput:computeDownOutput(time) == 1 and
    1 or
    0
end

return AndComparison
