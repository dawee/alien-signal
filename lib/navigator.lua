local Object = require("classic")

local Navigator = Object:extend()

function Navigator:new(screens)
  self.screens = screens
  self.loaded = {}
  self.stack = {}
end

function Navigator:navigate(name, props)
  self.stack = {}
  self:push(name, props)
end

function Navigator:topScreen()
  return table.getn(self.stack) > 0 and self.stack[table.getn(self.stack)] or nil
end

function Navigator:update(dt)
  if self:topScreen() then
    self:topScreen():update(dt)
  end
end

function Navigator:push(name, props)
  local Screen = self.screens[name]

  if Screen.Load and not self.loaded[name] then
    Screen.Load()
  end

  local pushedScreen = Screen(self)

  table.insert(self.stack, pushedScreen)
  pushedScreen:open(props)
end

function Navigator:pop(props)
  table.remove(self.stack, table.getn(self.stack))
  self.stack[#self.stack]:resume(props)
end

function Navigator:draw()
  for index, screen in pairs(self.stack) do
    screen:draw()
  end
end

function Navigator:mousemoved(x, y, dx, dy)
  if self:topScreen() and self:topScreen().mousemoved then
    self:topScreen():mousemoved(x, y, dx, dy)
  end
end

function Navigator:mousepressed(x, y, button, istouch)
  if self:topScreen() and self:topScreen().mousepressed then
    self:topScreen():mousepressed(x, y, button, istouch)
  end
end

function Navigator:mousereleased(x, y, button, istouch)
  if self:topScreen() and self:topScreen().mousereleased then
    self:topScreen():mousereleased(x, y, button, istouch)
  end
end

Navigator.Screen = Object:extend()

function Navigator.Screen:new(navigator)
  self.navigator = navigator
end

function Navigator.Screen:open(props)
end

function Navigator.Screen:resume(props)
end

function Navigator.Screen:update(dt)
end

function Navigator.Screen:draw()
end

return Navigator
