local Module = require("aliensignal.module")

local DownRightShoulder = Module:extend()

function DownRightShoulder:new(slot, modules)
  Module.new(self, "downrightshoulder", slot, modules)
end

function DownRightShoulder:computeDownOutput(time)
  local input = self:rightInput()

  return input and input:computeLeftOutput(time)
end

function DownRightShoulder:computeRightOutput(time)
  local input = self:downInput()

  return input and input:computeUpOutput(time)
end

return DownRightShoulder
