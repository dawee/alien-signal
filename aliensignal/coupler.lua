local Module = require("aliensignal.module")

local Coupler = Module:extend()

function Coupler:new(slot, modules)
  Module.new(self, "coupler", slot, modules)
end

function Coupler:computeDownOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time)
end

function Coupler:computeUpOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time)
end

return Coupler
