require "hyper"
require "caffeinate"
require "yabai"
wifi = require("wifi")
spotify = require("spotify")
screensound = require("screensound")

hyper:bind({}, "return", function()
  local win = hs.window.frontmostWindow()
  win:setFullscreen(not win:isFullscreen())
  hyper.triggered = true
end)

hs.autoLaunch(true)
-----------------------------------------------
-- Reload config on write
-----------------------------------------------
function reload_config(files)
  hs.reload()
end

hyper:bind({}, "r", function()
  reload_config()
  hyper.triggered = true
end)

watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")

