local Bank = require("bank")

local spritesheets = {
  "arrow",
  "book",
  "build",
  "inventorybag",
  "modules",
  "signalscreen"
}

local spec = {}

for index, name in ipairs(spritesheets) do
  spec[name] = {
    image = Bank.Asset.Image("assets/images/" .. name .. ".png"),
    spritesheet = Bank.Asset.JSON("assets/spritesheets/" .. name .. ".json")
  }
end

return Bank(spec)
