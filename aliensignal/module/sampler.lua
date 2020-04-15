local Module = require("aliensignal.module")

local Sampler = Module:extend()

Sampler.Edge = 1 / 8

function Sampler:new(slot, modules)
  Module.new(self, "sampler", slot, modules)
end

function Sampler:computeRightOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time) >= math.abs(Sampler.Edge) and 1 or 0
end

return Sampler
