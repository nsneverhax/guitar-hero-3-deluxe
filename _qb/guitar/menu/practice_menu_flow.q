script enable_select_to_restart 
	SetScreenElementProps {
		Id = root_window
		event_handlers = [
			{pad_select practice_restart_song}
		]
		Replace_Handlers
	}
endscript

script disable_select_to_restart 
	SetScreenElementProps {
		Id = root_window
		event_handlers = [
			{pad_select null_script}
		]
		Replace_Handlers
	}
endscript

script practice_start_song \{device_num = 0}
	GetGlobalTags \{user_options}
	Change \{game_mode = training}
	Change \{current_transition = PRACTICE}
	if (<black_background> = 0)
		Change \{current_level = load_z_soundcheck}
	else
		Change \{current_level = z_viewer}
	endif
	start_song StartTime = ($practice_start_time) device_num = <device_num> practice_intro = 1 endtime = ($practice_end_time)
	Change \{practice_audio_muted = 0}
	if ($current_speedfactor = 1.0)
		menu_audio_settings_update_band_volume \{vol = 7}
	else
		menu_audio_settings_update_band_volume \{vol = 0}
	endif
	SetSoundBussParams \{Crowd = {
			vol = -100.0
		}}
	SpawnScriptNow \{practice_update}

	if (<select_restart> = 1)
		enable_select_to_restart
	endif
endscript

script practice_restart_song 
	Change \{game_mode = training}
	Change \{current_transition = PRACTICE}
	restart_song practice_intro = 1 StartTime = ($practice_start_time) endtime = ($practice_end_time)
	Change \{practice_audio_muted = 0}
	if ($current_speedfactor = 1.0)
		menu_audio_settings_update_band_volume \{vol = 7}
	else
		menu_audio_settings_update_band_volume \{vol = 0}
	endif
	SetSoundBussParams \{Crowd = {
			vol = -100.0
		}}
	SpawnScriptNow \{practice_update}
	GetGlobalTags \{user_options}
	if (<select_restart> = 1)
		enable_select_to_restart
	endif
endscript

script finish_practice_song 
	KillSpawnedScript \{Name = practice_update}
	ui_flow_manager_respond_to_action \{action = end_song}
	gh3_start_pressed

	GetGlobalTags \{user_options}
	disable_select_to_restart
endscript

script shut_down_practice_mode 
	KillSpawnedScript \{Name = practice_update}
	GetGlobalTags \{user_options}
	menu_audio_settings_update_guitar_volume vol = <guitar_volume>
	menu_audio_settings_update_band_volume vol = <band_volume>
	menu_audio_settings_update_sfx_volume vol = <sfx_volume>
	SetSoundBussParams {Crowd = {vol = ($Default_BussSet.Crowd.vol)}}
	disable_select_to_restart
endscript