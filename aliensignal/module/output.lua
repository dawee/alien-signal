local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local Output = Module:extend()

function Output:new(slot, modules, outputType)
  Module.new(self, outputType or "spacegun", slot, modules)

  self.displayableName = "Output"
end

function Output:computeRightOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment) or 0
end

return Output
