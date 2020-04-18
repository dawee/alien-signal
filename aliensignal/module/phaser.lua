local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local Phaser = Module:extend()

Phaser.GuidePeriod = 0.125

function Phaser:new(slot, modules)
  Module.new(self, "phaser", slot, modules)

  self.displayableName = "Phaser"
  self.description = "Use this module if you want your signal to be delayed by one step back in time"
  self.requirements = {
    {3, Junk.Headset()},
    {1, Junk.LightBulb()},
    {1, Junk.MappleSirupCan()}
  }
end

function Phaser:computeRightOutput(time, increment)
  local leftInput = self:leftInput()

  return leftInput and not (leftInput:computeRightOutput(time, increment) == nil) and
    leftInput:computeRightOutput(time + Phaser.GuidePeriod, increment) or
    0
end

return Phaser
