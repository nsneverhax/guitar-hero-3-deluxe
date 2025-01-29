script kill_object_later 
	GetGlobalTags \{user_options}
	if (<early_timing> = 0)
		begin
		if ScreenElementExists Id = <gem_id>
			GetScreenElementPosition Id = <gem_id> local
			py = (<ScreenELementPos>.(0.0, 1.0))
			if (<py> >= $highway_playline)
				DestroyGem Name = <gem_id>
				break
			endif
			Wait \{1
				GameFrame}
		else
			break
		endif
		repeat
	else
		if ScreenElementExists Id = <gem_id>
			DestroyGem Name = <gem_id>
		endif
	endif
endscript

script setup_gemarrays 
	get_song_struct song = <song_name>
	if (($<player_status>.part) = rhythm)
		<part> = 'rhythm_'
	else
		<part> = ''
	endif
	if ($game_mode = p2_career || $game_mode = p1_bass_quickplay || $game_mode = p2_coop ||
			($game_mode = training && ($<player_status>.part = rhythm)))
		if structurecontains structure = <song_struct> use_coop_notetracks
			if (($<player_status>.part) = rhythm)
				<part> = 'rhythmcoop_'
			else
				<part> = 'guitarcoop_'
			endif
		endif
	endif
	get_song_prefix song = <song_name>
	get_difficulty_text_nl difficulty = <difficulty>
	formattext checksumname = gem_array '%s_%t_%p%d' s = <song_prefix> t = 'song' p = <part> d = <difficulty_text_nl> addtostringlookup
	formattext checksumname = fretbar_array '%s_fretbars' s = <song_prefix> addtostringlookup
	change structurename = <player_status> current_song_gem_array = <gem_array>
	change structurename = <player_status> current_song_fretbar_array = <fretbar_array>
	change structurename = <player_status> current_song_beat_time = ($<fretbar_array> [1])
	change structurename = <player_status> playline_song_beat_time = ($<fretbar_array> [1])
	reset_star_array song_name = <song_name> difficulty = <difficulty> player_status = <player_status>
	return gem_array = <gem_array> fretbar_array = <fretbar_array> song_prefix = <song_prefix> part = <part> difficulty_text_nl = <difficulty_text_nl>
endscript