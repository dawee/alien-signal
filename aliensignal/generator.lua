local Module = require("aliensignal.module")

local Generator = Module:extend()

function Generator:new(slot, modules)
  Module.new(self, "input", slot, modules)
end

function Generator:computeRightOutput(time)
  return math.sin(time * 2 * math.pi)
end

return Generator
