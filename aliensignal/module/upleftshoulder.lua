local Module = require("aliensignal.module")

local UpLeftShoulder = Module:extend()

function UpLeftShoulder:new(slot, modules)
  Module.new(self, "upleftshoulder", slot, modules)
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
