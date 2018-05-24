if application "Terminal" is running then
	tell application "Terminal"
		do script "PATH"
	end tell
	tell application "System Events"
		tell process "Terminal"
			set frontmost to true
		end tell
	end tell
else
	tell application "Terminal"
		activate
		delay 1
		if (exists window 1) and not busy of window 1 then
			do script "PATH" in window 1
		else
			do script "PATH"
		end if
	end tell
end if