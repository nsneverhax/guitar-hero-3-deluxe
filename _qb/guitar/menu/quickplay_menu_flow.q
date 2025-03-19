script quickplay_start_song \{device_num = 0}
	GetGlobalTags \{user_options}
	get_progression_globals game_mode = ($game_mode)
	SongList = <tier_global>
	cs_get_total_guitarists
	GetRandomValue A = 0 B = (<num_guitarists> -1) Name = random_guitarist_index Integer
	if ($forced_guitarist = 0)
		get_valid_character_index char_index = <random_guitarist_index> Player = 1
	else
		get_valid_character_index char_index = ($forced_guitarist -1) Player = 1
	endif
	get_musician_profile_struct Index = <Index>
	FormatText ChecksumName = character_id '%s' S = (<profile_struct>.Name)
	Change StructureName = player1_status character_id = <character_id>
	Change \{StructureName = player1_status
		style = 1}
	Change \{StructureName = player1_status
		outfit = 1}
	guitar_array = ($Bonus_Guitars)
	GetArraySize ($Secret_Guitars)
	Index = 0
	begin
	guitar_id = ($Secret_Guitars [<Index>].Id)
	GetGlobalTags <guitar_id>
	if (<unlocked_for_purchase> = 1)
		AddArrayElement Array = (<guitar_array>) Element = ($Secret_Guitars [<Index>])
		<guitar_array> = (<Array>)
	endif
	<Index> = (<Index> + 1)
	repeat <array_Size>
	GetArraySize <guitar_array>
	GetRandomValue A = 0 B = (<array_Size> -1) Name = random_guitar_index Integer
	get_musician_instrument_struct Index = <random_guitar_index>
	Change StructureName = player1_status instrument_id = (<info_struct>.desc_id)
	get_total_num_venues
	GetRandomValue A = 0 B = (<num_venues> -1) Name = random_venue_index Integer
	get_valid_venue_index venue_index = <random_venue_index>
	if ($forced_venue = 0)
		get_LevelZoneArray_checksum Index = <Index>
	else
		level_checksum = ($LevelZoneArray [($forced_venue - 1)])
	endif

	if (<black_background> = 0)
		Change current_level = <level_checksum>
	else
		Change current_level = z_viewer
	endif

	dx_reset_fc_counters
	
	start_song device_num = <device_num>
endscript

script dx_get_random_song 
	if ($current_tab = tab_downloads)
		if NOT GlobalExists \{Name = download_songlist
			Type = Array}
			Printf "-- dx_get_random_song -- No downloaded songs detected, aborting random selection"
			return
		endif
		this_songlist = $download_songlist
	else
		this_songlist = $dx_songlist ; TODO: have a seperate list for Bonus songs
	endif
	dx_get_random_song_select songlist = <this_songlist>
	Change current_song = <random_song>
	start_flow_manager \{flow_state = quickplay_play_song_fs}
	destroy_setlist_menu
	create_loading_screen
	quickplay_start_song
endscript

script dx_get_random_song_select \{songlist = none}
	if NOT GotParam songlist
		return
	endif
	first_song_index = (-1)
	last_song_index = (-1)
	array_entry = 0
	GetArraySize {<songlist>}
	begin
	song_checksum = (<songlist> [<array_entry>])
	get_song_struct Song = <song_checksum>
	if ((<song_struct>.version) = gh3)
		if (<first_song_index> = (-1))
			<first_song_index> = <array_entry>
		endif
	endif
	<array_entry> = (<array_entry> + 1)
	repeat <array_Size>
	<last_song_index> = (<array_entry> - 1)
	GetRandomValue Name = random_value Integer A = <first_song_index> B = <last_song_index>
	return random_song = (<songlist> [<random_value>])
endscript

script setlist_show_helperbar \{text_option1 = "BONUS"
		text_option2 = "DOWNLOADS"
		button_option1 = "\\b7"
		button_option2 = "\\b8"
		Spacing = 16}
	if NOT English
		Change \{pill_helper_max_width = 75}
	endif
	Change user_control_auto_center = 1
	text_options = [
		"UP/DOWN"
		"SELECT"
		"BACK"
	]
	button_options = [
		"\\bb"
		"\\m0"
		"\\m1"
	]
	I = 0
	begin
	if (<I> > 2)
		if (<I> = 3)
			<text1> = <button_option1>
		else
			<text1> = <button_option2>
		endif
	else
		<text1> = (<button_options> [<I>])
	endif
	if (<I> > 2)
		if (<I> = 3)
			<text2> = <text_option1>
		else
			<text2> = <text_option2>
		endif
	else
		<text2> = (<text_options> [<I>])
	endif
	switch <text1>
		case "\\bb"
		<button> = Strumbar
		case "\\m0"
		<button> = Green
		case "\\m1"
		<button> = RED
		case "\\b6"
		<button> = Yellow
		case "\\b7"
		<button> = BLUE
		case "\\b8"
		<button> = Orange
	endswitch
	Change \{user_control_pill_text_color = [
			0
			0
			0
			255
		]}
	Change \{user_control_pill_color = [
			180
			180
			180
			255
		]}
	if ($is_network_game = 1)
		if IsHost
			if ($host_songs_to_pick > 0)
				if NOT (($g_tie_breaker_song = 1) && (<I> = 2))
					add_user_control_helper Text = <text2> button = <button> Z = 100
				endif
			endif
		else
			if ($client_songs_to_pick > 0)
				if NOT (($g_tie_breaker_song = 1) && (<I> = 2))
					add_user_control_helper Text = <text2> button = <button> Z = 100
				endif
			endif
		endif
	else
		add_user_control_helper Text = <text2> button = <button> Z = 100
	endif
	<I> = (<I> + 1)
	repeat 5
	tabs_text = ["setlist" "bonus" "downloads"]
	setlist_text_positions = [(300.0, 70.0) (624.0, 102.0) (870.0, 120.0)]
	download_text_positions = [(300.0, 70.0) (624.0, 102.0) (870.0, 160.0)]
	buttons_text = ["\\b7" "\\b6" "\\b8"]
	setlist_button_positions = [(580.0, 90.0) (260.0, 65.0) (830.0, 110.0)]
	download_button_positions = [(580.0, 90.0) (260.0, 65.0) (830.0, 150.0)]
	I = 0
	begin
	button_text_pos = (<setlist_button_positions> [<I>])
	if ($current_tab = tab_downloads)
		<button_text_pos> = (<download_button_positions> [<I>])
	endif
	displayText PARENT = setlist_menu Scale = 1 Text = (<buttons_text> [<I>]) rgba = [128 128 128 255] Pos = <button_text_pos> Z = 50 font = buttonsxenon
	tab_text_pos = (<setlist_text_positions> [<I>])
	if ($current_tab = tab_downloads)
		<tab_text_pos> = (<download_text_positions> [<I>])
	endif
	displayText PARENT = setlist_menu Scale = 1 Text = (<tabs_text> [<I>]) rgba = [0 0 0 255] Pos = <tab_text_pos> Z = 50 noshadow
	<I> = (<I> + 1)
	repeat 3
	add_user_control_helper Text = " RANDOM" button = Select Z = 100
endscript