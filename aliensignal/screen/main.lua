local bank = require("aliensignal.bank")
local color = require("aliensignal.color")
local dialogs = require("aliensignal.dialogs")
local peachy = require("peachy")
local Animation = require("animation")
local Navigator = require("navigator")
local Junk = require("aliensignal.junk")
local moan = require("Moan")

local waves = {
  galaxy = require("aliensignal.wave.d4square"),
  -- solarSystem = require("aliensignal.wave.length3gate"),
  earth = require("aliensignal.wave.s4_1_2_2"),
  gps = require("aliensignal.wave.gps")
}

local MainScreen = Navigator.Screen:extend()

local DEBUG = false

function MainScreen:new(...)
  Navigator.Screen.new(self, ...)
  self.background = bank.background
  self.endscreen = bank.endscreen
  self.title = bank.title

  self.antennaSignal = {}

  self.attractedItemPositions = {
    {x = 870, y = 620},
    {x = 665, y = 730},
    {x = 510, y = 660}
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
    foxen = {
      x = -150,
      y = 496
    },
    spacegun = {
      x = 480,
      y = 540
    },
    title = {
      x = 130,
      y = -100
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
    },
    antenna = {
      x = 95,
      y = 350,
      width = 85,
      height = 187
    },
    antennaButton = {
      x = 95,
      y = 542,
      width = 50,
      height = 28
    }
  }

  self.titleAlpha = {alpha = 0}
  self.sceneAlpha = {alpha = 0}

  self.sprites = {
    antenna = peachy.new(bank.antenna.spritesheet, bank.antenna.image, "idle"),
    foxen = peachy.new(bank.foxen.spritesheet, bank.foxen.image, "idle"),
    spacegun = peachy.new(bank.spacegun.spritesheet, bank.spacegun.image, "idle")
  }

  self.direction = 1
  self.font = love.graphics.newFont("assets/fonts/emulogic.ttf", 20)
  self.creditsText = love.graphics.newText(self.font, "@le_dawee and @RikkuShimizu present")
  self.introCinematic = true
  self.showTitle = true

  self.introFoxenAnimation = Animation.Tween(2, self.positions.foxen, self.walkPoints[2])
  self.introFoxenAnimation.onStart:listenOnce(
    function()
      self.sprites.foxen:setTag("walk")
    end
  )
  self.introFoxenAnimation.onComplete:listenOnce(
    function()
      self.sprites.foxen:setTag("idle")
    end
  )

  self.introSceneAnimation =
    Animation.Series(
    {
      Animation.Parallel(
        {
          Animation.Tween(1, self.positions.title, {x = 130, y = 65}),
          Animation.Tween(1, self.titleAlpha, {alpha = 1})
        }
      ),
      Animation.Tween(1, self.sceneAlpha, {alpha = 1}),
      self.introFoxenAnimation,
      Animation.Wait(1.5),
      Animation.Parallel(
        {
          Animation.Tween(1, self.positions.title, {x = 130, y = -100}),
          Animation.Tween(1, self.titleAlpha, {alpha = 0})
        }
      )
    }
  )
  self.introSceneAnimation.onComplete:listenOnce(
    function()
      self.introCinematic = false
      self:startDialog(dialogs.intro)
    end
  )
  self.introSceneAnimation:start()

  -- moan initialization
  moan.UI.messageboxPos = "top"
  moan.font = self.font
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
  local signalAnimation = Animation.Wait(0.8)
  local animation =
    Animation.Parallel(
    {
      signalAnimation,
      self:junkAttractionAnimation()
    }
  )

  animation.onStart:listenOnce(
    function()
      self.sprites.spacegun:setTag("signal")
    end
  )

  signalAnimation.onComplete:listenOnce(
    function()
      self.sprites.spacegun:setTag("idle")
    end
  )

  return animation
end

function MainScreen:junkAttractionAnimation()
  local shake =
    Animation.Loop(
    Animation.Series(
      {
        Animation.Tween(0.05, self.attractedJunk, {rotation = math.pi / 4}),
        Animation.Tween(0.05, self.attractedJunk, {rotation = -math.pi / 4})
      }
    ),
    150
  )

  local shakeAndGrow =
    Animation.Parallel(
    {
      shake,
      Animation.Tween(2, self.attractedJunk, {scale = 2})
    }
  )

  local fall =
    Animation.Parallel(
    {
      Animation.Tween(
        0.3,
        self.attractedJunk.position,
        {
          x = self.attractedItemPositions[2].x
        },
        "linear"
      ),
      Animation.Tween(
        0.3,
        self.attractedJunk.position,
        {
          y = self.attractedItemPositions[2].y
        },
        "inBack"
      )
    }
  )

  local climbToPocket =
    Animation.Parallel(
    {
      Animation.Tween(
        0.3,
        self.attractedJunk.position,
        {
          x = self.attractedItemPositions[3].x
        },
        "linear"
      ),
      Animation.Tween(
        0.3,
        self.attractedJunk.position,
        {
          y = self.attractedItemPositions[3].y
        },
        "outBack"
      ),
      Animation.Tween(
        0.3,
        self.attractedJunk,
        {
          alpha = 0,
          scale = 0
        },
        "linear"
      )
    }
  )

  return Animation.Series(
    {
      shakeAndGrow,
      fall,
      Animation.Wait(0.8),
      climbToPocket
    }
  )
end

function MainScreen:pushSpacegunButtonAndSignalAnimation()
  local animation =
    Animation.Series({self:pushSpacegunButtonAnimation({backToIdle = false}), self:spacegunSignalAnimation()})

  return animation
end

function MainScreen:pushAntennaButtonAnimation(opts)
  local animation = Animation.Wait(0.3)
  local backToIdle = (opts == nil or opts.backToIdle == nil) and true or opts.backToIdle

  animation.onStart:listenOnce(
    function()
      self.sprites.antenna:setTag("button")
    end
  )

  if backToIdle then
    animation.onComplete:listenOnce(
      function()
        self.sprites.antenna:setTag("idle")
      end
    )
  end

  return animation
end

function MainScreen:antennaSignalAnimation()
  local animation = Animation.Wait(1.5)

  animation.onStart:listenOnce(
    function()
      self.sprites.antenna:setTag("signal")
    end
  )

  animation.onComplete:listenOnce(
    function()
      self.sprites.antenna:setTag("idle")
    end
  )

  return animation
end

function MainScreen:pushAntennaButtonAndSignalAnimation()
  local animation =
    Animation.Series({self:pushAntennaButtonAnimation({backToIdle = false}), self:antennaSignalAnimation()})

  return animation
end

function MainScreen:postWalkAction(x, y, button)
  if self:isInsideHitbox(x, y, self.hitboxes.spacegun) then
    self.navigator:push("machine", {inventory = self.inventory, modules = self.modules, output = "spacegun"})
  elseif self:isInsideHitbox(x, y, self.hitboxes.spacegunButton) then
    if self.junkToAttract then
      self.attractedJunk = self.junkToAttract:clone()
      self.attractedJunk.blockRotation = false
      self.attractedJunk.scale = 0.1
      self.attractedJunk.position = {
        x = self.attractedItemPositions[1].x,
        y = self.attractedItemPositions[1].y
      }
    end

    self.spacegunAnimation =
      self.junkToAttract and self:pushSpacegunButtonAndSignalAnimation() or self:pushSpacegunButtonAnimation()

    self.spacegunAnimation.onComplete:listenOnce(
      function()
        if self.junkToAttract then
          table.insert(self.inventory.junk, self.attractedJunk)
          self.attractedJunk.scale = 4
          self.attractedJunk.alpha = 1
          self.attractedJunk.blockRotation = true
          self.attractedJunk = nil
        else
          self:startDialog(dialogs.spacegunFail)
        end
      end
    )

    self.spacegunAnimation:start()
  elseif self:isInsideHitbox(x, y, self.hitboxes.antenna) then
    self.navigator:push(
      "machine",
      {inventory = self.inventory, modules = self.modules, output = "antenna", targetSignal = self.antennaTargetSignal}
    )
  elseif self:isInsideHitbox(x, y, self.hitboxes.antennaButton) then
    if not self.firstSignalSent and self.antennaSignal.flat == false then
      self.antennaAnimation = self:pushAntennaButtonAndSignalAnimation()

      self.antennaAnimation.onComplete:listenOnce(
        function()
          self.firstSignalSent = true
          self.antennaTargetSignal = waves.galaxy
          self.antennaSignal.target = false
          self:startDialog(dialogs.firstAntennaSignal)
        end
      )
    elseif self.antennaTargetSignal == waves.galaxy and self.antennaSignal.target == true then
      self.antennaAnimation = self:pushAntennaButtonAndSignalAnimation()

      self.antennaAnimation.onComplete:listenOnce(
        function()
          self.antennaTargetSignal = waves.earth
          self.antennaSignal.target = false
          self:startDialog(dialogs.secondAntennaSignal)
        end
      )
    elseif self.antennaTargetSignal == waves.earth and self.antennaSignal.target == true then
      self.antennaAnimation = self:pushAntennaButtonAndSignalAnimation()

      self.antennaAnimation.onComplete:listenOnce(
        function()
          self.antennaTargetSignal = waves.gps
          self.antennaSignal.target = false
          self.lastSignalSent = true
          -- DIALOG: Ask for last coordinates
          self:startDialog(dialogs.thirdAntennaSignal)
        end
      )
    elseif self.antennaTargetSignal == waves.gps and self.antennaSignal.target == true then
      self.antennaAnimation = self:pushAntennaButtonAndSignalAnimation()

      self.antennaAnimation.onComplete:listenOnce(
        function()
          self.antennaTargetSignal = nil
          self.antennaSignal.target = false
          -- DIALOG: End of game
          self:startDialog(dialogs.lastAntennaSignal)
        end
      )
    else
      self.antennaAnimation = self:pushAntennaButtonAnimation()
    end

    self.antennaAnimation:start()
  end
end

function MainScreen:updateIntroCinematic(dt)
  if not (self.introCinematic) then
    return
  end

  if self.introSceneAnimation then
    self.introSceneAnimation:update(dt)
  end
end

function MainScreen:setDialogTag()
  if moan.showingMessage then
    local isAlien = string.sub(moan.currentMessage, 1, 1) == "?"
    self.sprites.foxen:setTag(isAlien and "idle_signal" or "talk")
  else
    moan.clearMessages()
    self.sprites.foxen:setTag("idle")
  end
end

function MainScreen:startDialog(messages)
  moan.speak("", messages)
  self:setDialogTag()
end

function MainScreen:mousepressed(x, y, button)
  if self.introCinematic then
    return
  end

  self.dialogEnded = false

  if moan.showingMessage then
    moan.advanceMsg()

    if not moan.showingMessage then
      self.dialogEnded = true
    end

    self:setDialogTag()
    return
  end

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

  if props.output == "antenna" then
    self.antennaSignal = props.signal
  end
end

function MainScreen:update(dt)
  self:updateIntroCinematic(dt)

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

  if self.antennaAnimation then
    self.antennaAnimation:update(dt)
  end

  if self.itemAnimation then
    self.itemAnimation:update(dt)
  end

  if self.attractedJunk then
    self.attractedJunk:update(dt)
  end

  moan.update(dt)
end

function MainScreen:draw()
  if self.introSceneAnimation then
    color.White:use(self.sceneAlpha.alpha)
  end

  if self.lastSignalSent and self.dialogEnded then
    love.graphics.draw(self.endscreen, 0, 0, 0, 4, 4)
  else
    love.graphics.draw(self.background, 0, 0, 0, 4, 4)
    color.White:use()

    color.White:use(self.titleAlpha.alpha)
    love.graphics.draw(self.title, self.positions.title.x, self.positions.title.y, 0, 4, 4)
    color.White:use()

    color.CreditsText:use(self.titleAlpha.alpha)
    love.graphics.draw(self.creditsText, self.positions.title.x + 30, self.positions.title.y)
    color.White:use()

    if self.introSceneAnimation then
      color.White:use(self.sceneAlpha.alpha)
    end

    for index, name in pairs({"antenna", "spacegun"}) do
      self.sprites[name]:draw(self.positions[name].x, self.positions[name].y, 0, 4, 4)
    end

    local offset = self.direction == -1 and self.sprites.foxen:getWidth() * 4 or 0

    self.sprites.foxen:draw(self.positions.foxen.x + offset, self.positions.foxen.y, 0, self.direction * 4, 4)

    color.White:use()

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

    moan.draw()
  end
end

return MainScreen
