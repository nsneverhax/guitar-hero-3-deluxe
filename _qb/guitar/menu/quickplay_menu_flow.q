script quickplay_start_song \{device_num = 0} 
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
	Change current_level = <level_checksum>
	start_song device_num = <device_num>
endscript