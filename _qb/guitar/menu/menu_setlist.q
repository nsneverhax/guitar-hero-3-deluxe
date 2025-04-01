setlist_event_handlers = [
	{
		pad_up
		setlist_scroll
		Params = {
			Dir = UP
		}
	}
	{
		pad_down
		setlist_scroll
		Params = {
			Dir = DOWN
		}
	}
	{
		pad_back
		setlist_go_back
	}
	{
		pad_option2
		change_tab
		Params = {
			tab = tab_setlist
			button = 1
		}
	}
	{
		pad_option
		change_tab
		Params = {
			tab = tab_bonus
			button = 1
		}
	}
	{
		pad_L1
		change_tab
		Params = {
			tab = tab_downloads
			button = 1
		}
	}
	{
		pad_start
		menu_show_gamercard
	}
	{
		pad_select
		dx_get_random_song
	}
]
script display_as_made_famous_by \{rot_angle = -7
		time = 0.25}
	destroy_menu \{menu_id = setlist_original_artist}
	CreateScreenElement {
		Type = ContainerElement
		parent = root_window
		id = setlist_original_artist
		rot_angle = <rot_angle>
		alpha = 0
	}
	displaySprite {
		parent = setlist_original_artist
		tex = white
		dims = (130.0, 50.0)
		just = [center top]
		Pos = <Pos>
		rgba = [0 0 0 255]
		z = 500
	}
	displaySprite {
		parent = setlist_original_artist
		tex = white
		just = [center top]
		dims = (130.0, 25.0)
		Pos = (<Pos> + (0.0, 25.0))
		rgba = [223 223 223 255]
		z = 501
	}
	displayText {
		parent = setlist_original_artist
		text = "AS MADE"
		font = text_a3
		just = [center top]
		Pos = (<Pos>)
		z = 502
		Scale = (0.8, 0.5)
		rgba = [223 223 223 255]
		noshadow
	}
	fit_text_in_rectangle id = <id> dims = (75.0, 15.0)
	displayText {
		parent = setlist_original_artist
		text = "FAMOUS BY"
		just = [center top]
		font = text_a3
		Pos = (<Pos> + (0.0, 25.0))
		z = 502
		Scale = (0.72499996, 0.5)
		rgba = [0 0 0 255]
		noshadow
	}
	fit_text_in_rectangle id = <id> dims = (90.0, 15.0)
	DoScreenElementMorph id = setlist_original_artist alpha = 1 time = <time>
endscript

script create_as_made_famous_by 

	if ((IsNGC) || (IsPS2))
		create_as_made_famous_by_PSWii <...>
		return
	endif

	CreateScreenElement \{Type = ContainerElement
		parent = root_window
		id = setlist_original_artist
		rot_angle = -7
		alpha = 0}
	displaySprite \{parent = setlist_original_artist
		id = sl_oa_back
		tex = white
		dims = (130.0, 50.0)
		just = [
			center
			top
		]
		Pos = (50.0, -25.0)
		rgba = [
			0
			0
			0
			255
		]
		z = 500}
	displaySprite \{parent = setlist_original_artist
		id = sl_oa_fore
		tex = white
		just = [
			center
			top
		]
		dims = (130.0, 25.0)
		Pos = (50.0, 0.0)
		rgba = [
			223
			223
			223
			255
		]
		z = 501}
	displayText \{parent = setlist_original_artist
		id = sl_oa_asmade
		text = "AS MADE"
		font = text_a3
		just = [
			center
			top
		]
		Pos = (50.0, -25.0)
		z = 502
		Scale = (0.8, 0.5)
		rgba = [
			223
			223
			223
			255
		]
		noshadow}
	fit_text_in_rectangle id = <id> dims = (75.0, 15.0)
	displayText \{parent = setlist_original_artist
		id = sl_oa_famousby
		text = "FAMOUS BY"
		just = [
			center
			top
		]
		font = text_a3
		Pos = (50.0, 0.0)
		z = 502
		Scale = (0.72499996, 0.5)
		rgba = [
			0
			0
			0
			255
		]
		noshadow}
	fit_text_in_rectangle id = <id> dims = (90.0, 15.0)
endscript

script create_as_made_famous_by_PSWii 
	; all this changes is the rectangle positions i couldnt just make a position variable and change it accordingly for whatever reason - evie
	CreateScreenElement \{Type = ContainerElement
		parent = root_window
		id = setlist_original_artist
		rot_angle = -7
		alpha = 0}
	displaySprite \{parent = setlist_original_artist
		id = sl_oa_back
		tex = white
		dims = (130.0, 50.0)
		just = [
			center
			top
		]
		Pos = (50.0, -12.5)
		rgba = [
			0
			0
			0
			255
		]
		z = 500}
	displaySprite \{parent = setlist_original_artist
		id = sl_oa_fore
		tex = white
		just = [
			center
			top
		]
		dims = (130.0, 25.0)
		Pos = (50.0, 12.5)
		rgba = [
			223
			223
			223
			255
		]
		z = 501}
	displayText \{parent = setlist_original_artist
		id = sl_oa_asmade
		text = "AS MADE"
		font = text_a3
		just = [
			center
			top
		]
		Pos = (50.0, -25.0)
		z = 502
		Scale = (0.8, 0.5)
		rgba = [
			223
			223
			223
			255
		]
		noshadow}
	fit_text_in_rectangle id = <id> dims = (75.0, 15.0)
	displayText \{parent = setlist_original_artist
		id = sl_oa_famousby
		text = "FAMOUS BY"
		just = [
			center
			top
		]
		font = text_a3
		Pos = (50.0, 0.0)
		z = 502
		Scale = (0.72499996, 0.5)
		rgba = [
			0
			0
			0
			255
		]
		noshadow}
	fit_text_in_rectangle id = <id> dims = (90.0, 15.0)
endscript

script animate_as_made_famous_by \{Pos = (0.0, 0.0)
		time = 0.25}
	if ScreenElementExists \{id = setlist_original_artist}
		setlist_original_artist :SetProps Pos = <Pos>
		DoScreenElementMorph id = setlist_original_artist alpha = 1 time = <time>
	endif
endscript

script set_song_icon 
	if NOT gotparam \{no_wait}
		wait \{0.5
			seconds}
	endif
	if NOT gotparam \{song}
		<song> = ($target_setlist_songpreview)
	endif
	if (<song> = none && $current_tab = tab_setlist)
		return
	endif
	if ($current_tab = tab_setlist)
		get_tier_from_song song = <song>
		get_progression_globals game_mode = ($game_mode)
		formattext checksumname = tiername 'tier%d' d = <tier_number>
		if structurecontains structure = ($<tier_global>.<tiername>) setlist_icon
			song_icon = ($<tier_global>.<tiername>.setlist_icon)
		else
			song_icon = setlist_icon_generic
		endif
	elseif ($current_tab = tab_downloads)
		song_icon = setlist_icon_download
	else
		song_icon = setlist_icon_generic
	endif
	mini_rot = RandomRange (-5.0, 5.0)
	if screenelementexists \{id = sl_clipart}
		setscreenelementprops id = sl_clipart texture = <song_icon>
		doscreenelementmorph id = sl_clipart alpha = 1 time = 0.25 rot_angle = <mini_rot>
	endif
	if screenelementexists \{id = sl_clipart_shadow}
		setscreenelementprops id = sl_clipart_shadow texture = <song_icon>
		doscreenelementmorph id = sl_clipart_shadow alpha = 1 time = 0.25 rot_angle = <mini_rot>
	endif
	if screenelementexists \{id = sl_clip}
		getscreenelementprops \{id = sl_clip}
		rot_clip_a = <rot_angle>
		rot_clip_b = (<rot_clip_a> + 10)
		setscreenelementprops id = sl_clip rot_angle = <rot_clip_b>
		doscreenelementmorph id = sl_clip alpha = 1 rot_angle = <rot_clip_a> time = 0.25
	endif
	if ScreenElementExists \{id = setlist_original_artist}
		setlist_original_artist :SetProps \{alpha = 0}
	endif
	if NOT (<song> = none)
		get_song_original_artist song = <song>
		if ($we_have_songs = true && <original_artist> = 0)
			if screenelementexists \{id = sl_clipart}
				getscreenelementprops \{id = sl_clipart}
				animate_as_made_famous_by Pos = (<Pos> + (110.0, 120.0)) time = 0.25
			endif
		endif
	endif
endscript

script clear_setlist_clip_and_art 
	if ScreenElementExists \{id = setlist_original_artist}
		SetScreenElementProps \{id = setlist_original_artist
			alpha = 0}
	endif
	if ScreenElementExists \{id = sl_clipart}
		SetScreenElementProps \{id = sl_clipart
			alpha = 0}
	endif
	if ScreenElementExists \{id = sl_clipart_shadow}
		SetScreenElementProps \{id = sl_clipart_shadow
			alpha = 0}
	endif
	if ScreenElementExists \{id = sl_clip}
		SetScreenElementProps \{id = sl_clip
			alpha = 0}
	endif
endscript

script create_sl_assets 
	CreateScreenElement \{Type = ContainerElement
		PARENT = root_window
		Id = setlist_menu
		Pos = (0.0, 0.0)
		just = [
			LEFT
			Top
		]}
	if NOT ScreenElementExists \{Id = setlist_bg_container}
		CreateScreenElement \{Type = ContainerElement
			PARENT = root_window
			Id = setlist_bg_container
			Pos = (0.0, 0.0)
			just = [
				LEFT
				Top
			]}
	endif
	displaySprite \{Id = sl_bg_head
		PARENT = setlist_menu
		tex = Setlist_BG_Head
		Pos = (0.0, 0.0)
		Dims = (1280.0, 676.0)
		Z = 3.1}
	displaySprite \{Id = sl_bg_loop
		PARENT = setlist_menu
		tex = Setlist_BG_Loop
		Pos = $setlist_background_loop_pos
		Dims = (1280.0, 1352.0)
		Z = 3.1}
	begin
	displaySprite \{PARENT = setlist_menu
		tex = Setlist_Shoeprint
		Pos = (850.0, -70.0)
		Dims = (640.0, 768.0)
		Alpha = 0.15
		Z = 3.2
		flip_v
		Rot_Angle = 10
		BlendMode = Subtract}
	repeat 3
	displaySprite \{Id = sl_page3_head
		PARENT = setlist_menu
		tex = Setlist_Page3_Head
		Pos = $setlist_page3_pos
		Dims = (922.0, 614.0)
		Z = $setlist_page3_z}
	displaySprite \{Id = sl_page2_head
		PARENT = setlist_menu
		tex = Setlist_Page2_Head
		Pos = $setlist_page2_pos
		Dims = (819.0, 553.0)
		Z = $setlist_page2_z}
	displaySprite \{flip_h
		Id = sl_page1_head
		PARENT = setlist_menu
		tex = Setlist_Page1_Head
		Pos = (160.0, 0.0)
		Dims = (922.0, 768.0)
		Z = $setlist_page1_z}
	displaySprite PARENT = setlist_menu tex = Setlist_Page1_Line_Red Pos = (320.0, 12.0) Dims = (8.0, 6400.0) Z = ($setlist_page1_z + 0.1)
	<title_pos> = (300.0, 383.0)
	displaySprite Id = sl_page1_head_lines PARENT = setlist_menu tex = Setlist_Page1_Head_Lines Pos = (176.0, 64.0) Dims = (896.0, 320.0) Z = ($setlist_page1_z + 0.1)
	<begin_line> = (176.0, 420.0)
	<solid_line_pos> = (176.0, 340.0)
	<dotted_line_pos> = (176.0, 380.0)
	<dotted_line_add> = ($setlist_solid_line_add)
	begin
	<Line> = Random (@ ($setlist_solid_lines [0]) @ ($setlist_solid_lines [1]) @ ($setlist_solid_lines [2]) )
	<solid_line_pos> = (<solid_line_pos> + $setlist_solid_line_add)
	displaySprite PARENT = setlist_menu tex = <Line> Pos = <solid_line_pos> Dims = (883.0, 16.0) Z = ($setlist_page1_z + 0.1)
	repeat 8
	begin
	<Line> = Random (@ ($setlist_dotted_lines [0]) @ ($setlist_dotted_lines [1]) @ ($setlist_dotted_lines [2]) )
	<dotted_line_pos> = (<dotted_line_pos> + <dotted_line_add>)
	displaySprite PARENT = setlist_menu tex = <Line> Pos = <dotted_line_pos> Dims = (883.0, 16.0) Z = ($setlist_page1_z + 0.1)
	repeat 8
	<solid_line_pos> = (<solid_line_pos> + $setlist_solid_line_add)
	<dotted_line_pos> = (<dotted_line_pos> + <dotted_line_add>)
	Change setlist_solid_line_pos = <solid_line_pos>
	Change setlist_dotted_line_pos = <dotted_line_pos>
	Change \{setlist_num_songs = 0}
	if English
		setlist_header_tex = Setlist_Page1_Title
	elseif French
		setlist_header_tex = Setlist_Page1_Title_fr
	elseif German
		setlist_header_tex = Setlist_Page1_Title_de
	elseif Spanish
		setlist_header_tex = Setlist_Page1_Title_sp
	elseif Italian
		setlist_header_tex = Setlist_Page1_Title_it
	endif
	if GotParam \{tab_setlist}
		displaySprite Id = sl_page1_title PARENT = setlist_menu tex = <setlist_header_tex> Pos = (330.0, 220.0) Dims = (512.0, 128.0) Alpha = 0.7 Z = ($setlist_page1_z + 0.2) Rot_Angle = 0
		displaySprite PARENT = sl_page1_title tex = <setlist_header_tex> Pos = (-5.0, 10.0) Dims = (512.0, 128.0) Alpha = 0.2 Z = ($setlist_page1_z + 0.2) Rot_Angle = -2
		GetUpperCaseString ($g_gh3_setlist.tier1.Title)
		displayText Id = sl_text_1 PARENT = setlist_menu Scale = (1.0, 1.0) Text = <UpperCaseString> rgba = [195 80 45 255] Pos = <title_pos> Z = $setlist_text_z noshadow
	endif
	if GotParam \{tab_downloads}
		displayText \{PARENT = setlist_menu
			Id = sl_text_1
			Text = "DOWNLOADED SONGS"
			font = text_a10
			Scale = 2
			Pos = (330.0, 220.0)
			rgba = [
				50
				30
				20
				255
			]
			Z = $setlist_text_z
			noshadow}
		displaySprite PARENT = setlist_menu tex = Setlist_Page1_Line_Red Pos = (320.0, 216.0) Dims = (8.0, 6400.0) Z = ($setlist_page1_z - 0.2)
	endif
	if GotParam \{tab_bonus}
		displayText \{PARENT = setlist_menu
			Id = sl_text_1
			Text = "BONUS SONGS"
			font = text_a10
			Scale = 2
			Pos = (330.0, 220.0)
			rgba = [
				50
				30
				20
				255
			]
			Z = $setlist_text_z
			noshadow}
		displaySprite PARENT = setlist_menu tex = Setlist_Page1_Line_Red Pos = (320.0, 216.0) Dims = (8.0, 6400.0) Z = ($setlist_page1_z - 0.2)
	endif
	<text_pos> = (<title_pos> + (40.0, 54.0))
	if ((GotParam tab_setlist) || (GotParam tab_bonus) || (GotParam tab_downloads))
		num_tiers = ($g_gh3_setlist.num_tiers)
		<Tier> = 0
		Change \{setlist_selection_index = 0}
		Change \{setlist_selection_tier = 1}
		Change \{setlist_selection_song = 0}
		Change \{setlist_selection_found = 0}
		begin
		<Tier> = (<Tier> + 1)
		setlist_prefix = ($g_gh3_setlist.prefix)
		FormatText ChecksumName = tiername '%ptier%i' P = <setlist_prefix> I = <Tier>
		FormatText ChecksumName = tier_checksum 'tier%s' S = <Tier>
		GetGlobalTags <tiername> Param = unlocked
		if (<unlocked> = 1 || $is_network_game = 1)
			if NOT (<Tier> = 1)
				<text_pos> = (<text_pos> + (-40.0, 110.0))
				GetUpperCaseString ($g_gh3_setlist.<tier_checksum>.Title)
				displayText PARENT = setlist_menu Scale = (1.0, 1.0) Text = <UpperCaseString> rgba = [190 75 40 255] Pos = <text_pos> Z = $setlist_text_z noshadow
				<text_pos> = (<text_pos> + (40.0, 50.0))
			endif
			Change \{we_have_songs = FALSE}
			GetArraySize ($g_gh3_setlist.<tier_checksum>.songs)
			num_songs = <array_Size>
			num_songs_unlocked = 0
			song_count = 0
			if (<array_Size> > 0)
				begin
				setlist_prefix = ($g_gh3_setlist.prefix)
				FormatText ChecksumName = song_checksum '%p_song%i_tier%s' P = <setlist_prefix> I = (<song_count> + 1) S = <Tier> AddToStringLookup = TRUE
				for_bonus = 0
				if ($current_tab = tab_bonus)
					<for_bonus> = 1
				endif
				if IsSongAvailable song_checksum = <song_checksum> Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>]) for_bonus = <for_bonus>
					if ($setlist_selection_found = 0)
						Change setlist_selection_tier = <Tier>
						Change setlist_selection_song = <song_count>
						Change \{setlist_selection_found = 1}
					endif
					get_song_title Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					get_song_prefix Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					get_song_artist Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					FormatText \{ChecksumName = textid
						'id_song%i'
						I = $setlist_num_songs
						AddToStringLookup = TRUE}
					CreateScreenElement {
						Type = TextElement
						Id = <textid>
						PARENT = setlist_menu
						Scale = (0.85, 0.85)
						Text = <Song_Title>
						Pos = <text_pos>
						rgba = [50 30 10 255]
						z_priority = $setlist_text_z
						font = text_a5
						just = [LEFT Top]
						font_spacing = 0.5
						no_shadow
						shadow_offs = (1.0, 1.0)
						shadow_rgba = [0 0 0 255]
					}
					get_difficulty_text_nl DIFFICULTY = ($current_difficulty)
					get_song_prefix Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					FormatText ChecksumName = songname '%s_%d' S = <song_prefix> D = <difficulty_text_nl>
					GetGlobalTags <song_checksum>
					GetGlobalTags <songname>
					if ($game_mode = p1_quickplay)
						get_quickplay_song_stars Song = <song_prefix>
					endif
					if NOT ($game_mode = training || $game_mode = p2_faceoff || $game_mode = p2_pro_faceoff || $game_mode = p2_battle)
						if Progression_IsBossSong tier_global = $g_gh3_setlist Tier = <Tier> Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
							STARS = 0
						endif
						if ($game_mode = p1_quickplay)
							GetGlobalTags <songname> Param = percent100
						else
							GetGlobalTags <song_checksum> Param = percent100
						endif
						if (<STARS> > 2)
							<star_space> = (20.0, 0.0)
							<star_pos> = (<text_pos> + (660.0, 0.0))
							begin
							if (<percent100> = 1)
								<Star> = Setlist_Goldstar
							else
								<Star> = Random (@ ($setlist_loop_stars [0]) @ ($setlist_loop_stars [1]) @ ($setlist_loop_stars [2]) )
							endif
							<star_pos> = (<star_pos> - <star_space>)
							displaySprite PARENT = setlist_menu tex = <Star> rgba = [233 205 166 255] Z = $setlist_text_z Pos = <star_pos>
							repeat <STARS>
						endif
						GetGlobalTags <song_checksum> Param = Score
						if ($game_mode = p1_quickplay)
							get_quickplay_song_score Song = <song_prefix>
						endif
						if (<Score> > 0)
							if Progression_IsBossSong tier_global = $g_gh3_setlist Tier = <Tier> Song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
								if (<Score> = 1)
									FormatText \{TextName = score_text
										"WUSSED OUT"}
								else
									FormatText \{TextName = score_text
										"BATTLE WON"}
								endif
							else
								FormatText TextName = score_text "%d" D = <Score> UseCommas
							endif
							<score_pos> = (<text_pos> + (660.0, 40.0))
							CreateScreenElement {
								Type = TextElement
								PARENT = setlist_menu
								Scale = (0.75, 0.75)
								Text = <score_text>
								Pos = <score_pos>
								rgba = [100 120 160 255]
								z_priority = $setlist_text_z
								font = text_a5
								just = [RIGHT Top]
								noshadow
							}
							percent_pos = (<star_pos> - (10.0, 0.0))
							percent_pos = (<percent_pos> + (0.0, 5.0))
							percent_scale = (0.55, 0.55)
							streak_pos = (<score_pos> - (130.0, 0.0))
							streak_pos = (<streak_pos> + (0.0, 5.0))
							streak_scale = (0.55, 0.55)
							GetGlobalTags <songname> Param = percent100
							GetGlobalTags <songname> Param = PercentHit
							GetGlobalTags <songname> Param = NotesHit
							GetGlobalTags <songname> Param = TotalNotes
							FormatText TextName = NotePctText "%i%p" I = <PercentHit> P = "%"
							FormatText TextName = NoteStreakText "%h / %t" H = <NotesHit> T = <TotalNotes>
							if (<percent100> = 1)
 								CreateScreenElement {
									Type = TextElement
									PARENT = setlist_menu
									Scale = <percent_scale>
									Text = <NotePctText>
									Pos = <percent_pos>
									rgba = [250 210 100 255]
									z_priority = $setlist_text_z
									font = fontgrid_title_gh3
									just = [RIGHT Top]
									Shadow
									shadow_offs = (1.0, 1.0)
									shadow_rgba = [0 0 0 255]
								}
							elseif ((<PercentHit> = 100) && (<percent100> = 0))
							 	CreateScreenElement {
									Type = TextElement
									PARENT = setlist_menu
									Scale = <percent_scale>
									Text = <NotePctText>
									Pos = <percent_pos>
									rgba = [80 80 220 255]
									z_priority = $setlist_text_z
									font = fontgrid_title_gh3
									just = [RIGHT Top]
									Shadow
									shadow_offs = (1.0, 1.0)
									shadow_rgba = [0 0 0 255]
								}
							else
								CreateScreenElement {
									Type = TextElement
									PARENT = setlist_menu
									Scale = <percent_scale>
									Text = <NotePctText>
									Pos = <percent_pos>
									rgba = [100 120 160 255]
									z_priority = $setlist_text_z
									font = text_a5
									just = [RIGHT Top]
									noshadow
								}
							endif
							CreateScreenElement {
								Type = TextElement
								PARENT = setlist_menu
								Scale = <streak_scale>
								Text = <NoteStreakText>
								Pos = <streak_pos>
								rgba = [100 120 160 255]
								z_priority = $setlist_text_z
								font = text_a5
								just = [RIGHT Top]
								noshadow
							}
						endif
					endif
					<text_pos> = (<text_pos> + (60.0, 40.0))
					FormatText \{ChecksumName = artistid
						'artist_id%d'
						D = $setlist_num_songs}
					GetUpperCaseString <song_artist>
					song_artist = <UpperCaseString>
					displayText PARENT = setlist_menu Scale = (0.6, 0.6) Id = <artistid> Text = <song_artist> rgba = [60 100 140 255] Pos = <text_pos> Z = $setlist_text_z font_spacing = 1 noshadow
					<text_pos> = (<text_pos> + (-60.0, 40.0))
					Change setlist_num_songs = ($setlist_num_songs + 1)
					num_songs_unlocked = (<num_songs_unlocked> + 1)
					Change \{we_have_songs = TRUE}
				endif
				song_count = (<song_count> + 1)
				repeat <num_songs>
			endif
			if ((($game_mode = p1_career) || ($game_mode = p2_career)) && (GotParam tab_setlist) && $is_demo_mode = 0)
				GetGlobalTags <tiername> Param = Complete
				if (<Complete> = 0)
					GetGlobalTags <tiername> Param = boss_unlocked
					GetGlobalTags <tiername> Param = encore_unlocked
					if (<encore_unlocked> = 1)
						FormatText \{TextName = completeText
							"Beat encore song to continue"}
					elseif (<boss_unlocked> = 1)
						FormatText \{TextName = completeText
							"Beat boss song to continue"}
					else
						GetGlobalTags <tiername> Param = num_songs_to_progress
						FormatText TextName = completeText "Beat %d of %p songs to continue" D = <num_songs_to_progress> P = <num_songs_unlocked>
					endif
					displayText PARENT = setlist_menu Scale = (0.6, 0.6) Text = <completeText> Pos = (<text_pos> + (160.0, 0.0)) Z = $setlist_text_z rgba = [30 30 30 255] noshadow
				endif
			endif
		endif
		repeat <num_tiers>
	endif
	if ((($game_mode = p1_career) || ($game_mode = p2_career)) && $is_demo_mode = 0)
		get_progression_globals game_mode = ($game_mode)
		summation_career_score tier_global = <tier_global>
		FormatText TextName = total_score_text "Career Score: %d" D = <career_score> UseCommas
		displayText {
			PARENT = setlist_menu
			Scale = 0.7
			Text = <total_score_text>
			Pos = ((640.0, 120.0) + (<text_pos>.(0.0, 1.0) * (0.0, 1.0)))
			just = [Center Top]
			Z = $setlist_text_z
			rgba = [30 30 30 255]
			noshadow
		}
	endif
	Change \{setlist_begin_text = $setlist_menu_pos}
	if ($setlist_num_songs > 0)
		retail_menu_focus \{Id = id_song0}
		SetScreenElementProps \{Id = id_song0
			Shadow}
	endif
	CreateScreenElement \{Type = ContainerElement
		PARENT = root_window
		Id = sl_fixed
		Pos = (0.0, 0.0)
		just = [
			LEFT
			Top
		]}
	<clip_pos> = (160.0, 390.0)
	displaySprite Id = sl_clipart PARENT = sl_fixed Pos = <clip_pos> Dims = (160.0, 160.0) Z = ($setlist_text_z + 0.1) rgba = [200 200 200 255]
	displaySprite Id = sl_clipart_shadow PARENT = sl_fixed Pos = (<clip_pos> + (3.0, 3.0)) Dims = (160.0, 160.0) Z = ($setlist_text_z) rgba = [0 0 0 128]
	create_as_made_famous_by
	<clip_pos> = (<clip_pos> + (15.0, 50.0))
	displaySprite Id = sl_clip PARENT = sl_fixed tex = Setlist_Clip just = [-0.5 -0.9] Pos = <clip_pos> Dims = (141.0, 102.0) Z = ($setlist_text_z + 0.2)
	if ($current_tab = tab_setlist)
		hilite_dims = (737.0, 80.0)
	elseif ($current_tab = tab_downloads)
		hilite_dims = (722.0, 80.0)
	elseif ($current_tab = tab_bonus)
		hilite_dims = (690.0, 80.0)
	endif
	displaySprite Id = sl_highlight PARENT = sl_fixed tex = White Pos = (326.0, 428.0) Dims = <hilite_dims> Z = ($setlist_text_z - 0.1) rgba = [255 255 255 128]
	<bg_helper_pos> = (140.0, 585.0)
	<helper_rgba> = [105 65 7 160]
	Change \{user_control_pill_gap = 100}
	if ($current_tab = tab_setlist)
		setlist_show_helperbar Pos = (<bg_helper_pos> + (64.0, 4.0))
	elseif ($current_tab = tab_bonus)
		setlist_show_helperbar {
			Pos = (<bg_helper_pos> + (64.0, 4.0))
			text_option1 = "SETLIST"
			text_option2 = "DOWNLOADS"
			button_option1 = "\\b6"
			button_option2 = "\\b8"
		}
	else
		setlist_show_helperbar {
			Pos = (<bg_helper_pos> + (64.0, 4.0))
			text_option1 = "SETLIST"
			text_option2 = "BONUS"
			button_option1 = "\\b6"
			button_option2 = "\\b7"
		}
	endif
	displaySprite \{Id = sl_overshadow
		rgba = [
			105
			65
			7
			160
		]
		PARENT = root_window
		tex = Setlist_Overshadow
		Pos = (0.0, 0.0)
		Dims = (1280.0, 720.0)
		Z = 5.0}
endscript
