local Module = require("aliensignal.module")

local NotGate = Module:extend()

function NotGate:new(slot, modules)
  Module.new(self, "notgate", slot, modules)

  self.displayableName = "NOT Gate"
end

function NotGate:computeRightOutput(time, increment)
  local leftInput = self:leftInput()

  if not leftInput or leftInput:computeRightOutput(time, increment) == nil then
    return 0
  elseif leftInput:computeRightOutput(time, increment) == 0 then
    return 1
  else
    return 0
  end
end

return NotGate
