local screensound  = {}


screensound.screen_watcher = hs.screen.watcher.new(function ()
  local int_audio = "MacBook Pro Speakers"
  local airp_audio = "Patrick’s AirPods"
  local ext_audio = "LG UltraFine Display Audio"
  local ext_screen = "LG UltraFine"
  local dev = nil
  if (hs.screen.primaryScreen():name() == ext_screen) then
    dev = hs.audiodevice.findDeviceByName(ext_audio)
    hs.notify.new({title="Activating External Audio", informativeText=dev:name()}):send()
  else
    dev = hs.audiodevice.findDeviceByName(airp_audio)
    if (dev == null) then
      dev = hs.audiodevice.findDeviceByName(int_audio)
    end
    hs.notify.new({title="Activating Internal Audio", informativeText=dev:name()}):send()
  end
  dev:setDefaultOutputDevice()
end):start()

return screensound
