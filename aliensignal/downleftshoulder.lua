local Module = require("aliensignal.module")

local DownLeftShoulder = Module:extend()

function DownLeftShoulder:new(slot, modules)
  Module.new(self, "downleftshoulder", slot, modules)
end

function DownLeftShoulder:computeDownOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time)
end

function DownLeftShoulder:computeLeftOutput(time)
  local input = self:downInput()

  return input and input:computeUpOutput(time)
end

return DownLeftShoulder
