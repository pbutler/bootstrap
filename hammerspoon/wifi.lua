local wifi = {
  homeSSID="CasaButberry",
  officeSSID="VTRI-Wireless",
  lastSSID=hs.wifi.currentNetwork()
}

function wifi.callback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        -- hs.audiodevice.defaultOutputDevice():setVolume(90)
        hs.notify.new({title="Hammerspoon", informativeText="Connected to Home WIFI"}):send()
    elseif newSSID == officeSSID and lastSSID ~= officeSSID then
        -- We just joined our office WiFi network
        -- hs.audiodevice.defaultOutputDevice():setVolume(30)
        hs.notify.new({title="Hammerspoon", informativeText="Connected to Office WIFI"}):send()
    elseif newSSID == nil and lastSSID ~= nil then
        -- We just lost WIFI network
        -- hs.audiodevice.defaultOutputDevice():setVolume(30)
        hs.notify.new({title="Hammerspoon", informativeText="Lost your Wifi"}):send()
    elseif lastSSID ~= newSSID then
        -- We just departed our home WiFi network
        -- hs.audiodevice.defaultOutputDevice():setVolume(30)
        hs.notify.new({title="Hammerspoon", informativeText="Connected to Public WIFI"}):send()
    end

    lastSSID = newSSID
end

wifi.watcher = hs.wifi.watcher.new(wifi.callback):start()

return wifi
