script create_sl_assets 
	createscreenelement \{type = containerelement
		parent = root_window
		id = setlist_menu
		pos = (0.0, 0.0)
		just = [
			left
			top
		]}
	if NOT screenelementexists \{id = setlist_bg_container}
		createscreenelement \{type = containerelement
			parent = root_window
			id = setlist_bg_container
			pos = (0.0, 0.0)
			just = [
				left
				top
			]}
	endif
	displaysprite \{id = sl_bg_head
		parent = setlist_menu
		tex = setlist_bg_head
		pos = (0.0, 0.0)
		dims = (1280.0, 676.0)
		z = 3.1}
	displaysprite \{id = sl_bg_loop
		parent = setlist_menu
		tex = setlist_bg_loop
		pos = $setlist_background_loop_pos
		dims = (1280.0, 1352.0)
		z = 3.1}
	begin
	displaysprite \{parent = setlist_menu
		tex = setlist_shoeprint
		pos = (850.0, -70.0)
		dims = (640.0, 768.0)
		alpha = 0.15
		z = 3.2
		flip_v
		rot_angle = 10
		blendmode = subtract}
	repeat 3
	displaysprite \{id = sl_page3_head
		parent = setlist_menu
		tex = setlist_page3_head
		pos = $setlist_page3_pos
		dims = (922.0, 614.0)
		z = $setlist_page3_z}
	displaysprite \{id = sl_page2_head
		parent = setlist_menu
		tex = setlist_page2_head
		pos = $setlist_page2_pos
		dims = (819.0, 553.0)
		z = $setlist_page2_z}
	displaysprite \{flip_h
		id = sl_page1_head
		parent = setlist_menu
		tex = setlist_page1_head
		pos = (160.0, 0.0)
		dims = (922.0, 768.0)
		z = $setlist_page1_z}
	displaysprite parent = setlist_menu tex = setlist_page1_line_red pos = (320.0, 12.0) dims = (8.0, 6400.0) z = ($setlist_page1_z + 0.1)
	<title_pos> = (300.0, 383.0)
	displaysprite id = sl_page1_head_lines parent = setlist_menu tex = setlist_page1_head_lines pos = (176.0, 64.0) dims = (896.0, 320.0) z = ($setlist_page1_z + 0.1)
	<begin_line> = (176.0, 420.0)
	<solid_line_pos> = (176.0, 340.0)
	<dotted_line_pos> = (176.0, 380.0)
	<dotted_line_add> = ($setlist_solid_line_add)
	begin
	<line> = Random (@ ($setlist_solid_lines [0]) @ ($setlist_solid_lines [1]) @ ($setlist_solid_lines [2]) )
	<solid_line_pos> = (<solid_line_pos> + $setlist_solid_line_add)
	displaysprite parent = setlist_menu tex = <line> pos = <solid_line_pos> dims = (883.0, 16.0) z = ($setlist_page1_z + 0.1)
	repeat 8
	begin
	<line> = Random (@ ($setlist_dotted_lines [0]) @ ($setlist_dotted_lines [1]) @ ($setlist_dotted_lines [2]) )
	<dotted_line_pos> = (<dotted_line_pos> + <dotted_line_add>)
	displaysprite parent = setlist_menu tex = <line> pos = <dotted_line_pos> dims = (883.0, 16.0) z = ($setlist_page1_z + 0.1)
	repeat 8
	<solid_line_pos> = (<solid_line_pos> + $setlist_solid_line_add)
	<dotted_line_pos> = (<dotted_line_pos> + <dotted_line_add>)
	change setlist_solid_line_pos = <solid_line_pos>
	change setlist_dotted_line_pos = <dotted_line_pos>
	change \{setlist_num_songs = 0}
	if english
		setlist_header_tex = setlist_page1_title
	elseif french
		setlist_header_tex = setlist_page1_title_fr
	elseif german
		setlist_header_tex = setlist_page1_title_de
	elseif spanish
		setlist_header_tex = setlist_page1_title_sp
	elseif italian
		setlist_header_tex = setlist_page1_title_it
	endif
	if gotparam \{tab_setlist}
		displaysprite id = sl_page1_title parent = setlist_menu tex = <setlist_header_tex> pos = (330.0, 220.0) dims = (512.0, 128.0) alpha = 0.7 z = ($setlist_page1_z + 0.2) rot_angle = 0
		displaysprite parent = sl_page1_title tex = <setlist_header_tex> pos = (-5.0, 10.0) dims = (512.0, 128.0) alpha = 0.2 z = ($setlist_page1_z + 0.2) rot_angle = -2
		getuppercasestring ($g_gh3_setlist.tier1.title)
		displaytext id = sl_text_1 parent = setlist_menu scale = (1.0, 1.0) text = <uppercasestring> rgba = [195 80 45 255] pos = <title_pos> z = $setlist_text_z noshadow
	endif
	if gotparam \{tab_downloads}
		displaytext \{parent = setlist_menu
			id = sl_text_1
			text = "DOWNLOADED SONGS"
			font = text_a10
			scale = 2
			pos = (330.0, 220.0)
			rgba = [
				50
				30
				20
				255
			]
			z = $setlist_text_z
			noshadow}
		displaysprite parent = setlist_menu tex = setlist_page1_line_red pos = (320.0, 216.0) dims = (8.0, 6400.0) z = ($setlist_page1_z - 0.2)
	endif
	if gotparam \{tab_bonus}
		displaytext \{parent = setlist_menu
			id = sl_text_1
			text = "BONUS SONGS"
			font = text_a10
			scale = 2
			pos = (330.0, 220.0)
			rgba = [
				50
				30
				20
				255
			]
			z = $setlist_text_z
			noshadow}
		displaysprite parent = setlist_menu tex = setlist_page1_line_red pos = (320.0, 216.0) dims = (8.0, 6400.0) z = ($setlist_page1_z - 0.2)
	endif
	<text_pos> = (<title_pos> + (40.0, 54.0))
	if ((gotparam tab_setlist) || (gotparam tab_bonus) || (gotparam tab_downloads))
		num_tiers = ($g_gh3_setlist.num_tiers)
		<tier> = 0
		change \{setlist_selection_index = 0}
		change \{setlist_selection_tier = 1}
		change \{setlist_selection_song = 0}
		change \{setlist_selection_found = 0}
		begin
		<tier> = (<tier> + 1)
		setlist_prefix = ($g_gh3_setlist.prefix)
		formattext checksumname = tiername '%ptier%i' p = <setlist_prefix> i = <tier>
		formattext checksumname = tier_checksum 'tier%s' s = <tier>
		getglobaltags <tiername> param = unlocked
		if (<unlocked> = 1 || $is_network_game = 1)
			if NOT (<tier> = 1)
				<text_pos> = (<text_pos> + (-40.0, 110.0))
				getuppercasestring ($g_gh3_setlist.<tier_checksum>.title)
				displaytext parent = setlist_menu scale = (1.0, 1.0) text = <uppercasestring> rgba = [190 75 40 255] pos = <text_pos> z = $setlist_text_z noshadow
				<text_pos> = (<text_pos> + (40.0, 50.0))
			endif
			change \{we_have_songs = false}
			getarraysize ($g_gh3_setlist.<tier_checksum>.songs)
			num_songs = <array_size>
			num_songs_unlocked = 0
			song_count = 0
			if (<array_size> > 0)
				begin
				setlist_prefix = ($g_gh3_setlist.prefix)
				formattext checksumname = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1) s = <tier> addtostringlookup = true
				for_bonus = 0
				if ($current_tab = tab_bonus)
					<for_bonus> = 1
				endif
				if issongavailable song_checksum = <song_checksum> song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>]) for_bonus = <for_bonus>
					if ($setlist_selection_found = 0)
						change setlist_selection_tier = <tier>
						change setlist_selection_song = <song_count>
						change \{setlist_selection_found = 1}
					endif
					get_song_title song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					get_song_prefix song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					get_song_artist song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					formattext \{checksumname = textid
						'id_song%i'
						i = $setlist_num_songs
						addtostringlookup = true}
					createscreenelement {
						type = textelement
						id = <textid>
						parent = setlist_menu
						scale = (0.85, 0.85)
						text = <song_title>
						pos = <text_pos>
						rgba = [50 30 10 255]
						z_priority = $setlist_text_z
						font = text_a5
						just = [left top]
						font_spacing = 0.5
						no_shadow
						shadow_offs = (1.0, 1.0)
						shadow_rgba = [0 0 0 255]
					}
					get_difficulty_text_nl difficulty = ($current_difficulty)
					get_song_prefix song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
					formattext checksumname = songname '%s_%d' s = <song_prefix> d = <difficulty_text_nl>
					getglobaltags <song_checksum>
					getglobaltags <songname>
					if ($game_mode = p1_quickplay || $game_mode = p1_bass_quickplay)
						get_quickplay_song_stars song = <song_prefix>
					endif
					if NOT ($game_mode = training || $game_mode = p2_faceoff || $game_mode = p2_pro_faceoff || $game_mode = p2_battle)
						if progression_isbosssong tier_global = $g_gh3_setlist tier = <tier> song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
							stars = 0
						endif
						if ($game_mode = p1_quickplay || $game_mode = p1_bass_quickplay)
							getglobaltags <songname> param = percent100
						else
							getglobaltags <song_checksum> param = percent100
						endif
						if (<stars> > 2)
							<star_space> = (20.0, 0.0)
							<star_pos> = (<text_pos> + (660.0, 0.0))
							begin
							if (<percent100> = 1)
								<star> = setlist_goldstar
							else
								<star> = Random (@ ($setlist_loop_stars [0]) @ ($setlist_loop_stars [1]) @ ($setlist_loop_stars [2]) )
							endif
							<star_pos> = (<star_pos> - <star_space>)
							displaysprite parent = setlist_menu tex = <star> rgba = [233 205 166 255] z = $setlist_text_z pos = <star_pos>
							repeat <stars>
						endif
						getglobaltags <song_checksum> param = score
						if ($game_mode = p1_quickplay || $game_mode = p1_bass_quickplay)
							get_quickplay_song_score song = <song_prefix>
						endif
						if (<score> > 0)
							if progression_isbosssong tier_global = $g_gh3_setlist tier = <tier> song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])
								if (<score> = 1)
									formattext \{textname = score_text
										"WUSSED OUT"}
								else
									formattext \{textname = score_text
										"BATTLE WON"}
								endif
							else
								formattext textname = score_text "%d" d = <score> usecommas
							endif
							<score_pos> = (<text_pos> + (660.0, 40.0))
							createscreenelement {
								type = textelement
								parent = setlist_menu
								scale = (0.75, 0.75)
								text = <score_text>
								pos = <score_pos>
								rgba = [100 120 160 255]
								z_priority = $setlist_text_z
								font = text_a5
								just = [right top]
								noshadow
							}
						endif
					endif
					<text_pos> = (<text_pos> + (60.0, 40.0))
					formattext \{checksumname = artistid
						'artist_id%d'
						d = $setlist_num_songs}
					getuppercasestring <song_artist>
					song_artist = <uppercasestring>
					displaytext parent = setlist_menu scale = (0.6, 0.6) id = <artistid> text = <song_artist> rgba = [60 100 140 255] pos = <text_pos> z = $setlist_text_z font_spacing = 1 noshadow
					<text_pos> = (<text_pos> + (-60.0, 40.0))
					change setlist_num_songs = ($setlist_num_songs + 1)
					num_songs_unlocked = (<num_songs_unlocked> + 1)
					change \{we_have_songs = true}
				endif
				song_count = (<song_count> + 1)
				repeat <num_songs>
			endif
			if ((($game_mode = p1_career) || ($game_mode = p2_career)) && (gotparam tab_setlist) && $is_demo_mode = 0)
				getglobaltags <tiername> param = complete
				if (<complete> = 0)
					getglobaltags <tiername> param = boss_unlocked
					getglobaltags <tiername> param = encore_unlocked
					if (<encore_unlocked> = 1)
						formattext \{textname = completetext
							"Beat encore song to continue"}
					elseif (<boss_unlocked> = 1)
						formattext \{textname = completetext
							"Beat boss song to continue"}
					else
						getglobaltags <tiername> param = num_songs_to_progress
						formattext textname = completetext "Beat %d of %p songs to continue" d = <num_songs_to_progress> p = <num_songs_unlocked>
					endif
					displaytext parent = setlist_menu scale = (0.6, 0.6) text = <completetext> pos = (<text_pos> + (160.0, 0.0)) z = $setlist_text_z rgba = [30 30 30 255] noshadow
				endif
			endif
		endif
		repeat <num_tiers>
	endif
	if ((($game_mode = p1_career) || ($game_mode = p2_career)) && $is_demo_mode = 0)
		get_progression_globals game_mode = ($game_mode)
		summation_career_score tier_global = <tier_global>
		formattext textname = total_score_text "Career Score: %d" d = <career_score> usecommas
		displaytext {
			parent = setlist_menu
			scale = 0.7
			text = <total_score_text>
			pos = ((640.0, 120.0) + (<text_pos>.(0.0, 1.0) * (0.0, 1.0)))
			just = [center top]
			z = $setlist_text_z
			rgba = [30 30 30 255]
			noshadow
		}
	endif
	change \{setlist_begin_text = $setlist_menu_pos}
	if ($setlist_num_songs > 0)
		retail_menu_focus \{id = id_song0}
		setscreenelementprops \{id = id_song0
			shadow}
	endif
	createscreenelement \{type = containerelement
		parent = root_window
		id = sl_fixed
		pos = (0.0, 0.0)
		just = [
			left
			top
		]}
	<clip_pos> = (160.0, 390.0)
	displaysprite id = sl_clipart parent = sl_fixed pos = <clip_pos> dims = (160.0, 160.0) z = ($setlist_text_z + 0.1) rgba = [200 200 200 255]
	displaysprite id = sl_clipart_shadow parent = sl_fixed pos = (<clip_pos> + (3.0, 3.0)) dims = (160.0, 160.0) z = ($setlist_text_z) rgba = [0 0 0 128]
	<clip_pos> = (<clip_pos> + (15.0, 50.0))
	displaysprite id = sl_clip parent = sl_fixed tex = setlist_clip just = [-0.5 -0.9] pos = <clip_pos> dims = (141.0, 102.0) z = ($setlist_text_z + 0.2)
	if ($current_tab = tab_setlist)
		hilite_dims = (737.0, 80.0)
	elseif ($current_tab = tab_downloads)
		hilite_dims = (722.0, 80.0)
	elseif ($current_tab = tab_bonus)
		hilite_dims = (690.0, 80.0)
	endif
	displaysprite id = sl_highlight parent = sl_fixed tex = white pos = (326.0, 428.0) dims = <hilite_dims> z = ($setlist_text_z - 0.1) rgba = [255 255 255 128]
	<bg_helper_pos> = (140.0, 585.0)
	<helper_rgba> = [105 65 7 160]
	change \{user_control_pill_gap = 100}
	if ($current_tab = tab_setlist)
		setlist_show_helperbar pos = (<bg_helper_pos> + (64.0, 4.0))
	elseif ($current_tab = tab_bonus)
		setlist_show_helperbar {
			pos = (<bg_helper_pos> + (64.0, 4.0))
			text_option1 = "SETLIST"
			text_option2 = "DOWNLOADS"
			button_option1 = "\\b6"
			button_option2 = "\\b8"
		}
	else
		setlist_show_helperbar {
			pos = (<bg_helper_pos> + (64.0, 4.0))
			text_option1 = "SETLIST"
			text_option2 = "BONUS"
			button_option1 = "\\b6"
			button_option2 = "\\b7"
		}
	endif
	displaysprite \{id = sl_overshadow
		rgba = [
			105
			65
			7
			160
		]
		parent = root_window
		tex = setlist_overshadow
		pos = (0.0, 0.0)
		dims = (1280.0, 720.0)
		z = 5.0}
endscript