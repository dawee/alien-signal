local bank = require("aliensignal.bank")
local color = require("aliensignal.color")
local peachy = require("peachy")
local Animation = require("animation")
local Navigator = require("navigator")

local MainScreen = Navigator.Screen:extend()

function MainScreen:new(...)
  Navigator.Screen.new(self, ...)
  self.background = bank.background
  self.title = bank.title
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
    },
    title = {
      x = 130,
      y = 65
    }
  }
  self.titleAlpha = {alpha = 1}

  self.sprites = {
    antenna = peachy.new(bank.antenna.spritesheet, bank.antenna.image, "idle"),
    foxen = peachy.new(bank.foxen.spritesheet, bank.foxen.image, "idle"),
    spacegun = peachy.new(bank.spacegun.spritesheet, bank.spacegun.image, "idle")
  }

  self.font = love.graphics.newFont("assets/fonts/emulogic.ttf", 20)
  self.creditsText = love.graphics.newText(self.font, "@le_dawee and @RikkuShimizu present")
  self.showTitle = true
end

function MainScreen:mousepressed(x, y, button)
  if self.showTitle then
    self.showTitle = false
    self.titleAnimation = Animation.Parallel({
      Animation.Tween(1, self.positions.title, {x = 130, y = -100}),
      Animation.Tween(1, self.titleAlpha, {alpha = 0})
    })
    self.titleAnimation:start()
  end

  self.animation = Animation.Tween(2.0, self.positions.foxen, {x = x - self.sprites.foxen:getWidth() * 2})
  self.sprites.foxen:setTag("walk")
  self.animation:start()
  self.animation.onComplete:listenOnce(
    function()
      self.sprites.foxen:setTag("idle")
    end
  )
end

function MainScreen:update(dt)
  for name, sprite in pairs(self.sprites) do
    sprite:update(dt)
  end

  if self.animation then
    self.animation:update(dt)
  end

  if self.titleAnimation then
    self.titleAnimation:update(dt)
  end
end

function MainScreen:draw()
  love.graphics.draw(self.background, 0, 0, 0, 4, 4)

  color.White:use(self.titleAlpha.alpha)
  love.graphics.draw(self.title, self.positions.title.x, self.positions.title.y, 0, 4, 4)
  color.White:use()

  color.CreditsText:use(self.titleAlpha.alpha)
  love.graphics.draw(self.creditsText, self.positions.title.x + 30, self.positions.title.y)
  color.White:use()

  for index, name in pairs({"antenna", "spacegun", "foxen"}) do
    self.sprites[name]:draw(self.positions[name].x, self.positions[name].y, 0, 4, 4)
  end
end

return MainScreen
