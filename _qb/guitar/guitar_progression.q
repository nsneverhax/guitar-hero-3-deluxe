script Progression_SongWon 
	Printf \{"Progression_SongWon"}
	additional_cash = 0
	Change \{progression_beat_game_last_song = 0}
	Change \{progression_unlock_tier_last_song = 0}
	Change \{progression_got_sponsored_last_song = 0}
	Change \{progression_play_completion_movie = 0}
	Player = 1
	begin
	FormatText ChecksumName = player_status 'player%i_status' I = <Player>
	new_stars = 3
	if ($<player_status>.Score >= $<player_status>.base_score * 2.8)
		new_stars = 5
	elseif ($<player_status>.Score >= $<player_status>.base_score * 2)
		new_stars = 4
	endif
	Change StructureName = <player_status> STARS = <new_stars>
	Player = (<Player> + 1)
	repeat $current_num_players
	get_difficulty_text_nl DIFFICULTY = ($current_difficulty)
	get_song_prefix Song = ($current_song)
	FormatText ChecksumName = songname '%s_%d' S = <song_prefix> D = <difficulty_text_nl>
	if ($player1_status.total_notes > 0)
		p1_percent_complete = (100 * $player1_status.NOTES_HIT / $player1_status.total_notes)
		SetGlobalTags <songname> Params = {PercentHit = <p1_percent_complete>}
		if (<p1_percent_complete> = 100)
			if ($game_mode = p1_quickplay)
				SetGlobalTags <songname> Params = {percent100 = 1}
			endif
			if ($game_mode = p1_quickplay ||
					$game_mode = p1_career)
				SetGlobalTags <songname> Params = {achievement_gold_star = 1}
			endif
		endif
	endif
	if ($game_mode = p1_career ||
			$game_mode = p2_career)
		get_progression_globals game_mode = ($game_mode) use_current_tab = 1
		SongList = <tier_global>
		get_band_game_mode_name
		FormatText ChecksumName = bandname_id 'band%i_info_%g' I = ($current_band) G = <game_mode_name>
		SetGlobalTags <bandname_id> Params = {first_play = 0}
		GetGlobalTags \{Progression
			Params = current_tier}
		GetGlobalTags \{Progression
			Params = current_song_count}
		song_count = <current_song_count>
		if GotParam \{current_tier}
			setlist_prefix = ($<SongList>.prefix)
			FormatText ChecksumName = song_checksum '%p_song%i_tier%s' P = <setlist_prefix> I = (<song_count> + 1) S = <current_tier> AddToStringLookup = TRUE
			FormatText ChecksumName = tier_checksum 'tier%s' S = <current_tier>
			if Progression_IsBossSong tier_global = <tier_global> Tier = <current_tier> Song = (<tier_global>.<tier_checksum>.songs [<song_count>])
				Change \{StructureName = player1_status
					STARS = 5}
			endif
			GetGlobalTags <song_checksum> Param = STARS
			GetGlobalTags <song_checksum> Param = Score
			if ($game_mode = p1_career)
				new_score = ($player1_status.Score)
				new_stars = ($player1_status.STARS)
			else
				new_score = ($player1_status.Score + $player2_status.Score)
				new_stars = (($player1_status.STARS + $player1_status.STARS) / 2)
			endif
			GetGlobalTags <song_checksum> Param = PercentHit
			if ($player1_status.total_notes > 0)
				if (<p1_percent_complete> = 100)
					SetGlobalTags <song_checksum> Params = {percent100 = 1}
				endif
			endif
			if (<new_stars> > <STARS>)
				SetGlobalTags <song_checksum> Params = {STARS = <new_stars>}
				if ($current_tab = tab_setlist)
					if NOT StructureContains Structure = (<tier_global>.<tier_checksum>) nocash
						Progression_AwardCash old_stars = <STARS> new_stars = <new_stars>
					endif
				endif
			endif
			if (<new_score> > <Score>)
				CastToInteger \{new_score}
				SetGlobalTags <song_checksum> Params = {Score = <new_score>}
			endif
			Progression_CalcSetlistNextSong tier_global = <tier_global>
		endif
	endif
	Achievements_SongWon additional_cash = <additional_cash>
	if ($game_mode = p1_career || $game_mode = p2_career)
		UpdateAtoms \{Name = Progression}
	endif
	Change \{Achievements_SongWonFlag = 1}
	UpdateAtoms \{Name = Achievement}
endscript
script create_newspaper_menu \{for_practice = 0}
	menu_song_complete_sound
	StopSoundsByBuss \{BinkCutScenes}
	disable_pause
	my_song = ($current_song)
	if NOT ($old_song = NONE)
		my_song = ($old_song)
		Change \{old_song = NONE}
	endif
	set_focus_color \{rgba = $g_ss_offwhite}
	set_unfocus_color \{rgba = $g_ss_black}
	show_replay = 1
	replay_flow_params = {action = try_again}
	if ($game_mode = p1_quickplay)
		menu_top_rockers_check_for_new_top_score \{nowrite = 1}
		if NOT (<new_score> = -1)
			show_replay = 0
		endif
		if (<newbestscore> = 1)
			replay_flow_params = {action = save_and_try_again}
		endif
	endif
	if ($game_mode = training)
		if ($menu_choose_practice_destroy_previous_menu = 0)
			LaunchEvent \{Type = Focus
				Target = newspaper_vmenu}
			return
		endif
		if ViewportExists \{Id = Bg_Viewport}
			disable_bg_viewport
		endif
		if ScreenElementExists \{Id = practice_sectiontext}
			SetScreenElementProps \{Id = practice_sectiontext
				Alpha = 0}
		endif
		Change \{g_np_options_index = 4}
		Player = 1
		begin
		FormatText ChecksumName = player_status 'player%i_status' I = <Player> AddToStringLookup
		FormatText TextName = player_Text 'p%i' I = <Player> AddToStringLookup
		destroy_hud <...>
		repeat $max_num_players
	endif
	np_event_handlers = [
		{pad_up np_scroll_up Params = {for_practice = <for_practice> show_replay = <show_replay>}}
		{pad_down np_scroll_down Params = {for_practice = <for_practice> show_replay = <show_replay>}}
	]
	if ($player1_status.bot_play = 1)
		exclusive_device = ($primary_controller)
	else
		if ($game_mode = p2_career ||
				$game_mode = p2_faceoff ||
				$game_mode = p2_pro_faceoff ||
				$game_mode = p2_battle)
			exclusive_mp_controllers = [0 , 0]
			SetArrayElement ArrayName = exclusive_mp_controllers Index = 0 NewValue = ($player1_device)
			SetArrayElement ArrayName = exclusive_mp_controllers Index = 1 NewValue = ($player2_device)
			exclusive_device = <exclusive_mp_controllers>
		else
			exclusive_device = ($primary_controller)
		endif
	endif
	new_menu scrollid = newspaper_scroll vmenuid = newspaper_vmenu use_backdrop = 0 event_handlers = <np_event_handlers> exclusive_device = <exclusive_device>
	if ($game_mode = p2_coop)
		STARS = (($player1_status.STARS + $player2_status.STARS) / 2)
	else
		STARS = ($player1_status.STARS)
	endif
	p1_score = ($player1_status.Score)
	p2_score = ($player2_status.Score)
	p1_health = ($player1_status.current_health)
	p2_health = ($player2_status.current_health)
	p1_note_streak = ($player1_status.best_run)
	p2_note_streak = ($player2_status.best_run)
	p1_percent_complete = 0
	if ($player1_status.total_notes > 0)
		<p1_percent_complete> = (100 * $player1_status.NOTES_HIT / $player1_status.total_notes)
	endif
	p2_percent_complete = 0
	if ($player2_status.total_notes > 0)
		<p2_percent_complete> = (100 * $player2_status.NOTES_HIT / $player2_status.total_notes)
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		<p1_score> = (<p1_score> + <p2_score>)
		if (<p1_note_streak> < <p2_note_streak>)
			<p1_note_streak> = <p2_note_streak>
		endif
		if (<p1_percent_complete> < <p2_percent_complete>)
			<p1_percent_complete> = <p2_percent_complete>
		endif
	endif
	CastToInteger \{p1_score}
	CastToInteger \{p2_score}
	CreateScreenElement \{Type = ContainerElement
		PARENT = root_window
		Id = newspaper_container
		Pos = (0.0, 0.0)}
	FormatText TextName = p1_note_streak_text "%d" D = <p1_note_streak>
	FormatText TextName = p2_note_streak_text "%d" D = <p2_note_streak>
	FormatText TextName = p1_score_text "%s" S = <p1_score>
	FormatText TextName = p2_score_text "%s" S = <p2_score>
	get_progression_globals game_mode = ($game_mode) use_current_tab = 1
	GetGlobalTags \{Progression
		Params = current_tier}
	show_stars = 1
	if GotParam \{current_tier}
		if Progression_IsBossSong tier_global = <tier_global> Tier = <current_tier> Song = <my_song>
			show_stars = 0
		endif
	endif
	get_song_title Song = <my_song>
	get_difficulty_text DIFFICULTY = ($current_difficulty)
	if (<STARS> < 3)
		<STARS> = 3
	endif
	offwhite = [223 223 223 255]
	reddish = [170 70 70 255]
	switch <current_tier>
		case 1
		Change \{g_ss_mag_number = 0}
		case 2
		Change \{g_ss_mag_number = 1}
		case 3
		Change \{g_ss_mag_number = 2}
		case 4
		Change \{g_ss_mag_number = 3}
		case 5
		Change \{g_ss_mag_number = 4}
		case 6
		Change \{g_ss_mag_number = 5}
		case 7
		Change \{g_ss_mag_number = 6}
		case 8
		Change \{g_ss_mag_number = 7}
		default
		Change \{g_ss_mag_number = 0}
	endswitch
	if NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay || <for_practice> = 1)
		if NOT ($g_ss_mag_number = 7)
			create_menu_backdrop \{texture = Newspaper_BG_2P}
		else
			create_menu_backdrop \{texture = Song_Summary_BG_HELL_2P}
		endif
		switch $g_ss_mag_number
			case 0
			<ss_logo> = Song_Summary_Logo_BACKYARD
			<ss_logo_sm> = Song_Summary_Logo_BACKYARD_sm
			<ss_sidebar> = Song_Summary_Sidebar_BACKYARD
			<ss_percent_color> = $g_ss_black
			<ss_score_color> = $g_ss_black
			<ss_notestreak_fill_color> = $g_ss_black
			<ss_notestreak_color> = $g_ss_offwhite
			<ss_notestreak_text_color> = $g_ss_offwhite
			case 1
			<ss_logo> = Song_Summary_Logo_BAR
			<ss_logo_sm> = Song_Summary_Logo_BAR_sm
			<ss_sidebar> = Song_Summary_Sidebar_BAR
			<ss_percent_color> = $g_ss_black
			<ss_score_color> = $g_ss_black
			<ss_notestreak_fill_color> = $g_ss_black
			<ss_notestreak_color> = $g_ss_offwhite
			<ss_notestreak_text_color> = $g_ss_offwhite
			case 2
			<ss_logo> = Song_Summary_Logo_Paste
			<ss_logo_sm> = Song_Summary_Logo_Paste_sm
			<ss_sidebar> = Song_Summary_Sidebar_Paste
			<ss_percent_color> = $g_ss_Paste_maroonish
			<ss_score_color> = $g_ss_Paste_brownish
			<ss_notestreak_fill_color> = $g_ss_Paste_beigeish
			<ss_notestreak_color> = $g_ss_Paste_maroonish
			<ss_notestreak_text_color> = $g_ss_Paste_brownish
			case 3
			<ss_logo> = Song_Summary_Logo_Decibel
			<ss_logo_sm> = Song_Summary_Logo_Decibel_sm
			<ss_sidebar> = Song_Summary_Sidebar_Decibel
			<ss_percent_color> = $g_ss_decibel_magentaish
			<ss_score_color> = $g_ss_black
			<ss_notestreak_fill_color> = $g_ss_decibel_greenish
			<ss_notestreak_color> = $g_ss_decibel_magentaish
			<ss_notestreak_text_color> = $g_ss_black
			case 4
			<ss_logo> = Song_Summary_Logo_AP
			<ss_logo_sm> = Song_Summary_Logo_AP_sm
			<ss_sidebar> = Song_Summary_Sidebar_AP
			<ss_percent_color> = $g_ss_AP_reddish
			<ss_score_color> = $g_ss_AP_blueish
			<ss_notestreak_fill_color> = $g_ss_AP_reddish
			<ss_notestreak_color> = $g_ss_AP_yellowish
			<ss_notestreak_text_color> = $g_ss_AP_yellowish
			case 5
			<ss_logo> = Song_Summary_Logo_Kerrang
			<ss_logo_sm> = Song_Summary_Logo_Kerrang_sm
			<ss_sidebar> = Song_Summary_Sidebar_Kerrang
			<ss_percent_color> = $g_ss_black
			<ss_score_color> = $g_ss_Kerrang_reddish
			<ss_notestreak_fill_color> = $g_ss_black
			<ss_notestreak_color> = $g_ss_offwhite
			<ss_notestreak_text_color> = $g_ss_offwhite
			case 6
			<ss_logo> = Song_Summary_Logo_GPlayer
			<ss_logo_sm> = Song_Summary_Logo_GPlayer_sm
			<ss_sidebar> = Song_Summary_Sidebar_GPlayer
			<ss_percent_color> = $g_ss_GP_greyish
			<ss_score_color> = $g_ss_GP_blueish
			<ss_notestreak_fill_color> = $g_ss_GP_greyish
			<ss_notestreak_color> = $g_ss_offwhite
			<ss_notestreak_text_color> = $g_ss_offwhite
			case 7
			<ss_logo> = Song_Summary_Logo_HELL
			<ss_logo_sm> = Song_Summary_Logo_HELL_sm
			<ss_sidebar> = Song_Summary_Sidebar_HELL
			<ss_percent_color> = $g_ss_black
			<ss_score_color> = [100 15 5 255]
			<ss_notestreak_fill_color> = $g_ss_black
			<ss_notestreak_color> = [150 65 55 255]
			<ss_notestreak_text_color> = $g_ss_HELL_lighter_reddish
		endswitch
		if ($game_mode = p2_battle)
			if (<p2_health> > <p1_health>)
				<winner> = "2"
				<win_sqs> = '2'
				<winner_color> = $g_ss_p2_violetish
			else
				<winner> = "1"
				<win_sqs> = '1'
				<winner_color> = $g_ss_p1_orangeish
			endif
		else
			if (<p2_score> > <p1_score>)
				<winner> = "2"
				<win_sqs> = '2'
				<winner_color> = $g_ss_p2_violetish
			elseif (<p1_score> > <p2_score>)
				<winner> = "1"
				<win_sqs> = '1'
				<winner_color> = $g_ss_p1_orangeish
			else
				<winner> = "0"
				<win_sqs> = '0'
			endif
		endif
		if ($is_network_game)
			do_achievement_check <...>
			UpdateAtoms \{Name = Achievement}
		endif
		if (<win_sqs> = '0')
			rand_status = Random (@ 1 @ 2 )
			FormatText ChecksumName = player_status 'player%i_status' I = <rand_status>
		else
			FormatText ChecksumName = player_status 'player%i_status' I = <win_sqs>
		endif
		if ($game_mode = p2_battle)
			displayText {
				PARENT = newspaper_container
				Text = "EPIC BATTLE"
				just = [LEFT Top]
				Pos = (256.0, 264.0)
				Scale = 0.75
				font = text_a11
				rgba = <winner_color>
				rot = -7.5
				noshadow
			}
			FormatText TextName = winner_text "Player %d" D = <winner>
			if ($is_network_game)
				if (<winner> = "2")
					winner_text = $opponent_gamertag
				else
					if (NetSessionFunc Obj = match func = get_gamertag)
						winner_text = <Name>
					endif
				endif
			endif
			FormatText TextName = who_won_text "%s  Dominates!" S = <winner_text>
			displayText {
				PARENT = newspaper_container
				Text = <who_won_text>
				just = [LEFT Top]
				Pos = (262.0, 302.0)
				Scale = 0.75
				font = text_a11
				rgba = <winner_color>
				rot = -7.5
				noshadow
			}
			<final_blow_powerup> = ($<player_status>.final_blow_powerup)
			if (<final_blow_powerup> > -1)
				CreateScreenElement \{Type = TextBlockElement
					PARENT = newspaper_container
					just = [
						LEFT
						Top
					]
					Pos = (320.0, 415.0)
					Rot_Angle = -7.5
					Scale = 0.45000002
					Text = "FINAL BLOW:"
					font = fontgrid_title_gh3
					rgba = [
						223
						223
						223
						255
					]
					Dims = (300.0, 300.0)}
				SELECT = <final_blow_powerup>
				GetGlobalTags \{user_options}
				if (<winner> = "1")
					is_lefty_flip = <lefty_flip_p2>
				else
					is_lefty_flip = <lefty_flip_p1>
				endif
				if (<SELECT> = 4 && <is_lefty_flip> = 1)
					GetUpperCaseString ($battlemode_powerups [<SELECT>].alt_name_text)
				else
					GetUpperCaseString ($battlemode_powerups [<SELECT>].name_text)
				endif
				final_blow_attack_text = <UpperCaseString>
				final_blow_attack_icon = ($battlemode_powerups [<SELECT>].card_texture)
				CreateScreenElement {
					Type = TextBlockElement
					PARENT = newspaper_container
					just = [LEFT Top]
					internal_just = [LEFT Top]
					Pos = (345.0, 486.0)
					Rot_Angle = -7.5
					Scale = 0.4
					Text = <final_blow_attack_text>
					font = fontgrid_title_gh3
					rgba = [223 223 223 255]
					Dims = (600.0, 200.0)
				}
				FormatText \{ChecksumName = card_checksum
					'battlecard_final_blow'}
				CreateScreenElement {
					Type = SpriteElement
					Id = <card_checksum>
					PARENT = newspaper_container
					texture = <final_blow_attack_icon>
					rgba = [255 255 255 255]
					just = [LEFT Top]
					Rot_Angle = -7.5
					Pos = (286.0, 472.0)
					Dims = (42.0, 42.0)
				}
			endif
		else
			winner_text = <winner>
			FormatText TextName = winner_text "Player %d" D = <winner>
			if ($is_network_game)
				if (<winner> = "2")
					winner_text = $opponent_gamertag
				else
					if (NetSessionFunc Obj = match func = get_gamertag)
						winner_text = <Name>
					endif
				endif
			endif
			if (<winner> = "0")
				who_won_text = "It's a TIE!"
			else
				FormatText TextName = who_won_text "%d Conquers With Authority!" D = <winner_text>
			endif
			CreateScreenElement {
				Type = TextBlockElement
				PARENT = newspaper_container
				just = [LEFT Bottom]
				internal_just = [LEFT Bottom]
				Pos = (270.0, 345.0)
				Scale = 0.7
				Text = <who_won_text>
				font = text_a11
				rgba = <winner_color>
				Dims = (350.0, 200.0)
				line_spacing = 0.85
				Rot_Angle = -7.5
			}
		endif
		displaySprite {
			PARENT = newspaper_container
			tex = <ss_logo>
			Pos = (158.0, 25.0)
		}
		displaySprite {
			PARENT = newspaper_container
			tex = <ss_sidebar>
			Pos = (858.0, 130.0)
		}
		GetUpperCaseString <Song_Title>
		CreateScreenElement {
			Id = ss_song_title_text_block_id
			Type = TextBlockElement
			PARENT = newspaper_container
			just = [LEFT Top]
			internal_just = [LEFT Top]
			Pos = (270.0, 352.0)
			Scale = (0.55, 0.55)
			Text = <UpperCaseString>
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			Dims = (400.0, 134.0)
			line_spacing = 0.85
			Rot_Angle = -7.5
			noshadow
		}
		get_song_artist Song = <my_song>
		GetUpperCaseString <song_artist>
		<band_name> = <UpperCaseString>
		GetScreenElementChildren \{Id = ss_song_title_text_block_id}
		GetArraySize (<children>)
		if (<array_Size> = 1)
			<artist_pos> = (276.0, 386.0)
		else
			<artist_pos> = (280.0, 416.0)
		endif
		if ($g_ss_mag_number = 0 || $g_ss_mag_number = 1)
			<band_name_color> = $g_ss_offwhite
		else
			<band_name_color> = $g_ss_p1_orangeish
		endif
		CreateScreenElement {
			Id = ss_artist_text_block_id
			Type = TextBlockElement
			PARENT = newspaper_container
			just = [LEFT Top]
			internal_just = [LEFT Top]
			Pos = <artist_pos>
			Scale = (0.45000002, 0.45000002)
			Text = <band_name>
			font = text_a4
			rgba = <band_name_color>
			Dims = (400.0, 134.0)
			line_spacing = 0.85
			Rot_Angle = -7.5
		}
		get_difficulty_text_upper DIFFICULTY = ($current_difficulty)
		name_text_1 = "PLAYER 1"
		if ($is_network_game)
			if (NetSessionFunc Obj = match func = get_gamertag)
				name_text_1 = <Name>
			endif
		endif
		FormatText TextName = p1_difficulty_text "%n, %d" D = <difficulty_text> N = <name_text_1>
		displayText {
			PARENT = newspaper_container
			Text = <p1_difficulty_text>
			Pos = (298.0, 522.0)
			Scale = (0.5, 0.55)
			font = text_a11
			rgba = $g_ss_p1_orangeish
			rot = -7.5
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 2 space_spacing = 2
		get_difficulty_text_upper DIFFICULTY = ($current_difficulty2)
		name_text_2 = "PLAYER 2"
		if ($is_network_game)
			name_text_2 = $opponent_gamertag
		endif
		FormatText TextName = p2_difficulty_text "%n, %d" D = <difficulty_text> N = <name_text_2>
		displayText {
			PARENT = newspaper_container
			Text = <p2_difficulty_text>
			Pos = (302.0, 552.0)
			Scale = (0.5, 0.55)
			font = text_a11
			rgba = $g_ss_p2_violetish
			rot = -7.5
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 2 space_spacing = 2
		displaySprite {
			PARENT = newspaper_container
			tex = <ss_logo_sm>
			Pos = (946.0, 86.0)
		}
		<p1_stats_pos> = (668.0, 260.0)
		<p2_stats_pos> = (864.0, 260.0)
		displaySprite {
			Id = np_circle_1
			PARENT = newspaper_container
			tex = Song_Summary_Circle_2p
			Pos = (<p1_stats_pos> + (61.0, 61.0))
			rgba = $g_ss_p1_orangeish
			Rot_Angle = 180
			Z = 8
		}
		displaySprite {
			Id = np_circle_2
			PARENT = newspaper_container
			tex = Song_Summary_Circle_2p
			Pos = <p2_stats_pos>
			rgba = $g_ss_p2_violetish
			Z = 8
		}
		displayText {
			PARENT = newspaper_container
			Text = "1"
			Pos = (<p1_stats_pos> + (23.0, 3.0))
			Scale = (0.9, 0.6)
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			Z = 9
		}
		displayText {
			PARENT = newspaper_container
			Text = "2"
			Pos = (<p2_stats_pos> + (21.0, 3.0))
			Scale = (0.9, 0.6)
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			Z = 9
		}
		if (<winner> = "1")
			<l_wing_pos> = (<p1_stats_pos> + (-44.0, 0.0))
			<r_wing_pos> = (<p1_stats_pos> + (39.0, 0.0))
		else
			<l_wing_pos> = (<p2_stats_pos> + (-44.0, 0.0))
			<r_wing_pos> = (<p2_stats_pos> + (44.0, 0.0))
		endif
		if NOT (<winner> = "0")
			displaySprite {
				Id = np_left_wing
				PARENT = newspaper_container
				tex = Song_Summary_Wing_2p
				Pos = <l_wing_pos>
				Z = 7
			}
			displaySprite {
				Id = np_right_wing
				PARENT = newspaper_container
				tex = Song_Summary_Wing_2p_Flipped
				Pos = <r_wing_pos>
				Z = 7
			}
			if (<winner> = "1")
				displaySprite {
					PARENT = newspaper_container
					tex = Song_Summary_Guitar_Winner_2p
					Pos = (<p1_stats_pos> + (46.0, 0.0))
					Z = 6
				}
				displaySprite {
					PARENT = newspaper_container
					tex = Song_Summary_Guitar_Loser_2p
					Pos = (<p2_stats_pos> + (-44.0, 0.0))
					flip_v
					Z = 6
				}
			else
				displaySprite {
					PARENT = newspaper_container
					tex = Song_Summary_Guitar_Winner_2p
					Pos = (<p2_stats_pos> + (-110.0, 0.0))
					flip_v
					Z = 6
				}
				displaySprite {
					PARENT = newspaper_container
					tex = Song_Summary_Guitar_Loser_2p
					Pos = (<p1_stats_pos> + (44.0, 0.0))
					Z = 6
				}
			endif
		endif
		displaySprite {
			Id = ss_p1_note_streak_fill
			PARENT = newspaper_container
			tex = Song_Summary_Notestreak_Fill
			Pos = (<p1_stats_pos> + (-8.0, 44.0))
			rgba = <ss_notestreak_fill_color>
		}
		displaySprite {
			Id = ss_p2_note_streak_fill
			PARENT = newspaper_container
			tex = Song_Summary_Notestreak_Fill
			Pos = (<p2_stats_pos> + (61.0, 174.0))
			rgba = <ss_notestreak_fill_color>
			Rot_Angle = 182
		}
		if (<p1_note_streak> > 999)
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (13.0, 43.0))
			<ss_notestreak_scale> = (1.12, 1.5)
		elseif (<p1_note_streak> > 99)
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (12.0, 43.0))
			<ss_notestreak_scale> = 1.5
		elseif (<p1_note_streak> < 10)
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (39.0, 43.0))
			<ss_notestreak_scale> = 1.5
		else
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (25.0, 43.0))
			<ss_notestreak_scale> = 1.5
		endif
		displayText {
			Id = ss_p1_note_streak
			PARENT = newspaper_container
			Text = <p1_note_streak_text>
			Pos = <ss_p1_notestreak_pos>
			Scale = <ss_notestreak_scale>
			font = text_a4
			Z = 4
			rgba = <ss_notestreak_color>
			noshadow
		}
		displayText {
			Id = ss_p1_note_streak_text
			PARENT = newspaper_container
			Text = "note streak"
			just = [Center Center]
			Pos = (<p1_stats_pos> + (52.0, 130.0))
			Scale = (0.55, 0.7)
			font = text_a11
			Z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		GetScreenElementDims Id = <Id>
		fit_text_in_rectangle Id = ss_p1_note_streak_text Dims = ((90.0, 0.0) + (0.0, 1.0) * <Height>) Pos = (<p1_stats_pos> + (52.0, 130.0)) start_x_scale = 0.55 start_y_scale = 0.7 only_if_larger_x = 1
		if (<p2_note_streak> > 999)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-40.0, 43.0))
			<ss_notestreak_scale> = (1.12, 1.5)
		elseif (<p2_note_streak> > 99)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-40.0, 43.0))
			<ss_notestreak_scale> = 1.5
		elseif (<p2_note_streak> < 10)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-10.0, 43.0))
			<ss_notestreak_scale> = 1.5
		else
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-26.0, 43.0))
			<ss_notestreak_scale> = 1.5
		endif
		displayText {
			Id = ss_p2_note_streak
			PARENT = newspaper_container
			Text = <p2_note_streak_text>
			Pos = <ss_p2_notestreak_pos>
			Scale = <ss_notestreak_scale>
			font = text_a4
			Z = 4
			rgba = <ss_notestreak_color>
			noshadow
		}
		displayText {
			Id = ss_p2_note_streak_text
			PARENT = newspaper_container
			Text = "note streak"
			just = [Center Center]
			Pos = (<p2_stats_pos> + (-2.0, 130.0))
			Scale = (0.55, 0.7)
			font = text_a11
			Z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		GetScreenElementDims Id = <Id>
		fit_text_in_rectangle Id = ss_p2_note_streak_text Dims = ((90.0, 0.0) + (0.0, 1.0) * <Height>) Pos = (<p2_stats_pos> + (-2.0, 130.0)) start_x_scale = 0.55 start_y_scale = 0.7 only_if_larger_x = 1
		if NOT ($g_ss_mag_number = 7)
			displaySprite {
				Id = ss_p1_score_fill
				PARENT = newspaper_container
				tex = Song_Summary_Score_BG_2p
				Pos = (<p1_stats_pos> + (-12.0, 160.0))
				rgba = <ss_score_color>
			}
			displaySprite {
				Id = ss_p2_score_fill
				PARENT = newspaper_container
				tex = Song_Summary_Score_BG_2p
				Pos = (<p2_stats_pos> + (54.0, 192.0))
				rgba = <ss_score_color>
				Rot_Angle = 181
			}
		else
			displaySprite {
				Id = ss_p1_score_fill
				PARENT = newspaper_container
				tex = Song_Summary_Score_BG_2p
				Pos = (<p1_stats_pos> + (-12.0, 160.0))
				rgba = $g_ss_HELL_darker_reddish
			}
			displaySprite {
				Id = ss_p2_score_fill
				PARENT = newspaper_container
				tex = Song_Summary_Score_BG_2p
				Pos = (<p2_stats_pos> + (54.0, 192.0))
				rgba = $g_ss_HELL_darker_reddish
				Rot_Angle = 181
			}
		endif
		displayText {
			Id = ss_p1_score_text
			PARENT = newspaper_container
			Text = "Score"
			Pos = (<p1_stats_pos> + (10.0, 155.0))
			Scale = (0.7, 0.5)
			font = text_a11
			Z = 4
			rgba = $g_ss_2p_song_title_whiteish
			noshadow
			rot = -2
		}
		displayText {
			Id = ss_p2_score_text
			PARENT = newspaper_container
			Text = "Score"
			Pos = (<p2_stats_pos> + (-50.0, 155.0))
			Scale = (0.7, 0.5)
			font = text_a11
			Z = 4
			rgba = $g_ss_2p_song_title_whiteish
			noshadow
			rot = -2
		}
		displayText {
			Id = ss_p1_score
			PARENT = newspaper_container
			Text = <p1_score_text>
			just = [Center Center]
			Pos = (<p1_stats_pos> + (48.0, 200.0))
			Scale = (0.8, 1.0)
			font = text_a4
			rgba = <ss_score_color>
			Z = 3
			noshadow
		}
		displayText {
			Id = ss_p2_score
			PARENT = newspaper_container
			Text = <p2_score_text>
			just = [Center Center]
			Pos = (<p2_stats_pos> + (-12.0, 200.0))
			Scale = (0.8, 1.0)
			font = text_a4
			rgba = <ss_score_color>
			Z = 3
			noshadow
		}
		FormatText TextName = p1_notes_hit "%d" D = <p1_percent_complete>
		if (<p1_percent_complete> = 100)
			<ss_percent_pos> = (<p1_stats_pos> + (2.0, 204.0))
			<ss_percent_scale> = (0.7, 1.47)
		elseif (<p1_percent_complete> < 10)
			<ss_percent_pos> = (<p1_stats_pos> + (10.0, 206.0))
			<ss_percent_scale> = (1.6, 1.47)
		else
			<ss_percent_pos> = (<p1_stats_pos> + (6.0, 207.0))
			<ss_percent_scale> = (0.9, 1.47)
		endif
		displayText {
			Id = ss_p1_notes_hit
			PARENT = newspaper_container
			Text = <p1_notes_hit>
			Pos = <ss_percent_pos>
			Scale = <ss_percent_scale>
			font = text_a4
			Z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		FormatText TextName = p2_notes_hit "%d" D = <p2_percent_complete>
		if (<p2_percent_complete> = 100)
			<ss_percent_pos> = (<p2_stats_pos> + (-70.0, 204.0))
			<ss_percent_scale> = (0.7, 1.47)
		elseif (<p2_percent_complete> < 10)
			<ss_percent_pos> = (<p2_stats_pos> + (-62.0, 206.0))
			<ss_percent_scale> = (1.6, 1.47)
		else
			<ss_percent_pos> = (<p2_stats_pos> + (-66.0, 207.0))
			<ss_percent_scale> = (0.9, 1.47)
		endif
		displayText {
			Id = ss_p2_notes_hit
			PARENT = newspaper_container
			Text = <p2_notes_hit>
			Pos = <ss_percent_pos>
			Scale = <ss_percent_scale>
			font = text_a4
			Z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		displayText {
			Id = ss_p1_percent_sign
			PARENT = newspaper_container
			Text = "%"
			Pos = (<p1_stats_pos> + (60.0, 226.0))
			font = text_a4
			Z = 4
			rgba = <ss_percent_color>
			rot = 50
			Scale = (0.7, 0.5)
			noshadow
		}
		displayText {
			Id = ss_p1_notes_text
			PARENT = newspaper_container
			Text = "\\u0NOTES"
			Pos = (<p1_stats_pos> + (66.0, 232.0))
			Scale = (0.4, 0.7)
			font = text_a3
			Z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 4
		fit_text_in_rectangle Id = ss_p1_notes_text Dims = (38.0, 30.0) Pos = (<p1_stats_pos> + (66.0, 232.0)) start_x_scale = 0.4 start_y_scale = 0.7 only_if_larger_x = 1
		displayText {
			Id = ss_p1_hit_text
			PARENT = newspaper_container
			Text = "\\u0HIT"
			Pos = (<p1_stats_pos> + (67.0, 257.0))
			Scale = (0.4, 0.6)
			font = text_a3
			Z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 6
		fit_text_in_rectangle Id = ss_p1_hit_text Dims = (38.0, 30.0) Pos = (<p1_stats_pos> + (67.0, 257.0)) start_x_scale = 0.4 start_y_scale = 0.6 only_if_larger_x = 1
		displayText {
			Id = ss_p2_percent_sign
			PARENT = newspaper_container
			Text = "%"
			Pos = (<p2_stats_pos> + (-12.0, 226.0))
			font = text_a4
			Z = 4
			rgba = <ss_percent_color>
			rot = 50
			Scale = (0.7, 0.5)
			noshadow
		}
		displayText {
			Id = ss_p2_notes_text
			PARENT = newspaper_container
			Text = "\\u0NOTES"
			Pos = (<p2_stats_pos> + (-6.0, 232.0))
			Scale = (0.4, 0.7)
			font = text_a3
			Z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 4
		fit_text_in_rectangle Id = ss_p2_notes_text Dims = (45.0, 30.0) Pos = (<p2_stats_pos> + (-6.0, 232.0)) start_x_scale = 0.4 start_y_scale = 0.7 only_if_larger_x = 1
		displayText {
			Id = ss_p2_hit_text
			PARENT = newspaper_container
			Text = "\\u0HIT"
			Pos = (<p2_stats_pos> + (-5.0, 257.0))
			Scale = (0.4, 0.6)
			font = text_a3
			Z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 6
		fit_text_in_rectangle Id = ss_p2_hit_text Dims = (45.0, 30.0) Pos = (<p2_stats_pos> + (-5.0, 257.0)) start_x_scale = 0.4 start_y_scale = 0.6 only_if_larger_x = 1
		if (<winner> = "1")
			displaySprite {
				Id = np_icon_thumb
				PARENT = newspaper_container
				tex = Song_Summary_Icon_Winner_2p
				Pos = (<p1_stats_pos> + (46.0, 330.0))
				rgba = $g_ss_p1_orangeish
				just = [Center Center]
				Dims = (64.0, 64.0)
			}
			displaySprite {
				Id = np_icon_skull
				PARENT = newspaper_container
				tex = Song_Summary_Icon_Loser_2p
				Pos = (<p2_stats_pos> + (-55.0, 294.0))
				rgba = $g_ss_p2_violetish
				Dims = (64.0, 64.0)
			}
		elseif (<winner> = "2")
			displaySprite {
				Id = np_icon_thumb
				PARENT = newspaper_container
				tex = Song_Summary_Icon_Winner_2p
				Pos = (<p2_stats_pos> + (-16.0, 320.0))
				rgba = $g_ss_p2_violetish
				just = [Center Center]
				Dims = (64.0, 64.0)
				flip_v
			}
			displaySprite {
				Id = np_icon_skull
				PARENT = newspaper_container
				tex = Song_Summary_Icon_Loser_2p
				Pos = (<p1_stats_pos> + (22.0, 294.0))
				rgba = $g_ss_p1_orangeish
				Dims = (64.0, 64.0)
				flip_v
			}
		endif
		if NOT (<winner> = "0")
			<I> = 1
			begin
			FormatText ChecksumName = hilite_id 'ss_hilite%d_p%p' D = <I> P = <win_sqs>
			if (<I> = 3)
				<I> = 2
			endif
			FormatText ChecksumName = hilite_tex 'Char_Select_Hilite%d' D = <I>
			<hilite_rgba> = [200 90 40 255]
			<hilite_pos> = (<p1_stats_pos> + (46.0, 330.0))
			if (<win_sqs> = '2')
				<hilite_rgba> = [180 130 220 255]
				<hilite_pos> = (<p2_stats_pos> + (-16.0, 320.0))
			endif
			displaySprite {
				Id = <hilite_id>
				PARENT = newspaper_container
				Pos = <hilite_pos>
				tex = <hilite_tex>
				Dims = (220.0, 220.0)
				just = 0
				Z = 1
			}
			if (<I> = 1)
				<Id> :SetProps rgba = <hilite_rgba> Alpha = 0.25 Dims = (180.0, 180.0)
			endif
			<I> = (<I> + 1)
			repeat 3
		endif
		outfit = ($<player_status>.outfit)
		style = ($<player_status>.style)
		if find_profile_by_id Id = ($<player_status>.character_id)
			get_musician_profile_struct Index = <Index>
			character_name = (<profile_struct>.Name)
			FormatText ChecksumName = the_body_id_i_need 'Guitarist_%n_Outfit%o_Style%s' N = <character_name> O = <outfit> S = <style>
			get_pak_filename desc_id = <the_body_id_i_need> Type = Body
			if (<found> = 1)
				get_musician_body_struct Index = <pak_index>
				<asset_context> = (<info_struct>.asset_context)
				PushAssetContext context = <asset_context>
			endif
		endif
		displaySprite \{PARENT = newspaper_container
			tex = Mag_Photo
			Dims = (640.0, 640.0)
			Pos = (125.0, 34.0)
			Z = -1}
		if (<found> = 1)
			PopAssetContext
		endif
		if NOT (<winner> = "0")
			SpawnScriptNow \{np_2p_flap_wings}
			SpawnScriptNow \{np_2p_thumb_zoom}
			SpawnScriptNow np_2p_fade_to_grey Params = {winner = <winner>}
		endif
		if (<winner> = "1")
			SpawnScriptNow \{np_2p_hilites_p1}
		elseif (<winner> = "2")
			SpawnScriptNow \{np_2p_hilites_p2}
		endif
	else
		if NOT ($g_ss_mag_number = 7)
			create_menu_backdrop \{texture = Newspaper_BG}
		else
			create_menu_backdrop \{texture = Song_Summary_BG_HELL}
		endif
		switch $g_ss_mag_number
			case 0
			<ss_logo> = Song_Summary_Logo_BACKYARD
			<ss_sidebar> = Song_Summary_Sidebar_BACKYARD
			<ss_percent_fill> = Song_Summary_Percent_Fill_BACKYARD
			<ss_percent_color> = $g_ss_black
			<ss_star_good_color> = $g_ss_offwhite
			<ss_star_bad_color> = [100 100 100 255]
			<ss_score_fill_L_color> = $g_ss_black
			<ss_score_color> = $g_ss_offwhite
			<ss_score_fill_R_color> = $g_ss_offwhite
			<ss_score_text_color> = $g_ss_black
			<ss_notestreak_fill_color> = $g_ss_offwhite
			<ss_notestreak_color> = $g_ss_black
			<ss_notestreak_text_color> = $g_ss_black
			case 1
			<ss_logo> = Song_Summary_Logo_BAR
			<ss_sidebar> = Song_Summary_Sidebar_BAR
			<ss_percent_fill> = Song_Summary_Percent_Fill_BAR
			<ss_percent_color> = $g_ss_black
			<ss_star_good_color> = $g_ss_offwhite
			<ss_star_bad_color> = [100 100 100 255]
			<ss_score_fill_L_color> = $g_ss_black
			<ss_score_color> = $g_ss_offwhite
			<ss_score_fill_R_color> = $g_ss_GP_greyish
			<ss_score_text_color> = $g_ss_offwhite
			<ss_notestreak_fill_color> = $g_ss_GP_greyish
			<ss_notestreak_color> = $g_ss_offwhite
			<ss_notestreak_text_color> = $g_ss_offwhite
			case 2
			<ss_logo> = Song_Summary_Logo_Paste
			<ss_sidebar> = Song_Summary_Sidebar_Paste
			<ss_percent_fill> = Song_Summary_Percent_Fill_Paste
			<ss_percent_color> = $g_ss_Paste_beigeish
			<ss_star_good_color> = $g_ss_Paste_brownish
			<ss_star_bad_color> = $g_ss_offwhite
			<ss_score_fill_L_color> = $g_ss_Paste_beigeish
			<ss_score_color> = $g_ss_Paste_maroonish
			<ss_score_fill_R_color> = $g_ss_Paste_brownish
			<ss_score_text_color> = $g_ss_Paste_beigeish
			<ss_notestreak_fill_color> = $g_ss_Paste_beigeish
			<ss_notestreak_color> = $g_ss_Paste_maroonish
			<ss_notestreak_text_color> = $g_ss_Paste_brownish
			case 3
			<ss_logo> = Song_Summary_Logo_Decibel
			<ss_sidebar> = Song_Summary_Sidebar_Decibel
			<ss_percent_fill> = Song_Summary_Percent_Fill_Decibel
			<ss_percent_color> = $g_ss_decibel_magentaish
			<ss_star_good_color> = $g_ss_orangeish
			<ss_star_bad_color> = $g_ss_offwhite
			<ss_score_fill_L_color> = $g_ss_black
			<ss_score_color> = $g_ss_decibel_yellowish
			<ss_score_fill_R_color> = $g_ss_decibel_greenish
			<ss_score_text_color> = $g_ss_decibel_magentaish
			<ss_notestreak_fill_color> = $g_ss_decibel_greenish
			<ss_notestreak_color> = $g_ss_decibel_magentaish
			<ss_notestreak_text_color> = $g_ss_black
			case 4
			<ss_logo> = Song_Summary_Logo_AP
			<ss_sidebar> = Song_Summary_Sidebar_AP
			<ss_percent_fill> = Song_Summary_Percent_Fill_AP
			<ss_percent_color> = $g_ss_AP_yellowish
			<ss_star_good_color> = $g_ss_AP_reddish
			<ss_star_bad_color> = $g_ss_offwhite
			<ss_score_fill_L_color> = $g_ss_AP_blueish
			<ss_score_color> = $g_ss_AP_yellowish
			<ss_score_fill_R_color> = $g_ss_AP_reddish
			<ss_score_text_color> = $g_ss_AP_yellowish
			<ss_notestreak_fill_color> = $g_ss_AP_reddish
			<ss_notestreak_color> = $g_ss_AP_yellowish
			<ss_notestreak_text_color> = $g_ss_AP_yellowish
			case 5
			<ss_logo> = Song_Summary_Logo_Kerrang
			<ss_sidebar> = Song_Summary_Sidebar_Kerrang
			<ss_percent_fill> = Song_Summary_Percent_Fill_Kerrang
			<ss_percent_color> = $g_ss_offwhite
			<ss_star_good_color> = $g_ss_orangeish
			<ss_star_bad_color> = $g_ss_offwhite
			<ss_score_fill_L_color> = $g_ss_black
			<ss_score_color> = $g_ss_offwhite
			<ss_score_fill_R_color> = $g_ss_offwhite
			<ss_score_text_color> = $g_ss_black
			<ss_notestreak_fill_color> = $g_ss_black
			<ss_notestreak_color> = $g_ss_offwhite
			<ss_notestreak_text_color> = $g_ss_offwhite
			case 6
			<ss_logo> = Song_Summary_Logo_GPlayer
			<ss_sidebar> = Song_Summary_Sidebar_GPlayer
			<ss_percent_fill> = Song_Summary_Percent_Fill_GPlayer
			<ss_percent_color> = $g_ss_GP_blueish
			<ss_star_good_color> = $g_ss_orangeish
			<ss_star_bad_color> = $g_ss_offwhite
			<ss_score_fill_L_color> = $g_ss_GP_blueish
			<ss_score_color> = $g_ss_offwhite
			<ss_score_fill_R_color> = $g_ss_GP_greyish
			<ss_score_text_color> = $g_ss_offwhite
			<ss_notestreak_fill_color> = $g_ss_offwhite
			<ss_notestreak_color> = $g_ss_GP_blueish
			<ss_notestreak_text_color> = $g_ss_GP_greyish
			case 7
			<ss_logo> = Song_Summary_Logo_HELL
			<ss_sidebar> = Song_Summary_Sidebar_HELL
			<ss_percent_fill> = Song_Summary_Percent_Fill_HELL
			<ss_percent_color> = $g_ss_HELL_darker_reddish
			<ss_star_good_color> = $g_ss_orangeish
			<ss_star_bad_color> = $g_ss_offwhite
			<ss_score_fill_L_color> = $g_ss_black
			<ss_score_color> = $g_ss_HELL_lighter_reddish
			<ss_score_fill_R_color> = $g_ss_HELL_darker_reddish
			<ss_score_text_color> = $g_ss_black
			<ss_notestreak_fill_color> = $g_ss_HELL_darker_reddish
			<ss_notestreak_color> = $g_ss_black
			<ss_notestreak_text_color> = $g_ss_black
		endswitch
		displaySprite {
			PARENT = newspaper_container
			tex = <ss_logo>
			Pos = (158.0, 25.0)
		}
		displaySprite {
			PARENT = newspaper_container
			tex = <ss_sidebar>
			Pos = (858.0, 130.0)
		}
		get_song_artist Song = <my_song>
		GetUpperCaseString <song_artist>
		<band_name> = <UpperCaseString>
		song_internal_scale = 1.0
		StringLength String = <Song_Title>
		if (<str_len> >= 19)
			<song_internal_scale> = 0.75
		endif
		mypos = (262.0, 345.0)
		CreateScreenElement {
			Id = ss_song_title_text_block_id
			Type = TextBlockElement
			PARENT = newspaper_container
			just = [LEFT Bottom]
			internal_just = [LEFT Bottom]
			Pos = <mypos>
			Scale = 0.75
			Text = <Song_Title>
			font = text_a11
			rgba = $g_ss_offwhite
			Dims = (300.0, 200.0)
			line_spacing = 0.85
			Rot_Angle = -7.5
			internal_scale = <song_internal_scale>
		}
		<artist_pos> = (<mypos> + (0.0, 5.0))
		if ($g_ss_mag_number = 0 || $g_ss_mag_number = 1)
			<band_name_color> = $g_ss_offwhite
		else
			<band_name_color> = $g_ss_orangeish
		endif
		CreateScreenElement {
			Id = ss_artist_text_block_id
			Type = TextBlockElement
			PARENT = newspaper_container
			just = [LEFT Top]
			internal_just = [LEFT Top]
			Pos = <artist_pos>
			Scale = (0.5, 0.55)
			Text = <band_name>
			font = text_a4
			rgba = <band_name_color>
			Dims = (400.0, 134.0)
			line_spacing = 0.85
			Rot_Angle = -7.5
		}
		displaySprite {
			PARENT = newspaper_container
			tex = <ss_percent_fill>
			Pos = (267.0, 460.0)
			Dims = (336.0, 168.0)
		}
		FormatText TextName = p1_notes_hit "%d" D = <p1_percent_complete>
		if (<p1_percent_complete> = 100)
			<ss_percent_pos> = (290.0, 503.0)
			<ss_percent_scale> = (1.3, 1.6)
		elseif (<p1_percent_complete> < 10)
			<ss_percent_pos> = (332.0, 496.0)
			<ss_percent_scale> = 1.6
		else
			<ss_percent_pos> = (302.0, 501.0)
			<ss_percent_scale> = 1.6
		endif
		displayText {
			PARENT = newspaper_container
			Text = <p1_notes_hit>
			Pos = <ss_percent_pos>
			Scale = <ss_percent_scale>
			font = text_a4
			Z = 4
			rgba = <ss_percent_color>
			rot = -10
			noshadow
		}
		displayText {
			PARENT = newspaper_container
			Text = "%"
			Pos = (364.0, 500.0)
			font = text_a4
			Z = 4
			rgba = <ss_percent_color>
			rot = -10
			noshadow
		}
		if NOT ($g_ss_mag_number = 7)
			<np_notes_hit_color> = $g_ss_black
		else
			<np_notes_hit_color> = $g_ss_HELL_lighter_reddish
		endif
		displayText {
			PARENT = newspaper_container
			Text = "\\u0NOTES HIT"
			Pos = (403.0, 522.0)
			Scale = (0.44, 0.7)
			font = text_a3
			Z = 4
			rgba = <np_notes_hit_color>
			rot = -10
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 6 space_spacing = 1
		GetScreenElementDims Id = <Id>
		if (<width> > 79)
			SetScreenElementProps Id = <Id> Scale = 1
			fit_text_in_rectangle Id = <Id> Dims = (66.0, 35.0) Pos = (403.0, 522.0)
		endif
		displaySprite {
			PARENT = newspaper_container
			tex = Song_Summary_Score_Fill_L
			Pos = (674.0, 90.0)
			rgba = <ss_score_fill_L_color>
			Dims = (268.0, 67.0)
		}
		if (<for_practice> = 0)
			if (<show_stars> = 1)
				<star_pos> = (686.0, 120.0)
				<star_add> = (23.0, 0.0)
				<I> = 0
				begin
				<star_offset> = (0.0, 0.0)
				if (<I> = 1)
					<star_rot> = 20
					<star_offset> = (4.0, -3.0)
				elseif (<I> = 3)
					<star_rot> = -20
					<star_offset> = (-2.0, 3.0)
				else
					<star_rot> = 0
				endif
				if ((<STARS> - <I>) < 1)
					<star_color> = <ss_star_bad_color>
				else
					<star_color> = <ss_star_good_color>
				endif
				displaySprite {
					PARENT = newspaper_container
					Pos = (<star_pos> + <star_offset>)
					Scale = 0.65000004
					tex = Song_Summary_Score_Star
					Z = 4
					rgba = <star_color>
					Rot_Angle = <star_rot>
				}
				<I> = (<I> + 1)
				<star_pos> = (<star_pos> + <star_add>)
				repeat 5
			endif
			displayText {
				Id = np_score_text
				PARENT = newspaper_container
				Text = <p1_score_text>
				just = [RIGHT Center]
				Pos = (926.0, 116.0)
				Scale = (0.9, 0.65000004)
				font = text_a4
				rgba = <ss_score_color>
				Z = 3
				noshadow
			}
			<curr_dif> = ($current_difficulty)
			if ($game_mode = p2_career)
				<index1> = ($difficulty_list_props.($current_difficulty).Index)
				<index2> = ($difficulty_list_props.($current_difficulty2).Index)
				if (<index2> < <index1>)
					<curr_dif> = ($current_difficulty2)
				endif
			endif
			get_difficulty_text_upper DIFFICULTY = <curr_dif>
			displayText {
				PARENT = newspaper_container
				just = [LEFT Bottom]
				Text = <difficulty_text>
				Pos = (946.0, 133.0)
				Scale = (0.7, 0.6)
				font = text_a11
				Z = 4
				rgba = <ss_score_text_color>
				noshadow
			}
			SetScreenElementProps Id = <Id> font_spacing = 3
			fit_text_in_rectangle Id = <Id> Dims = (100.0, 100.0) only_if_larger_x = 1 keep_ar = 1 start_x_scale = 0.7 start_y_scale = 0.6 debug_me
		else
			NOTES_HIT = ($player1_status.NOTES_HIT)
			notes_total = ($player1_status.total_notes)
			FormatText TextName = notes_hit_out_of_total "%a OUT OF %b" A = <NOTES_HIT> B = <notes_total>
			displayText {
				Id = np_score_text
				PARENT = newspaper_container
				Text = <notes_hit_out_of_total>
				just = [RIGHT Center]
				Pos = (911.0, 117.0)
				Scale = (0.9, 0.65000004)
				font = text_a4
				rgba = <ss_score_color>
				Z = 3
				noshadow
				rot = -2
			}
			GetScreenElementDims Id = <Id>
			SetScreenElementProps Id = <Id> Scale = (0.9, 0.65000004)
			fit_text_in_rectangle Id = <Id> Dims = ((200.0, 0.0) + <Height> * (0.0, 0.65000004))
			displayText {
				PARENT = newspaper_container
				Text = "NOTES"
				Pos = (946.0, 98.0)
				Scale = (0.7, 0.6)
				font = text_a11
				Z = 4
				rgba = <ss_score_text_color>
				noshadow
			}
			GetScreenElementDims Id = <Id>
			SetScreenElementProps Id = <Id> Scale = (0.7, 0.6)
			fit_text_in_rectangle Id = <Id> Dims = ((70.0, 0.0) + <Height> * (0.0, 0.6))
		endif
		displaySprite {
			PARENT = newspaper_container
			tex = Song_Summary_Score_Fill_R
			Pos = (934.0, 83.0)
			rgba = <ss_score_fill_R_color>
			Dims = (134.0, 67.0)
		}
		displaySprite {
			PARENT = newspaper_container
			tex = Song_Summary_Notestreak_Fill
			Pos = (719.0, 359.0)
			rgba = <ss_notestreak_fill_color>
		}
		if (<p1_note_streak> > 999)
			<ss_notestreak_pos> = (740.0, 358.0)
			<ss_notestreak_scale> = (1.12, 1.5)
		elseif (<p1_note_streak> > 99)
			<ss_notestreak_pos> = (739.0, 358.0)
			<ss_notestreak_scale> = 1.5
		elseif (<p1_note_streak> < 10)
			<ss_notestreak_pos> = (766.0, 358.0)
			<ss_notestreak_scale> = 1.5
		else
			<ss_notestreak_pos> = (752.0, 358.0)
			<ss_notestreak_scale> = 1.5
		endif
		displayText {
			PARENT = newspaper_container
			Text = <p1_note_streak_text>
			Pos = <ss_notestreak_pos>
			Scale = <ss_notestreak_scale>
			font = text_a4
			Z = 4
			rgba = <ss_notestreak_color>
			noshadow
		}
		displayText {
			PARENT = newspaper_container
			Text = "note streak"
			Pos = (732.0, 425.0)
			Scale = (0.44, 0.55)
			font = text_a11
			Z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		SetScreenElementProps Id = <Id> font_spacing = 5 space_spacing = 3 Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = (80.0, 35.0) Pos = (732.0, 425.0)
		outfit = ($player1_status.outfit)
		style = ($player1_status.style)
		if find_profile_by_id Id = ($player1_status.character_id)
			get_musician_profile_struct Index = <Index>
			character_name = (<profile_struct>.Name)
			FormatText ChecksumName = the_body_id_i_need 'Guitarist_%n_Outfit%o_Style%s' N = <character_name> O = <outfit> S = <style>
			get_pak_filename desc_id = <the_body_id_i_need> Type = Body
			if (<found> = 1)
				get_musician_body_struct Index = <pak_index>
				<asset_context> = (<info_struct>.asset_context)
				PushAssetContext context = <asset_context>
			endif
		endif
		displaySprite \{PARENT = newspaper_container
			tex = Mag_Photo
			Dims = (640.0, 640.0)
			Pos = (125.0, 34.0)
			Z = -1}
		if (<found> = 1)
			PopAssetContext
		endif
	endif
	if ($is_network_game)
		np_net_create_options_menu Pos = (770.0, 460.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	elseif ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p1_quickplay)
		np_create_options_menu Pos = (770.0, 460.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	else
		np_create_options_menu Pos = (770.0, 360.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	endif
	get_song_struct Song = <my_song>
	if ((StructureContains Structure = <song_struct> boss) || $game_mode = p2_battle)
		set_current_battle_first_play
	endif
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
		add_user_control_helper \{Text = "CONTINUE"
			button = Green
			Z = 100}
	else
		add_user_control_helper \{Text = "SELECT"
			button = Green
			Z = 100}
	endif
	if (($is_network_game) && (IsXENON))
		add_user_control_helper \{Text = "GAMER CARD"
			button = Start
			Z = 100}
	endif
	if ($is_network_game = 1)
		get_number_of_songs
		if NOT ((($net_song_num) != (<num_songs> - 1)) || ($game_mode = p2_coop))
			clean_up_user_control_helpers
		endif
	endif
	if NOT ($is_network_game)
		add_user_control_helper \{Text = "UP/DOWN"
			button = Strumbar
			Z = 100}
	endif
endscript
