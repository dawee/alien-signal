local Module = require("aliensignal.module")

local UpRightShoulder = Module:extend()

function UpRightShoulder:new(slot, modules)
  Module.new(self, "uprightshoulder", slot, modules)
end

function UpRightShoulder:computeUpOutput(time)
  local input = self:rightInput()

  return input and input:computeLeftOutput(time)
end

function UpRightShoulder:computeRightOutput(time)
  local input = self:upInput()

  return input and input:computeDownOutput(time)
end

return UpRightShoulder
