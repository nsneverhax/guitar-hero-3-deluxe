script start_checking_for_signin_change 
	printf \{"start_checking_for_signin_change"}
	printscriptinfo \{"start_checking_for_signin_change"}
	printf \{"start_checking_for_signin_change - killing sysnotifys"}
	killspawnedscript \{name = sysnotify_handle_signin_change}
	printf \{"start_checking_for_signin_change - begin"}
	change \{respond_to_signin_changed = 1}
	change \{menu_select_difficulty_first_time = 0}
endscript

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
