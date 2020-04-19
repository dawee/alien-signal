local bank = require("aliensignal.bank")
local color = require("aliensignal.color")
local peachy = require("peachy")
local Animation = require("animation")
local Navigator = require("navigator")
local Junk = require("aliensignal.junk")

local MainScreen = Navigator.Screen:extend()

local DEBUG = false

function MainScreen:new(...)
  Navigator.Screen.new(self, ...)
  self.background = bank.background
  self.title = bank.title

  self.attractedItemPositions = {
    {x = 870, y = 580},
    {x = 650, y = 700}
  }

  self.walkPoints = {
    {
      x = 80, -- antenna
      y = 430
    },
    {
      x = 184, -- initial
      y = 496
    },
    {
      x = 450, -- spacegun
      y = 550
    }
  }

  self.positions = {
    antenna = {
      x = 64,
      y = 48
    },
    foxen = self.walkPoints[2],
    spacegun = {
      x = 480,
      y = 540
    },
    title = {
      x = 130,
      y = 65
    }
  }

  self.hitboxes = {
    spacegun = {
      x = 535,
      y = 580,
      width = 80,
      height = 90
    },
    spacegunButton = {
      x = 535,
      y = 674,
      width = 50,
      height = 28
    }
  }

  self.titleAlpha = {alpha = 1}

  self.sprites = {
    antenna = peachy.new(bank.antenna.spritesheet, bank.antenna.image, "idle"),
    foxen = peachy.new(bank.foxen.spritesheet, bank.foxen.image, "idle"),
    spacegun = peachy.new(bank.spacegun.spritesheet, bank.spacegun.image, "idle")
  }

  self.direction = 1
  self.font = love.graphics.newFont("assets/fonts/emulogic.ttf", 20)
  self.creditsText = love.graphics.newText(self.font, "@le_dawee and @RikkuShimizu present")
  self.showTitle = true
end

function MainScreen:open(props)
  self.inventory = props.inventory
  self.modules = props.modules
end

function MainScreen:isInsideHitbox(x, y, hitbox)
  return x >= hitbox.x and x <= hitbox.x + hitbox.width and y >= hitbox.y and y <= hitbox.y + hitbox.height
end

function MainScreen:normalizeWalkPoint(x)
  local previousPoint = nil
  local nextPoint = nil
  local targetX = x - 2 * self.sprites.foxen:getWidth()

  if targetX < self.walkPoints[1].x then
    targetX = self.walkPoints[1].x
  elseif targetX > self.walkPoints[#self.walkPoints].x then
    targetX = self.walkPoints[#self.walkPoints].x
  end

  for index, point in ipairs(self.walkPoints) do
    previousPoint = (previousPoint == nil or point.x <= targetX) and point or previousPoint
    nextPoint = (nextPoint == nil and point.x >= targetX) and point or nextPoint
  end

  return {
    x = targetX,
    y = previousPoint.y + (nextPoint.y - previousPoint.y) / 2
  }
end

function MainScreen:walkAnimation(x)
  local longestDistance = self.walkPoints[#self.walkPoints].x - self.walkPoints[1].x
  local normalizedWalkPoint = self:normalizeWalkPoint(x)
  local duration = 2.0 * math.abs(normalizedWalkPoint.x - self.positions.foxen.x) / longestDistance

  self.direction =
    normalizedWalkPoint.x == self.positions.foxen.x and self.direction or
    (normalizedWalkPoint.x >= self.positions.foxen.x and 1 or -1)

  local walkAnimation =
    duration > 0 and Animation.Tween(duration, self.positions.foxen, normalizedWalkPoint) or Animation.Nop()

  walkAnimation.onStart:listenOnce(
    function()
      self.sprites.foxen:setTag("walk")
    end
  )

  walkAnimation.onComplete:listenOnce(
    function()
      self.sprites.foxen:setTag("idle")
    end
  )

  return walkAnimation
end

function MainScreen:pushSpacegunButtonAnimation(opts)
  local animation = Animation.Wait(0.3)
  local backToIdle = (opts == nil or opts.backToIdle == nil) and true or opts.backToIdle

  animation.onStart:listenOnce(
    function()
      self.sprites.spacegun:setTag("button")
    end
  )

  if backToIdle then
    animation.onComplete:listenOnce(
      function()
        self.sprites.spacegun:setTag("idle")
      end
    )
  end

  return animation
end

function MainScreen:spacegunSignalAnimation()
  local animation = Animation.Wait(0.8)

  animation.onStart:listenOnce(
    function()
      self.sprites.spacegun:setTag("signal")
    end
  )

  animation.onComplete:listenOnce(
    function()
      self.sprites.spacegun:setTag("idle")
    end
  )

  return animation
end

function MainScreen:junkAttractionAnimation()
  local animation =
    Animation.Loop(
    Animation.Series(
      {
        Animation.Tween(0.1, self.attractedJunk, {rotation = math.pi / 4}),
        Animation.Tween(0.1, self.attractedJunk, {rotation = -math.pi / 4})
      }
    ),
    10
  )
end

function MainScreen:pushSpacegunButtonAndSignalAnimation()
  local animation =
    Animation.Series({self:pushSpacegunButtonAnimation({backToIdle = false}), self:spacegunSignalAnimation()})

  return animation
end

function MainScreen:postWalkAction(x, y, button)
  if self:isInsideHitbox(x, y, self.hitboxes.spacegun) then
    self.navigator:push("machine", {inventory = self.inventory, modules = self.modules, output = "spacegun"})
  elseif self:isInsideHitbox(x, y, self.hitboxes.spacegunButton) then
    self.spacegunAnimation =
      self.junkToAttract and self:pushSpacegunButtonAndSignalAnimation() or self:pushSpacegunButtonAnimation()

    self.spacegunAnimation:start()
  end
end

function MainScreen:mousepressed(x, y, button)
  if self.showTitle then
    self.showTitle = false
    self.titleAnimation =
      Animation.Parallel(
      {
        Animation.Tween(1, self.positions.title, {x = 130, y = -100}),
        Animation.Tween(1, self.titleAlpha, {alpha = 0})
      }
    )
    self.titleAnimation:start()
  end

  self.foxenAnimation = self:walkAnimation(x, y)

  self.foxenAnimation:start()
  self.foxenAnimation.onComplete:listenOnce(
    function()
      self:postWalkAction(x, y, button)
    end
  )
end

function MainScreen:resume(props)
  self.junkToAttract = props.junk
end

function MainScreen:update(dt)
  for name, sprite in pairs(self.sprites) do
    sprite:update(dt)
  end

  if self.foxenAnimation then
    self.foxenAnimation:update(dt)
  end

  if self.titleAnimation then
    self.titleAnimation:update(dt)
  end

  if self.spacegunAnimation then
    self.spacegunAnimation:update(dt)
  end

  if self.attractedJunk then
    self.attractedJunk:update(dt)
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

  for index, name in pairs({"antenna", "spacegun"}) do
    self.sprites[name]:draw(self.positions[name].x, self.positions[name].y, 0, 4, 4)
  end

  local offset = self.direction == -1 and self.sprites.foxen:getWidth() * 4 or 0

  self.sprites.foxen:draw(self.positions.foxen.x + offset, self.positions.foxen.y, 0, self.direction * 4, 4)

  if self.attractedJunk then
    self.attractedJunk:draw()
  end

  if DEBUG then
    love.graphics.setColor(1, 1, 1, 0.6)

    for name, hitbox in pairs(self.hitboxes) do
      love.graphics.rectangle("fill", hitbox.x, hitbox.y, hitbox.width, hitbox.height)
    end

    for index, position in ipairs(self.attractedItemPositions) do
      love.graphics.rectangle("fill", position.x, position.y, 32, 32)
    end

    love.graphics.setColor(1, 1, 1, 1)
  end
end

return MainScreen
