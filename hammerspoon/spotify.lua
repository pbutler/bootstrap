last_song = nil

--
--------------------------------------------------------------------------------
-- @module: hs-music
--
-- @usage:  A set of bindings and functions for iTunes and Spotify.
-- @author: Andrew McBurney
--------------------------------------------------------------------------------

-- Open applescript and store in string context
local file, err = io.open(os.getenv("HOME") .. "/bootstrap/hammerspoon/album.applescript", "r")
local applescript_string = ""

-- Try to open the applescript file
if file == nil then
  print("Couldn't open file: " .. err)
else
  applescript_string = file:read("*all")
  file:close()
end

-- Images for notifications
local spotifyImage = hs.image.imageFromPath(os.getenv("HOME") .. "/.cache/music.jpg")

-- Notify the user what song is playing
local function notifySong(songInfo, image, additionalInfo)
  if (songInfo ~= nil and songInfo.track ~= nil) then
    title = additionalInfo .. songInfo.track
    info  = songInfo.album .. " | " .. songInfo.artist
    icon =  hs.image.imageFromPath(os.getenv("HOME") .. "/.cache/spotify.png")
    if image then
       hs.notify.new({title=title, informativeText=info}):setIdImage(icon):contentImage(image):send()
    else
        hs.notify.new({title=title, informativeText=info}):send()
    end
  end
end

-- Executes applescript to write current album cover to file from raw bytes
local function SpotifyImage()
  ok = hs.osascript.applescript(applescript_string)
  if (ok) then
    return hs.image.imageFromPath(os.getenv("HOME") .. "/.cache/music.jpg")
  else
    return nil  -- hs.image.imageFromPath("~/bootstrap/spotify.png")
  end
end


--------------------------------------------------------------------------------
-- Spotify
--
-- @see: A set of keybindings for Spotify
--------------------------------------------------------------------------------

-- Gets current track information and returns a table of KVPs
local function spotifyTrackInfo()
  return {
    id  = hs.spotify.getCurrentTrackId(),
    track  = hs.spotify.getCurrentTrack(),
    album  = hs.spotify.getCurrentAlbum(),
    artist = hs.spotify.getCurrentArtist()
  }
end

-- Spotify Keybindings
hyper:bind({}, "m", function() notifySong(spotifyTrackInfo(), SpotifyImage(), "Playing: ") end)

spot_info = hs.timer.doEvery(1, function()
    if (hs.spotify.isRunning()) then
        local cur_song = spotifyTrackInfo()
	if (not last_song or not (last_song.id == cur_song.id)) then
            notifySong(cur_song, SpotifyImage(), "Playing: ")
            last_song = cur_song
	end
    else
        last_song = nil
    end
end)
