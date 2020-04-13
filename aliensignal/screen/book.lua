local bank = require("aliensignal.bank")
local peachy = require("peachy")

local Booster = require("aliensignal.module.booster")
local Coupler = require("aliensignal.module.coupler")
local AndGate = require("aliensignal.module.andgate")
local Sampler = require("aliensignal.module.sampler")
local Navigator = require("navigator")

local DownLeftShoulder = require("aliensignal.module.downleftshoulder")
local DownRightShoulder = require("aliensignal.module.downrightshoulder")
local UpLeftShoulder = require("aliensignal.module.upleftshoulder")
local UpRightShoulder = require("aliensignal.module.uprightshoulder")

local Book = Navigator.Screen:extend()

Book.ItemPosition = {
  x = 664,
  y = 136
}

Book.ButtonPosition = {
  x = 600,
  y = 434
}

Book.LeftCursorBox = {
  min = {x = 0, y = 0},
  max = {x = 128, y = 768}
}

Book.RightCursorBox = {
  min = {x = 1024 - 128, y = 0},
  max = {x = 1024, y = 768}
}

function Book.createArrowCursor(name)
  local sprite = peachy.new(bank.arrow.spritesheet, bank.arrow.image, name)
  local canvas = love.graphics.newCanvas(sprite:getWidth(), sprite:getHeight())

  love.graphics.setCanvas(canvas)
  sprite:draw()
  love.graphics.setCanvas()

  return love.mouse.newCursor(canvas:newImageData())
end

function Book.Load()
  Book.LeftCursor = Book.createArrowCursor("left")
  Book.RightCursor = Book.createArrowCursor("right")
end

function Book:new()
  self.sections = {
    Sampler(),
    Coupler(),
    AndGate(),
    Booster(),
    DownLeftShoulder(),
    DownRightShoulder(),
    UpLeftShoulder(),
    UpRightShoulder()
  }

  self.sprites = {
    book = peachy.new(bank.book.spritesheet, bank.book.image, "opened"),
    button = peachy.new(bank.build.spritesheet, bank.build.image, "enabled")
  }
end

function Book:mouseInBox(x, y, box)
  return x >= box.min.x and x <= box.max.x and y >= box.min.y and y <= box.max.y
end

function Book:open()
  self:openSection(1)
end

function Book:openSection(index)
  self.sectionIndex = index
  self:section().position = Book.ItemPosition
end

function Book:isFirstSection()
  return self.sectionIndex == 1
end

function Book:isLastSection()
  return self.sectionIndex == table.getn(self.sections)
end

function Book:openNextSection()
  if not self:isLastSection() then
    self:openSection(self.sectionIndex + 1)
  end
end

function Book:openPreviousSection()
  if not self:isFirstSection() then
    self:openSection(self.sectionIndex - 1)
  end
end

function Book:section()
  return self.sections[self.sectionIndex]
end

function Book:mousemoved(x, y)
  if self:mouseInBox(x, y, Book.RightCursorBox) then
    love.mouse.setCursor(Book.RightCursor)
  elseif self:mouseInBox(x, y, Book.LeftCursorBox) then
    love.mouse.setCursor(Book.LeftCursor)
  else
    love.mouse.setCursor()
  end
end

function Book:mousepressed(x, y, button)
  if self:mouseInBox(x, y, Book.RightCursorBox) and button == 1 then
    self:openNextSection()
  elseif self:mouseInBox(x, y, Book.LeftCursorBox) and button == 1 then
    self:openPreviousSection()
  end
end

function Book:update(dt)
  self.sprites.book:update(dt)
  self.sprites.button:update(dt)
  self:section():update(dt)
end

function Book:draw()
  self.sprites.book:draw()
  self.sprites.button:draw(Book.ButtonPosition.x, Book.ButtonPosition.y)
  self:section():draw()
end

return Book
