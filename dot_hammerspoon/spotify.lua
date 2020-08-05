local spotify = {
  running=false,
  last_song=nil,
  icon=hs.image.imageFromPath(os.getenv("HOME") .. "/.cache/spotify.png")
}

-- Open applescript and store in string context
local file, err = io.open(os.getenv("HOME") .. "/bootstrap/hammerspoon/album.applescript", "r")

-- Try to open the applescript file
if file == nil then
  print("Couldn't open file: " .. err)
else
  spotify.script_string = file:read("*all")
  file:close()
end

-- Notify the user what song is playing
function spotify.notify(songInfo, image, additionalInfo)
  if (songInfo ~= nil and songInfo.track ~= nil) then
    local title = additionalInfo .. songInfo.track
    local info = songInfo.album .. " | " .. songInfo.artist
    local note = hs.notify.new({title=title, informativeText=info}):setIdImage(spotify.icon)
    if (image ~= nil) then
      note:contentImage(image)
    end
    note:send()
  end
end

-- Executes applescript to write current album cover to file from raw bytes
function spotify.get_image()
  ok = hs.osascript.applescript(spotify.script_string)
  if (ok) then
    return hs.image.imageFromPath(os.getenv("HOME") .. "/.cache/music.jpg")
  else
    return nil  -- hs.image.imageFromPath("~/bootstrap/spotify.png")
  end
end

function spotify.track_info()
  return {
    id  = hs.spotify.getCurrentTrackId(),
    track  = hs.spotify.getCurrentTrack(),
    album  = hs.spotify.getCurrentAlbum(),
    artist = hs.spotify.getCurrentArtist()
  }
end

-- Spotify Keybindings
hyper:bind({}, "m", function() spotify.notify(spotify.track_info(), spotify.get_image(), "Playing: ") end)

spotify.timer = hs.timer.doEvery(1, function()
--  if (hs.spotify.isRunning()) then
  if ( hs.application.get("Spotify") ~= nil) then
    local cur_song = spotify.track_info()
    if (last_song and (last_song.id ~= cur_song.id)) then
      if (cur_song.track ~= "") then
        spotify.notify(cur_song, spotify.get_image(), "Playing: ")
      end
    end
    last_song = cur_song
  else
    last_song = nil
  end
end)

return spotify
