local Module = require("aliensignal.module")

local Generator = Module:extend()

function Generator:new(slot, modules)
  Module.new(self, "generator", slot, modules)
end

function Generator:computeRightOutput(time)
  return math.sin(time * 2 * math.pi)
end

return Generator
