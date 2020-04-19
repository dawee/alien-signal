local Junk = require("aliensignal.junk")
local Module = require("aliensignal.module")
local SignalScreen = require("aliensignal.signalscreen")

local Sampler = Module:extend()

Sampler.Edge = 1 / 8

function Sampler:new(slot, modules)
  Module.new(self, "sampler", slot, modules)

  self.displayableName = "Sampler"
end

function Sampler:getSample(time, increment)
  local input = self:leftInput()

  return input and not (input:computeRightOutput(time, increment) == nil) and
    input:computeRightOutput(time, increment) >= 0 and
    1 or
    0
end

function Sampler:computeRightOutput(time, increment)
  local input = self:leftInput()

  if time == 0 then
    self.previous = 0
  end

  local previous = self.previous or 0
  local current = self:getSample(time, increment)
  local previous = self:getSample(time - increment)
  local isOnGuide = time % SignalScreen.Wave.GuidePeriod < increment

  local res = isOnGuide and current or previous

  self.previous = res

  return res
end

return Sampler
