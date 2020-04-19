local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local UpRightShoulder = Module:extend()

function UpRightShoulder:new(slot, modules)
  Module.new(self, "uprightshoulder", slot, modules)

  self.displayableName = "Up Right Shoulder"
  self.description =
    "Shoulders are wires that allows the current to take a turn in the circuit. This one can connect its upper module to its right one."
  self.requirements = {
    {2, Junk.Fork()}
  }
end

function UpRightShoulder:computeUpOutput(time, increment)
  local input = self:rightInput()

  return input and input:computeLeftOutput(time, increment)
end

function UpRightShoulder:computeRightOutput(time, increment)
  local input = self:upInput()

  return input and input:computeDownOutput(time, increment)
end

return UpRightShoulder
