local Module = require("aliensignal.module")

local Wire = Module:extend()

function Wire:new(slot, modules)
  Module.new(self, "wire", slot, modules)
end

function Wire:computeRightOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time)
end

function Wire:computeLeftOutput(time)
  local input = self:rightInput()

  return input and input:computeLeftOutput(time)
end

return Wire
