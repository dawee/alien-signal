local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Color = require("aliensignal.color")
local Object = require("classic")

local SignalScreen = Object:extend()

SignalScreen.Wave = {
  Duration = 8,
  GuidePeriod = 0.125,
  Precision = 0.0125,
  Height = 7,
  GuideHeight = 9
}

function SignalScreen:new(position, width)
  self.sprites = {
    left = peachy.new(bank.signalscreen.spritesheet, bank.signalscreen.image, "left"),
    right = peachy.new(bank.signalscreen.spritesheet, bank.signalscreen.image, "right"),
    middle = peachy.new(bank.signalscreen.spritesheet, bank.signalscreen.image, "middle")
  }

  self.scale = 4
  self.middleScale =
    math.ceil(
    (width - self.sprites.left:getWidth() * self.scale - self.sprites.right:getWidth() * self.scale) /
      self.sprites.middle:getWidth()
  )
  self.position = position
  self.precision = SignalScreen.Wave.Precision
  self.width = width
  self.waveLeftX = self.position.x + 7 * self.scale
  self.waveRightX = self.position.x + width - 17 * self.scale
  self.waveZeroY = math.ceil(self.position.y + (self.sprites.left:getHeight() / 2 + 1) * self.scale)
end

function SignalScreen:getHeight()
  return self.sprites.left:getHeight() * self.scale
end

function SignalScreen:computeSignalAtTime(time)
  return 1
end

function SignalScreen:computeXForTime(time)
  return self.waveLeftX + math.floor(time * (self.waveRightX - self.waveLeftX) / SignalScreen.Wave.Duration)
end

function SignalScreen:insertPointsAtTime(time, signalName, signalAtTime, lastSignalAtTime)
  local x = self:computeXForTime(time)

  if lastSignalAtTime == 0 and signalAtTime == 1 then
    table.insert(self.points[signalName], x)
    table.insert(self.points[signalName], self.waveZeroY)
  elseif lastSignalAtTime == 1 and signalAtTime == 0 then
    table.insert(self.points[signalName], x)
    table.insert(self.points[signalName], self.waveZeroY - math.floor(SignalScreen.Wave.Height * self.scale / 2))
  end

  table.insert(self.points[signalName], x)
  table.insert(
    self.points[signalName],
    self.waveZeroY - math.floor(signalAtTime * SignalScreen.Wave.Height * self.scale / 2)
  )

  lastSignalAtTime = signalAtTime
end

function SignalScreen:update(dt)
  self.points = {
    main = {},
    target = {}
  }

  self.guides = {}

  local lastSignalAtTime = {
    main = 0,
    target = 0
  }

  for time = 0, SignalScreen.Wave.Duration, SignalScreen.Wave.Precision do
    local signalAtTime = {
      main = self:computeSignalAtTime(time, "main"),
      target = self:computeSignalAtTime(time, "target")
    }

    self:insertPointsAtTime(time, "main", signalAtTime.main, lastSignalAtTime.main)
    self:insertPointsAtTime(time, "target", signalAtTime.target, lastSignalAtTime.target)

    lastSignalAtTime = {
      main = signalAtTime.main,
      target = signalAtTime.target
    }

    if time % SignalScreen.Wave.GuidePeriod <= self.precision then
      local x = self:computeXForTime(time)

      table.insert(
        self.guides,
        {
          x,
          self.waveZeroY - math.floor(SignalScreen.Wave.GuideHeight * self.scale / 2),
          x,
          self.waveZeroY + math.floor(SignalScreen.Wave.GuideHeight * self.scale / 2)
        }
      )
    end
  end

  for name, sprite in pairs(self.sprites) do
    sprite:update(dt)
  end
end

function SignalScreen:draw()
  self.sprites.middle:draw(
    self.position.x + self.sprites.left:getWidth() * self.scale,
    self.position.y,
    0,
    self.middleScale,
    self.scale
  )
  self.sprites.left:draw(self.position.x, self.position.y, 0, self.scale, self.scale)
  self.sprites.right:draw(
    self.position.x + self.width - self.sprites.right:getWidth() * self.scale,
    self.position.y,
    0,
    self.scale,
    self.scale
  )

  love.graphics.setLineWidth(1)

  Color.Guide:use()

  if self.guides then
    for index, guide in pairs(self.guides) do
      love.graphics.line(unpack(guide))
    end
  end

  Color.TargetSignal:use()

  if self.points and self.points.target then
    love.graphics.line(unpack(self.points.target))
  end

  Color.Signal:use()
  love.graphics.setLineWidth(3)
  if self.points and self.points.main then
    love.graphics.line(unpack(self.points.main))
  end
  love.graphics.setLineWidth(1)

  Color.White:use()
end

return SignalScreen
