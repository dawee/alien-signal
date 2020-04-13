local Module = require("aliensignal.module")

local Decreaser = Module:extend()

function Decreaser:new(slot, modules)
  Module.new(self, "decreaser", slot, modules)
end

function Decreaser:computeRightOutput(time)
  local input = self:leftInput()

  return input and input:computeRightOutput(time / 2)
end

return Decreaser
