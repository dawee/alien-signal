local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local DownRightShoulder = Module:extend()

function DownRightShoulder:new(slot, modules)
  Module.new(self, "downrightshoulder", slot, modules)

  self.displayableName = "Down Right Shoulder"
  self.description =
    "Shoulders are wires that allows the current to take a turn in the circuit. This one can connect its downer module to its right one."
  self.requirements = {
    {3, Junk.Headset()},
    {1, Junk.LightBulb()},
    {1, Junk.MappleSirupCan()}
  }
end

function DownRightShoulder:computeDownOutput(time, increment)
  local input = self:rightInput()

  return input and input:computeLeftOutput(time, increment)
end

function DownRightShoulder:computeRightOutput(time, increment)
  local input = self:downInput()

  return input and input:computeUpOutput(time, increment)
end

return DownRightShoulder
