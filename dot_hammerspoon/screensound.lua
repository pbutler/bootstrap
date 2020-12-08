local screensound  = {}

screensound.current = nil

screensound.update = function ()
  local int_audio = "MacBook Pro Speakers"
  local airp_audio = "Patrick’s AirPods"
  local ext_audio = "LG UltraFine Display Audio"
  local ext_screen = "LG UltraFine"
  local dev = nil
  if (hs.screen.primaryScreen():name() == ext_screen) then
    dev = hs.audiodevice.findDeviceByName(ext_audio)
  else
    dev = hs.audiodevice.findDeviceByName(airp_audio)
    if dev == nil then
      dev = hs.audiodevice.findDeviceByName(int_audio)
    end
  end
  if screensound.current ~= dev:uid() then
    hs.notify.new({title="Activating Audio", informativeText=dev:name()}):send()
    screensound.current = dev:uid()
    dev:setDefaultOutputDevice()
  end
end

screensound.screen_watcher = hs.screen.watcher.new(screensound.update):start()

return screensound
