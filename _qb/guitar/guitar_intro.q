script intro_song_info 
	begin
	GetSongTimeMS
	if ($current_intro.song_title_start_time + $current_starttime < <Time>)
		break
	endif
	Wait \{1
		GameFrame}
	repeat
	if ($current_intro.song_title_on_time = 0)
		return
	endif
	get_song_title Song = ($current_song)
	GetUpperCaseString <Song_Title>
	intro_song_info_text :SetProps Text = <UpperCaseString>
	intro_song_info_text :DoMorph Pos = ($current_intro.song_title_pos)
	get_song_artist Song = ($current_song)
	GetUpperCaseString <song_artist>
	intro_artist_info_text :SetProps Text = <UpperCaseString>
	intro_artist_info_text :DoMorph Pos = ($current_intro.song_artist_pos)
	get_song_artist_text Song = ($current_song)
	GetUpperCaseString <song_artist_text>
	intro_performed_by_text :SetProps Text = <UpperCaseString>
	intro_performed_by_text :DoMorph Pos = ($current_intro.performed_by_pos)
	intro_song_info_text :SetProps \{z_priority = 5.0}
	intro_artist_info_text :SetProps \{z_priority = 5.0}
	intro_performed_by_text :SetProps \{z_priority = 5.0}
	DoScreenElementMorph Id = intro_song_info_text Alpha = 1 Time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph Id = intro_performed_by_text Alpha = 1 Time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph Id = intro_artist_info_text Alpha = 1 Time = ($current_intro.song_title_fade_time / 1000.0)
	GetGlobalTags \{user_options}
	if (<song_title> = 1)
		return
	endif
	Wait ($current_intro.song_title_on_time / 1000.0) Seconds
	DoScreenElementMorph Id = intro_song_info_text Alpha = 0 Time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph Id = intro_artist_info_text Alpha = 0 Time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph Id = intro_performed_by_text Alpha = 0 Time = ($current_intro.song_title_fade_time / 1000.0)
endscript
