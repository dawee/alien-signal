local Module = require("aliensignal.module")

local Wire = Module:extend()

function Wire:new(slot, modules)
  Module.new(self, "wire", slot, modules)

  self.displayableName = "Wire"
  self.description = "A simple wire that extends a connection by one case"
end

function Wire:computeRightOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

function Wire:computeLeftOutput(time, increment)
  local input = self:rightInput()

  return input and input:computeLeftOutput(time, increment)
end

return Wire
