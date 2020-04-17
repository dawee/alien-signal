local Module = require("aliensignal.module")

local DownRightShoulder = Module:extend()

function DownRightShoulder:new(slot, modules)
  Module.new(self, "downrightshoulder", slot, modules)

  self.displayableName = "Down Right Shoulder"
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
