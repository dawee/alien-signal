local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")

local Coupler = Module:extend()

function Coupler:new(slot, modules)
  Module.new(self, "coupler", slot, modules)

  self.displayableName = "Coupler"
  self.description = "Use this device when you want to diffuse your signal to 2 differents modules."
  self.requirements = {
    {2, Junk.Fork()},
    {1, Junk.Coin()},
    {1, Junk.Battery()}
  }
end

function Coupler:computeDownOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

function Coupler:computeUpOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time, increment)
end

return Coupler
