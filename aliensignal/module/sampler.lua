local Module = require("aliensignal.module")

local Sampler = Module:extend()

Sampler.Edge = 1 / 8

function Sampler:new(slot, modules)
  Module.new(self, "sampler", slot, modules)

  self.displayableName = "Sampler"
end

function Sampler:computeRightOutput(time, increment)
  local input = self:leftInput()

  if
    not input or (input:computeRightOutput(time, increment) == nil) or
      (input:computeRightOutput(time + increment) == nil)
   then
    return 0
  elseif
    input:computeRightOutput(time, increment) > 0 or
      input:computeRightOutput(time, increment) <= 0 and input:computeRightOutput(time + increment) >= 0
   then
    return 1
  else
    return 0
  end
end

return Sampler
