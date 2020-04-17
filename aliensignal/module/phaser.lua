local Module = require("aliensignal.module")

local Phaser = Module:extend()

Phaser.GuidePeriod = 0.125

function Phaser:new(slot, modules)
  Module.new(self, "phaser", slot, modules)
end

function Phaser:computeRightOutput(time, increment)
  local leftInput = self:leftInput()

  return leftInput and not (leftInput:computeRightOutput(time, increment) == nil) and
    leftInput:computeRightOutput(time + Phaser.GuidePeriod, increment) or
    0
end

return Phaser
