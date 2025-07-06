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
	if (is_ps2)
		bootup_sequence_playstation_2
	else
		startrendering
		spawnscriptnow \{ui_flow_manager_respond_to_action
			params = {
				action = skip_bootup_sequence
				play_sound = 1
			}}		
	endif
endscript

script bootup_sequence_playstation_2
	pre_movie_cleanup
	wait_for_legal_timer
	startrendering
	hideloadingscreen
	playmovieandwait \{movie = 'atvi'}
	if NOT 0xf6d4aff8
		playmovieandwait \{movie = 'ro_logo'}
	endif
	if NOT 0xf6d4aff8
		playmovieandwait \{movie = 'ns_logo'}
	endif
	if NOT 0xf6d4aff8
		playmovieandwait \{movie = 'budcat'}
	endif
	playmovieandwait \{movie = 'intro'}
	0x11847aeb
	post_movie_reset 0xd4935026 = <0xd4935026>
	spawnscriptnow \{ui_flow_manager_respond_to_action
		params = {
			action = skip_bootup_sequence
			play_sound = 0
		}}
endscript
