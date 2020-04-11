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

Navigator.Screen = Object:extend()

function Navigator.Screen:new(navigator)
  self.navigator = navigator
end

function Navigator.Screen:open(props) end
function Navigator.Screen:update(dt) end
function Navigator.Screen:draw() end

return Navigator