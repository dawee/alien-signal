local Module = require("aliensignal.module")

local UpLeftShoulder = Module:extend()

function UpLeftShoulder:new(slot, modules)
  Module.new(self, "upleftshoulder", slot, modules)
end

function UpLeftShoulder:computeRightOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time)
end

return UpLeftShoulder
