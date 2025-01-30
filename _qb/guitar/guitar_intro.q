nx_intro_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 135.0)
	song_artist_pos = (255.0, 150.0)
	song_title_start_time = -6500
	song_title_fade_time = 700
	song_title_on_time = 3000
	highway_start_time = -2000
	highway_move_time = 2000
	button_ripple_start_time = -800
	button_ripple_per_button_time = 100
	hud_start_time = -400
	hud_move_time = 200
}
nx_fastintro_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 135.0)
	song_artist_pos = (255.0, 150.0)
	song_title_start_time = -6700
	song_title_fade_time = 700
	song_title_on_time = 3000
	highway_start_time = -2000
	highway_move_time = 2000
	button_ripple_start_time = -800
	button_ripple_per_button_time = 100
	hud_start_time = -400
	hud_move_time = 200
}
nx_practice_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 135.0)
	song_artist_pos = (255.0, 150.0)
	song_title_start_time = -6500
	song_title_fade_time = 700
	song_title_on_time = 3000
	highway_start_time = -3000
	highway_move_time = 2000
	button_ripple_start_time = -1800
	button_ripple_per_button_time = 100
	hud_start_time = -1400
	hud_move_time = 200
}
nx_immediate_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 135.0)
	song_artist_pos = (255.0, 150.0)
	song_title_start_time = 0
	song_title_fade_time = 700
	song_title_on_time = 0
	highway_start_time = 0
	highway_move_time = 0
	button_ripple_start_time = 0
	button_ripple_per_button_time = 0
	hud_start_time = 0
	hud_move_time = 0
}
dx_intro_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 115.0)
	song_artist_pos = (255.0, 138.0)
	song_title_start_time = -6500
	song_title_fade_time = 700
	song_title_on_time = 3000
	highway_start_time = -2000
	highway_move_time = 2000
	button_ripple_start_time = -800
	button_ripple_per_button_time = 100
	hud_start_time = -400
	hud_move_time = 200
}
dx_fastintro_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 115.0)
	song_artist_pos = (255.0, 138.0)
	song_title_start_time = -6700
	song_title_fade_time = 700
	song_title_on_time = 3000
	highway_start_time = -2000
	highway_move_time = 2000
	button_ripple_start_time = -800
	button_ripple_per_button_time = 100
	hud_start_time = -400
	hud_move_time = 200
}
dx_practice_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 115.0)
	song_artist_pos = (255.0, 138.0)
	song_title_start_time = -6500
	song_title_fade_time = 700
	song_title_on_time = 3000
	highway_start_time = -3000
	highway_move_time = 2000
	button_ripple_start_time = -1800
	button_ripple_per_button_time = 100
	hud_start_time = -1400
	hud_move_time = 200
}
dx_immediate_sequence_props = {
	song_title_pos = (255.0, 75.0)
	performed_by_pos = (255.0, 115.0)
	song_artist_pos = (255.0, 138.0)
	song_title_start_time = 0
	song_title_fade_time = 700
	song_title_on_time = 0
	highway_start_time = 0
	highway_move_time = 0
	button_ripple_start_time = 0
	button_ripple_per_button_time = 0
	hud_start_time = 0
	hud_move_time = 0
}
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
		intro_song_scale = 1.23
		intro_performed_scale = (1.0, 0.5)
		intro_artist_scale = 1.0
		intro_song_info_text :SetProps Scale = (<intro_song_scale> - 0.43)
		intro_performed_by_text :SetProps Scale = (<intro_performed_scale> - 0.43)
		intro_artist_info_text :SetProps Scale = (<intro_artist_scale> - 0.43)
		return
	else
		intro_song_info_text :SetProps Scale = 1.23
		intro_performed_by_text :SetProps Scale = (1.0, 0.5)
		intro_artist_info_text :SetProps Scale = 1.0
	endif
	Wait ($current_intro.song_title_on_time / 1000.0) Seconds
	DoScreenElementMorph Id = intro_song_info_text Alpha = 0 Time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph Id = intro_artist_info_text Alpha = 0 Time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph Id = intro_performed_by_text Alpha = 0 Time = ($current_intro.song_title_fade_time / 1000.0)
endscript
