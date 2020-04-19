local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Craftable = require("aliensignal.craftable")

local waves = {
  empty = {},
  sine = require("aliensignal.wave.sine"),
  square = require("aliensignal.wave.square"),
  x2square = require("aliensignal.wave.x2square"),
  x4square = require("aliensignal.wave.x4square"),
  d2square = require("aliensignal.wave.d2square"),
  d4square = require("aliensignal.wave.d4square"),
  length3gate = require("aliensignal.wave.length3gate"),
  length6gate = require("aliensignal.wave.length6gate")
}

local Junk = Craftable:extend()

function Junk:new(name, position)
  self.name = name
  self.position = position or {x = 0, y = 0}
  self.scale = 4
  self.alpha = 1
  self.rotation = 0

  self.sprite = peachy.new(bank.items.spritesheet, bank.items.image, name)
end

function Junk:clone()
  local cls = getmetatable(self)

  return cls(self.name, self.position)
end

function Junk:update(dt)
  self.sprite:update(dt)
end

function Junk:draw()
  Craftable.draw(self)

  if not (self.visible == false) then
    love.graphics.setColor(1, 1, 1, self.alpha)

    if self.blockRotation then
      self.sprite:draw(self.position.x, self.position.y, 0, self.scale, self.scale)
    else
      self.sprite:draw(
        self.position.x - self.sprite:getWidth() / 2,
        self.position.y - self.sprite:getHeight() / 2,
        self.rotation,
        self.scale,
        self.scale,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
      )
    end

    love.graphics.setColor(1, 1, 1, 1)
  end
end

Junk.MapleSyrupCan = Junk:extend()

function Junk.MapleSyrupCan:new(...)
  Junk.new(self, "maple_can", ...)
  self.displayableName = "Maple Syrup Can"
  self.signal = waves.empty
end

Junk.SonicScrewdriver = Junk:extend()

function Junk.SonicScrewdriver:new(...)
  Junk.new(self, "sonic_screwdriver", ...)
  self.displayableName = "Sonic Screwdriver"
  self.signal = waves.empty
end

Junk.LightBulb = Junk:extend()

function Junk.LightBulb:new(...)
  Junk.new(self, "light_bulb", ...)
  self.displayableName = "Light Bulb"
  self.signal = waves.x4square
end

Junk.Shield = Junk:extend()

function Junk.Shield:new(...)
  Junk.new(self, "shield", ...)
  self.displayableName = "Shield"
  self.signal = waves.empty
end

Junk.GameBoy = Junk:extend()

function Junk.GameBoy:new(...)
  Junk.new(self, "game_boy", ...)
  self.displayableName = "GameBoy"
  self.signal = waves.length6gate
end

Junk.Trophy = Junk:extend()

function Junk.Trophy:new(...)
  Junk.new(self, "trophy", ...)
  self.displayableName = "Trophy"
  self.signal = waves.d2square
end

Junk.Battery = Junk:extend()

function Junk.Battery:new(...)
  Junk.new(self, "battery", ...)
  self.displayableName = "Battery"
  self.signal = waves.x2square
end

Junk.Fork = Junk:extend()

function Junk.Fork:new(...)
  Junk.new(self, "fork", ...)
  self.displayableName = "Fork"
  self.signal = waves.sine
end

Junk.Coin = Junk:extend()

function Junk.Coin:new(...)
  Junk.new(self, "coin", ...)
  self.displayableName = "Coin"
  self.signal = waves.square
end

Junk.Microphone = Junk:extend()

function Junk.Microphone:new(...)
  Junk.new(self, "microphone", ...)
  self.displayableName = "Microphone"
  self.signal = waves.length3gate
end

Junk.Boombox = Junk:extend()

function Junk.Boombox:new(...)
  Junk.new(self, "boombox", ...)
  self.displayableName = "Boombox"
  self.signal = waves.d4square
end

Junk.FloppyDisk = Junk:extend()

function Junk.FloppyDisk:new(...)
  Junk.new(self, "floppy_disk", ...)
  self.displayableName = "Floppy Disk"
  self.signal = waves.empty
end

return Junk
