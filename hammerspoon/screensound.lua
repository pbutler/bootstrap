local screensound  = {}


screensound.screen_watcher = hs.screen.watcher.new(function ()
  local int_audio = "MacBook Pro Speakers"
  local ext_audio = "LG UltraFine Display Audio"
  local ext_screen = "LG UltraFine"
  if (hs.screen.primaryScreen():name() == ext_screen) then
    local dev = hs.audiodevice.findDeviceByName(ext_audio)
    -- hs.notify.new({title="Activating External Audio", informativeText=dev:name()}):send()
    dev:setDefaultOutputDevice()
  else
    local dev = hs.audiodevice.findDeviceByName(int_audio)
    -- hs.notify.new({title="Activating Internal Audio", informativeText=dev:name()}):send()
    dev:setDefaultOutputDevice()
  end
end):start()

return screensound
