require "hyper"
require "caffeinate"
require "spectacle"
wifi = require("wifi")
spotify = require("spotify")
screensound = require("screensound")


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

-- hs.spotify.displayCurrentTrack()

