local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local Generator = Module:extend()

function Generator:new(slot, modules)
  Module.new(self, "generator", slot, modules)

  self.displayableName = "Generator"
end

function Generator:computeRightOutput(time, increment)
  return math.sin(time * 2 * math.pi)
end

return Generator
