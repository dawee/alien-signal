local baton = require("baton")

return baton.new {
  controls = {
    save_hold = {"key:s"},
    save_trigger = {"key:l"},
    compare_hold = {"key:d"},
    compare_trigger = {"key:m"}
  }
}
