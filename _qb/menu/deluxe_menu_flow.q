quickplay_pause_options_fs = {
	Create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_deluxe_settings
			flow_state = quickplay_deluxe_settings_fs
		}
		{
			action = select_audio_settings
			flow_state = quickplay_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = quickplay_calibrate_lag_warning
		}
		// audio lag button for pc
		{
			action = 0xb1f15fbe
			flow_state = 0x8862eebe
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = select_lefty_flip
			flow_state = quickplay_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = quickplay_pause_fs
		}
	]
}

career_pause_options_fs = {
	Create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_deluxe_settings
			flow_state = career_deluxe_settings_fs
		}
		{
			action = select_audio_settings
			flow_state = career_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = career_calibrate_lag_warning
		}
		// audio lag button for pc
		{
			action = 0xb1f15fbe
			flow_state = 0x8862eebe
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = select_lefty_flip
			flow_state = career_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = career_pause_fs
		}
	]
}

practice_options_fs = {
	Create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_deluxe_settings
			flow_state = practice_deluxe_settings_fs
		}
		{
			action = select_audio_settings
			flow_state = practice_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = practice_calibrate_lag_warning
		}
		// audio lag button for pc
		{
			action = 0xb1f15fbe
			flow_state = 0x8862eebe
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = select_lefty_flip
			flow_state = practice_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = practice_pause_fs
		}
	]
}

coop_career_pause_options_fs = {
	Create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_deluxe_settings
			flow_state = coop_career_deluxe_settings_fs
		}
		{
			action = select_audio_settings
			flow_state = coop_career_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = coop_career_calibrate_lag_warning
		}
		// audio lag button for pc
		{
			action = 0xb1f15fbe
			flow_state = 0x8862eebe
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = select_lefty_flip
			flow_state = coop_ccareer_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = coop_ccareer_pause_fs
		}
	]
}

mp_faceoff_pause_options_fs = {
	Create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_deluxe_settings
			flow_state = mp_faceoff_deluxe_settings_fs
		}
		{
			action = select_audio_settings
			flow_state = mp_faceoff_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = mp_faceoff_calibrate_lag_warning
		}
		// audio lag button for pc
		{
			action = 0xb1f15fbe
			flow_state = 0x8862eebe
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = select_lefty_flip
			flow_state = mp_faceoff_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = mp_faceoff_pause_fs
		}
	]
}

quickplay_deluxe_settings_fs = {
	Create = create_custom_menu
	create_params = {
		Popup = 1
	}
	Destroy = destroy_custom_menu
	actions = [
		{
			action = Continue
			flow_state = quickplay_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

career_deluxe_settings_fs = {
	Create = create_custom_menu
	create_params = {
		Popup = 1
	}
	Destroy = destroy_custom_menu
	actions = [
		{
			action = Continue
			flow_state = career_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

practice_deluxe_settings_fs = {
	Create = create_custom_menu
	create_params = {
		Popup = 1
	}
	Destroy = destroy_custom_menu
	actions = [
		{
			action = Continue
			flow_state = practice_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

coop_career_deluxe_settings_fs = {
	Create = create_custom_menu
	create_params = {
		Popup = 1
	}
	Destroy = destroy_custom_menu
	actions = [
		{
			action = Continue
			flow_state = coop_career_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

mp_faceoff_deluxe_settings_fs = {
	Create = create_custom_menu
	create_params = {
		Popup = 1
	}
	Destroy = destroy_custom_menu
	actions = [
		{
			action = Continue
			flow_state = mp_faceoff_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}