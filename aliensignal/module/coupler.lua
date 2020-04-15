local Module = require("aliensignal.module")

local Coupler = Module:extend()

function Coupler:new(slot, modules)
  Module.new(self, "coupler", slot, modules)
end

function Coupler:computeDownOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

function Coupler:computeUpOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

return Coupler
