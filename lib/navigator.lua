local Object = require("classic")

local Navigator = Object:extend()

function Navigator:new(screens)
  self.screens = screens
end

function Navigator:navigate(name, props)
  self.currentScreen = self.screens[name](self)
  self.currentScreen:open(props)
end

function Navigator:update(dt)
  if self.currentScreen then
    self.currentScreen:update(dt)
  end
end

function Navigator:draw()
  if self.currentScreen then
    self.currentScreen:draw()
  end
end

function Navigator:mousemoved(x, y, dx, dy)
  if self.currentScreen and self.currentScreen.mousemoved then
    self.currentScreen:mousemoved(x, y, dx, dy)
  end
end

function Navigator:mousepressed(x, y, button, istouch)
  if self.currentScreen and self.currentScreen.mousepressed then
    self.currentScreen:mousepressed(x, y, button, istouch)
  end
end

function Navigator:mousereleased(x, y, button, istouch)
  if self.currentScreen and self.currentScreen.mousereleased then
    self.currentScreen:mousereleased(x, y, button, istouch)
  end
end

Navigator.Screen = Object:extend()

function Navigator.Screen:new(navigator)
  self.navigator = navigator
end

function Navigator.Screen:open(props)
end
function Navigator.Screen:update(dt)
end
function Navigator.Screen:draw()
end

return Navigator
