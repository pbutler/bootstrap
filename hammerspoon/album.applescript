--------------------------------------------------------------------------------
-- album.applescript
--
-- A script which writes the current song's album artwork to .jpg format from
-- raw bytes
--------------------------------------------------------------------------------

tell application "Spotify"
	try
		if player state is not stopped then
			set cover_url to (get artwork url of current track)
		else
			return
		end if
	on error
		display dialog "Problem getting track info." buttons {"OK"}
		return
	end try
end tell

do shell script "curl -L " & cover_url & " -o ~/.cache/music.jpg"

cover_url
