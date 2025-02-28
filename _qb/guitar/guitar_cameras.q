script cameracuts_waitscript \{camera_time = 0
		camera_songtime = 0}
	getsongtimems
	change cameracuts_changetime = <camera_songtime>
    GetGlobalTags \{user_options}
	begin
	getsongtimems
	if ($gwinportcameralocked = 0 || <dx_frontrowcamera> = 0)
		if (<time> >= $cameracuts_changetime ||
				$cameracuts_changenow = true)
			if ($cameracuts_changecamenable = true)
				break
			endif
		endif
		if NOT ($cameracuts_forcechangetime = 0.0)
			if ($cameracuts_forcechangetime < (<time> - $cameracuts_lastcamerastarttime))
				change \{cameracuts_forcechangetime = 0.0}
				break
			endif
		endif
		if gotparam \{nowait}
			return \{false}
		endif
	endif
	wait \{1
		gameframe}
	repeat
	return \{true}
endscript