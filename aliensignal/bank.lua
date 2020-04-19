local Bank = require("bank")

local spritesheets = {
  "antenna",
  "build",
  "foxen",
  "items",
  "modules",
  "signalscreen",
  "spacegun",
  "tabs"
}

local spec = {
  background = Bank.Asset.Image("assets/images/background.png"),
  title = Bank.Asset.Image("assets/images/title.png")
}

for index, name in ipairs(spritesheets) do
  spec[name] = {
    image = Bank.Asset.Image("assets/images/" .. name .. ".png"),
    spritesheet = Bank.Asset.JSON("assets/spritesheets/" .. name .. ".json")
  }
end

return Bank(spec)
