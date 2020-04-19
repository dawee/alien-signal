local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local DownLeftShoulder = Module:extend()

function DownLeftShoulder:new(slot, modules)
  Module.new(self, "downleftshoulder", slot, modules)

  self.displayableName = "Down Left Shoulder"
  self.description =
    "Shoulders are wires that allows the current to take a turn in the circuit. This one can connect its downer module to its left one."
  self.requirements = {
    {4, Junk.Fork()}
  }
end

function DownLeftShoulder:computeDownOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

function DownLeftShoulder:computeLeftOutput(time, increment)
  local input = self:downInput()

  return input and input:computeUpOutput(time, increment)
end

return DownLeftShoulder
