script bootup_sequence
	if (IsPS2 || IsNGC)
		pre_movie_cleanup
	endif
	startrendering
	if (IsPS2 || IsNGC)
		hideloadingscreen
		0x11847aeb
		post_movie_reset 0xd4935026 = <0xd4935026>
	endif
	spawnscriptnow \{ui_flow_manager_respond_to_action
		params = {
			action = skip_bootup_sequence
			play_sound = 1
		}}
endscript
