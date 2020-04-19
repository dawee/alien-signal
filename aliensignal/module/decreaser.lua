local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")
local SignalScreen = require("aliensignal.signalscreen")

local Decreaser = Module:extend()

function round(num, numDecimalPlaces)
  local mult = 10 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function Decreaser:new(slot, modules)
  Module.new(self, "decreaser", slot, modules)

  self.displayableName = "Decreaser"
  self.description = "This module divides the frequency of the signal by 2."
  self.requirements = {
    {2, Junk.Coin()}
  }
end

function Decreaser:computeRightOutput(time, increment)
  local input = self:leftInput()

  return input and input:computeRightOutput(time / 2, increment)
end

return Decreaser
