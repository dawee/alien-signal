local Module = require("aliensignal.module")

local Output = Module:extend()

function Output:new(slot, modules)
  Module.new(self, "emitter", slot, modules)
end

function Output:computeRightOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time) or 0
end

return Output
