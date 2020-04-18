local Module = require("aliensignal.module")

local UpLeftShoulder = Module:extend()

function UpLeftShoulder:new(slot, modules)
  Module.new(self, "upleftshoulder", slot, modules)

  self.displayableName = "Up Left Shoulder"
  self.description =
    "Shoulders are wires that allows the current to take a turn in the circuit. This one can connect its upper module to its left one."
end

function UpLeftShoulder:computeUpOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

function UpLeftShoulder:computeLeftOutput(time, increment)
  local input = self:upInput()

  return input and input:computeDownOutput(time, increment)
end

return UpLeftShoulder
