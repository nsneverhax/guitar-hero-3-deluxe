script check_song_for_parts 
	load_songqpak song_name = ($current_song) async = 0
	get_song_struct song = ($current_song)
	if structurecontains structure = <song_struct> no_rhythm_track
		change \{structurename = player1_status
			part = guitar}
		return \{flow_state = quickplay_setlist_fs}
	endif
	get_song_prefix song = ($current_song)
	formattext checksumname = song_rhythm_array_id '%s_song_rhythm_easy' s = <song_prefix>
	if globalexists name = <song_rhythm_array_id> type = array
		getarraysize $<song_rhythm_array_id>
		if (<array_size> > 0)
			return \{flow_state = quickplay_select_part_fs}
		endif
	endif
	if structurecontains structure = <song_struct> use_coop_notetracks
		return \{flow_state = quickplay_select_part_fs}
	endif
	change \{structurename = player1_status
		part = guitar}
	return \{flow_state = quickplay_setlist_fs}
endscript

quickplay_select_part_fs = {
	create = create_choose_practice_part_menu
	destroy = destroy_choose_practice_part_menu
	actions = [
		{
			action = continue
			func = quickplay_start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = go_back
			flow_state = quickplay_setlist_fs
			transition_left
		}
	]
}

quickplay_select_difficulty_fs = {
	create = create_select_difficulty_menu
	destroy = destroy_select_difficulty_menu
	actions = [
		{
			action = continue
			flow_state = quickplay_setlist_fs
			transition_right
		}
		{
			action = go_back
			flow_state = main_menu_fs
			transition_left
		}
	]
}

quickplay_setlist_fs = {
	create = create_setlist_menu
	destroy = destroy_setlist_menu
	actions = [
		{
			action = continue
			flow_state_func = check_song_for_parts
			transition_right
		}
		{
			action = go_back
			flow_state = quickplay_select_difficulty_fs
			transition_left
		}
	]
}

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
	
	start_song device_num = <device_num>
endscript