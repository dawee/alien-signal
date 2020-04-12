local bank = require("aliensignal.bank")
local peachy = require("peachy")
local Object = require("classic")

local Book = Object:extend()

function Book:new()
  self.sprite = peachy.new(bank.book.spritesheet, bank.book.image, "opened")
end

function Book:update(dt)
  self.sprite:update(dt)
end

function Book:draw()
  self.sprite:draw()
end

return Book
