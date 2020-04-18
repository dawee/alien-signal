local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Navigator = require("navigator")

local MainScreen = Navigator.Screen:extend()

function MainScreen:new(...)
  Navigator.Screen.new(self, ...)
  self.background = bank.background
  self.positions = {
    antenna = {
      x = 64,
      y = 48
    },
    foxen = {
      x = 184,
      y = 496
    },
    spacegun = {
      x = 480,
      y = 540
    }
  }

  self.sprites = {
    antenna = peachy.new(bank.antenna.spritesheet, bank.antenna.image, "idle"),
    foxen = peachy.new(bank.foxen.spritesheet, bank.foxen.image, "idle"),
    spacegun = peachy.new(bank.spacegun.spritesheet, bank.spacegun.image, "idle")
  }
end

function MainScreen:update(dt)
  for name, sprite in pairs(self.sprites) do
    sprite:update(dt)
  end
end

function MainScreen:draw()
  love.graphics.draw(self.background, 0, 0, 0, 4, 4)

  for name, sprite in pairs(self.sprites) do
    sprite:draw(self.positions[name].x, self.positions[name].y, 0, 4, 4)
  end
end

return MainScreen
