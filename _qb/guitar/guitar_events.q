script GuitarEvent_HitNote_Spawned 
	GetGlobalTags \{user_options}
	if ($game_mode = p2_battle || $boss_battle = 1)
		Change StructureName = <player_status> last_hit_note = <Color>
	endif
	Wait \{1
		GameFrame}
	if (<no_flames> = 0)
		SpawnScriptNow hit_note_fx Params = {Name = <fx_id> Pos = <Pos> player_Text = <player_Text> Star = ($<player_status>.star_power_used) Player = <Player>}
	endif
endscript

script GuitarEvent_SongFailed_Spawned 
	if NOT ($boss_battle = 1)
		disable_highway_prepass
		disable_bg_viewport
	endif
	if ($is_network_game)
		KillSpawnedScript \{Name = dispatch_player_state}
		kill_start_key_binding
		if ($ui_flow_manager_state [0] = online_pause_fs)
			net_unpausegh3
		endif
		mark_unsafe_for_shutdown
	endif
	GetSongTimeMS
	Change failed_song_time = <Time>
	Achievements_SongFailed
	PauseGame
	Progression_SongFailed
	if ($boss_battle = 1)
		kill_start_key_binding
		if ($current_song = bossdevil)
			preload_movie = 'Satan-Battle_LOSS'
		else
			preload_movie = 'Player2_wins'
		endif
		KillMovie \{TextureSlot = 1}
		PreLoadMovie {
			movie = <preload_movie>
			TextureSlot = 1
			TexturePri = 70
			no_looping
			no_hold
			noWait
		}
		FormatText TextName = winner_text "%s Rocks!" S = ($current_boss.character_name)
		winner_space_between = (50.0, 0.0)
		winner_scale = 1.0
		if ($current_boss.character_profile = Morello)
			<winner_space_between> = (40.0, 0.0)
			<winner_scale> = 1.0
		endif
		if ($current_boss.character_profile = Slash)
			<winner_space_between> = (40.0, 0.0)
			<winner_scale> = 1.0
		endif
		if ($current_boss.character_profile = SATAN)
			<winner_space_between> = (40.0, 0.0)
			<winner_scale> = 1.0
		endif
		SpawnScriptNow \{wait_and_play_you_rock_movie}
		Wait \{0.2
			Seconds}
		destroy_menu \{menu_id = YouRock_text}
		destroy_menu \{menu_id = yourock_text_2}
		StringLength String = <winner_text>
		<fit_dims> = (<str_len> * (23.0, 0.0))
		if (<fit_dims>.(1.0, 0.0) >= 350)
			<fit_dims> = (350.0, 0.0)
		endif
		split_text_into_array_elements {
			Id = YouRock_text
			Text = <winner_text>
			text_pos = (640.0, 360.0)
			space_between = <winner_space_between>
			just = [Center Center]
			fit_dims = <fit_dims>
			flags = {
				rgba = [255 255 255 255]
				Scale = <winner_scale>
				z_priority = 95
				font = text_a10_Large
				rgba = [223 223 223 255]
				just = [Center Center]
				Alpha = 1
			}
			centered
		}
		SpawnScriptNow \{waitAndKillHighway}
		KillSpawnedScript \{Name = jiggle_text_array_elements}
		SpawnScriptNow \{jiggle_text_array_elements
			Params = {
				Id = YouRock_text
				Time = 1.0
				wait_time = 3000
				explode = 1
			}}
	endif
	if ($is_network_game = 0)
		xenon_singleplayer_session_begin_uninit
		SpawnScriptNow \{xenon_singleplayer_session_complete_uninit}
	endif
	UnPauseGame
	SoundEvent \{Event = Crowd_Fail_Song_SFX}
	SoundEvent \{Event = GH_SFX_You_Lose_Single_Player}

	get_current_level_name
	if NOT (<level_name> = 'credits')
		Transition_Play \{Type = songlost}
		Transition_Wait
	endif

	Change \{current_transition = NONE}
	PauseGame
	restore_start_key_binding
	SpawnScriptNow \{ui_flow_manager_respond_to_action
		Params = {
			action = fail_song
		}}
	if ($current_num_players = 1)
		SoundEvent \{Event = Crowd_Fail_Song_SFX}
	else
		SoundEvent \{Event = Crowd_Med_To_Good_SFX}
	endif
	if ($is_network_game)
		mark_safe_for_shutdown
	endif
endscript

script hit_note_fx 
	NoteFX <...>
	Wait \{100
		milliseconds}
	Destroy2DParticleSystem Id = <particle_id> Kill_when_empty
	Wait \{167
		milliseconds}
	if ScreenElementExists Id = <fx_id>
		DestroyScreenElement Id = <fx_id>
	endif
endscript

script guitarevent_songwon_spawned 
	if ($is_network_game)
		mark_unsafe_for_shutdown
		if ($shutdown_game_for_signin_change_flag = 1)
			return
		endif
		if ($ui_flow_manager_state [0] = online_pause_fs)
			net_unpausegh3
		endif
		killspawnedscript \{name = dispatch_player_state}
		if ($player2_present)
			sendnetmessage {
				type = net_win_song
				stars = ($player1_status.stars)
				note_streak = ($player1_status.best_run)
				notes_hit = ($player1_status.notes_hit)
				total_notes = ($player1_status.total_notes)
			}
		endif
		if NOT ($game_mode = p2_battle || $cheat_nofail = 1 || $cheat_easyexpert = 1)
			if ($game_mode = p2_coop)
				online_song_end_write_stats \{song_type = coop}
			else
				online_song_end_write_stats \{song_type = single}
			endif
		endif
	endif
	if ($is_attract_mode = 1)
		spawnscriptnow \{ui_flow_manager_respond_to_action
			params = {
				action = exit_attract_mode
				play_sound = 0
			}}
		return
	endif
	if ($game_mode = training || $game_mode = tutorial)
		return
	endif
	if ($current_song = bossdevil && $devil_finish = 0)
		change \{devil_finish = 1}
	else
		change \{devil_finish = 0}
	endif
	progression_endcredits_done
	pausegame
	kill_start_key_binding
	if ($battle_sudden_death = 1)
		soundevent \{event = gh_sfx_battlemode_sudden_death}
	else
		if ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay || $game_mode = p1_bass_quickplay)
			soundevent \{event = you_rock_end_sfx}
		endif
	endif
	spawnscriptnow \{you_rock_waiting_crowd_sfx}
	if ($game_mode = p2_battle || $boss_battle = 1)
		if ($player1_status.current_health >= $player2_status.current_health)
			if ($current_song = bossdevil)
				preload_movie = 'Satan-Battle_WIN'
			else
				preload_movie = 'Player1_wins'
			endif
		else
			if ($current_song = bossdevil)
				preload_movie = 'Satan-Battle_LOSS'
			else
				preload_movie = 'Player2_wins'
			endif
		endif
		if ($current_song = bossdevil && $devil_finish = 0)
			preload_movie = 'Golden_Guitar'
		endif
		if ($battle_sudden_death = 1)
			preload_movie = 'Fret_Flames'
		endif
		killmovie \{textureslot = 1}
		preloadmovie {
			movie = <preload_movie>
			textureslot = 1
			texturepri = 70
			no_looping
			no_hold
			nowait
		}
	endif
	if NOT ($devil_finish = 1 || $battle_sudden_death = 1)
		spawnscriptnow \{wait_and_play_you_rock_movie}
	endif
	destroy_menu \{menu_id = yourock_text}
	destroy_menu \{menu_id = yourock_text_2}
	tie = false
	text_pos = (640.0, 360.0)
	rock_legend = 0
	fit_dims = (350.0, 0.0)
	if ($battle_sudden_death = 1)
		winner_text = "Sudden Death!"
		winner_space_between = (65.0, 0.0)
		winner_scale = 1.8
	else
		if ($game_mode = p2_battle)
			p1_health = ($player1_status.current_health)
			p2_health = ($player2_status.current_health)
			if (<p2_health> > <p1_health>)
				winner = "Two"
				soundevent \{event = ui_2ndplayerwins_sfx}
			else
				winner = "One"
				soundevent \{event = ui_1stplayerwins_sfx}
			endif
			if ($is_network_game)
				if (<p2_health> > <p1_health>)
					name = ($opponent_gamertag)
				else
					if (netsessionfunc obj = match func = get_gamertag)
						name = <name>
					endif
				endif
				formattext textname = winner_text <name>
				<text_pos> = (640.0, 240.0)
			else
				formattext textname = winner_text "Player %s Rocks!" s = <winner>
			endif
			winner_space_between = (50.0, 0.0)
			winner_scale = 1.5
		elseif ($game_mode = p2_faceoff || $game_mode = p2_pro_faceoff)
			p1_score = ($player1_status.score)
			p2_score = ($player2_status.score)
			if (<p2_score> > <p1_score>)
				winner = "Two"
				soundevent \{event = ui_2ndplayerwins_sfx}
			elseif (<p1_score> > <p2_score>)
				winner = "One"
				soundevent \{event = ui_1stplayerwins_sfx}
			else
				<tie> = true
				soundevent \{event = you_rock_end_sfx}
			endif
			if (<tie> = true)
				winner_text = "TIE!"
				winner_space_between = (15.0, 0.0)
				winner_scale = 0.5
				fit_dims = (100.0, 0.0)
			else
				if ($is_network_game)
					if (<p2_score> > <p1_score>)
						name = ($opponent_gamertag)
					else
						if (netsessionfunc obj = match func = get_gamertag)
							name = <name>
						endif
					endif
					formattext textname = winner_text <name>
					<text_pos> = (640.0, 240.0)
				else
					formattext textname = winner_text "Player %s Rocks!" s = <winner>
				endif
				winner_space_between = (50.0, 0.0)
				winner_scale = 1.5
			endif
		else
			winner_text = "You Rock!"
			winner_space_between = (40.0, 0.0)
			fit_dims = (350.0, 0.0)
			winner_scale = 1.0
		endif
		if ($devil_finish = 1)
			winner_text = "Now Finish Him!"
			winner_space_between = (55.0, 0.0)
			winner_scale = 1.8
		endif
		if ($current_song = bossdevil && $devil_finish = 0)
			<rock_legend> = 1
			winner_text = "YOU'RE A"
			<text_pos> = (800.0, 300.0)
			winner_space_between = (40.0, 0.0)
			winner_scale = 1.1
			fit_dims = (200.0, 0.0)
		endif
	endif
	stringlength string = <winner_text>
	<fit_dims> = (<str_len> * (23.0, 0.0))
	if (<fit_dims>.(1.0, 0.0) >= 350)
		<fit_dims> = (350.0, 0.0)
	endif
	split_text_into_array_elements {
		id = yourock_text
		text = <winner_text>
		text_pos = <text_pos>
		space_between = <winner_space_between>
		fit_dims = <fit_dims>
		flags = {
			rgba = [255 255 255 255]
			scale = <winner_scale>
			z_priority = 95
			font = text_a10_large
			rgba = [223 223 223 255]
			just = [center center]
			alpha = 1
		}
		centered
	}
	if (<rock_legend> = 1)
		split_text_into_array_elements {
			id = yourock_text_legend
			text = "ROCK LEGEND!"
			text_pos = (800.0, 420.0)
			space_between = <winner_space_between>
			fit_dims = (200.0, 0.0)
			flags = {
				rgba = [255 255 255 255]
				scale = <winner_scale>
				z_priority = 95
				font = text_a10_large
				rgba = [223 223 223 255]
				just = [center center]
				alpha = 1
			}
			centered
		}
	endif
	if (($is_network_game) && ($battle_sudden_death = 0) && (<tie> = false))
		if NOT ($game_mode = p2_coop)
			split_text_into_array_elements {
				id = yourock_text_2
				text = "Rocks!"
				text_pos = (640.0, 380.0)
				fit_dims = <fit_dims>
				space_between = <winner_space_between>
				flags = {
					rgba = [255 255 255 255]
					scale = <winner_scale>
					z_priority = 95
					font = text_a10_large
					rgba = [223 223 223 255]
					just = [center center]
					alpha = 1
				}
				centered
			}
		endif
	endif
	if NOT ($devil_finish = 1 || $battle_sudden_death = 1)
		spawnscriptnow \{waitandkillhighway}
		killspawnedscript \{name = jiggle_text_array_elements}
		spawnscriptnow \{jiggle_text_array_elements
			params = {
				id = yourock_text
				time = 1.0
				wait_time = 3000
				explode = 1
			}}
		if (<rock_legend> = 1)
			spawnscriptnow \{jiggle_text_array_elements
				params = {
					id = yourock_text_legend
					time = 1.0
					wait_time = 3000
					explode = 1
				}}
		endif
		if ($is_network_game)
			spawnscriptnow \{jiggle_text_array_elements
				params = {
					id = yourock_text_2
					time = 1.0
					wait_time = 3000
					explode = 1
				}}
		endif
		if ($current_song = bossslash || $current_song = bosstom || $current_song = bossdevil)
			boss_character = -1
			if ($current_song = bossslash)
				<boss_character> = 0
			elseif ($current_song = bosstom)
				<boss_character> = 1
			elseif ($current_song = bossdevil)
				<boss_character> = 2
			endif
			if (<boss_character> >= 0)
				unlocked_for_purchase = 1
				getglobaltags ($secret_characters [<boss_character>].id)
				if (<unlocked_for_purchase> = 0)
					spawnscriptnow \{boss_unlocked_text
						params = {
							parent_id = yourock_text
						}}
					setglobaltags ($secret_characters [<boss_character>].id) params = {unlocked_for_purchase = 1}
				endif
			endif
		endif
	endif
	change \{old_song = none}
	if NOT ($devil_finish = 1)
		if NOT ($battle_sudden_death = 1)
			progression_songwon
			if ($current_transition = preencore)
				end_song
				unpausegame
				transition_play \{type = preencore}
				transition_wait
				change \{current_transition = none}
				pausegame
				ui_flow_manager_respond_to_action \{action = preencore_win_song}
				encore_transition = 1
			elseif ($current_transition = preboss)
				end_song
				unpausegame
				transition_play \{type = preboss}
				transition_wait
				change \{current_transition = none}
				pausegame
				change \{use_last_player_scores = 1}
				change old_song = ($current_song)
				change \{show_boss_helper_screen = 1}
				ui_flow_manager_respond_to_action \{action = preboss_win_song}
				if ($is_network_game = 0)
					if NOT ($boss_battle = 1)
						if NOT ($devil_finish)
							agora_write_stats
						endif
					endif
					net_write_single_player_stats
					spawnscriptlater \{xenon_singleplayer_session_complete_uninit}
				endif
				return
			else
				unpausegame
				transition_play \{type = songwon}
				transition_wait
				change \{current_transition = none}
				pausegame
			endif
		else
			unpausegame
			transition_play \{type = songwon}
			spawnscriptnow \{wait_and_play_you_rock_movie}
			killspawnedscript \{name = jiggle_text_array_elements}
			spawnscriptnow \{jiggle_text_array_elements
				params = {
					id = yourock_text
					time = 1.0
					wait_time = 3000
					explode = 1
				}}
			spawnscriptnow \{sudden_death_helper_text
				params = {
					parent_id = yourock_text
				}}
			wait \{0.1
				seconds}
			spawnscriptnow \{waitandkillhighway}
			wait \{4
				seconds}
			change \{current_transition = none}
			pausegame
		endif
	else
		unpausegame
		transition_play \{type = songwon}
		spawnscriptnow \{wait_and_play_you_rock_movie}
		killspawnedscript \{name = jiggle_text_array_elements}
		spawnscriptnow \{jiggle_text_array_elements
			params = {
				id = yourock_text
				time = 1.0
				wait_time = 2000
				explode = 1
			}}
		devil_finish_anim
		wait \{0.15
			seconds}
		spawnscriptnow \{waitandkillhighway}
		wait \{2.5
			seconds}
		soundevent \{event = devil_die_transition_sfx}
		wait \{0.5
			seconds}
		change \{current_transition = none}
		pausegame
	endif
	if ($end_credits = 1 && $current_song = bossdevil)
		menu_music_off
		playmovieandwait \{movie = 'singleplayer_end'}
		get_movie_id_by_name \{movie = 'singleplayer_end'}
		setglobaltags <id> params = {unlocked = 1}
	endif
	if ($battle_sudden_death = 1)
		stopsoundevent \{gh_sfx_battlemode_sudden_death}
		printf \{"BATTLE MODE, Song Won, Begin Sudden Death"}
		change \{battle_sudden_death = 1}
		if ($is_network_game)
			ui_flow_manager_respond_to_action \{action = sudden_death_begin}
			spawnscriptlater \{load_and_sync_timing
				params = {
					start_delay = 4000
					player_status = player1_status
				}}
		else
			ui_flow_manager_respond_to_action \{action = select_retry}
			spawnscriptnow \{restart_song
				params = {
					sudden_death = 1
				}}
		endif
		if screenelementexists \{id = yourock_text}
			destroyscreenelement \{id = yourock_text}
		endif
	elseif ($end_credits = 1 && $current_song = thrufireandflames)
		destroy_menu \{menu_id = yourock_text}
		destroy_menu \{menu_id = yourock_text_2}
		change \{end_credits = 0}
		career_song_ended_select_quit
		start_flow_manager \{flow_state = career_credits_autosave_fs}
	elseif ($devil_finish = 1)
		start_devil_finish
	else
		destroy_menu \{menu_id = yourock_text}
		destroy_menu \{menu_id = yourock_text_2}
		destroy_menu \{menu_id = yourock_text_legend}
		ui_flow_manager_respond_to_action \{action = win_song}
	endif
	if ($is_network_game = 1)
		if ishost
			agora_write_stats
		endif
	elseif NOT ($boss_battle = 1)
		if NOT ($devil_finish)
			agora_write_stats
		endif
	endif
	if ($is_network_game = 0)
		net_write_single_player_stats
	endif
	if (($game_mode = p1_career) || ($game_mode = p2_career))
		agora_update
	endif
	if ($is_network_game = 0)
		if NOT ($devil_finish = 1)
			if NOT ($battle_sudden_death = 1)
				if NOT gotparam \{encore_transition}
					spawnscriptnow \{xenon_singleplayer_session_complete_uninit}
				endif
			endif
		endif
	endif
	soundevent \{event = crowd_med_to_good_sfx}
	if ($is_network_game)
		mark_safe_for_shutdown
	endif
endscript

script GuitarEvent_StarSequenceBonus 
	if ((IsPS2) || IsNGC)
		guitarevent_starsequencebonus_PSWii <...>
		return
	endif

	if ($is_attract_mode = 1)
		return
	endif
	Change StructureName = <player_status> sp_phrases_hit = ($<player_status>.sp_phrases_hit + 1)
	SoundEvent \{Event = Star_Power_Awarded_SFX}
	FormatText ChecksumName = container_id 'gem_container%p' P = ($<player_status>.Text) AddToStringLookup = TRUE
	GetArraySize \{$gem_colors}
	gem_count = 0
	begin
	<note> = ($<Song> [<array_entry>] [(<gem_count> + 1)])
	if (<note> > 0)
		Color = ($gem_colors [<gem_count>])
		if ($<player_status>.lefthanded_button_ups = 1)
			<pos2d> = ($button_up_models.<Color>.left_pos_2d)
			<Angle> = ($button_models.<Color>.Angle)
		else
			<pos2d> = ($button_up_models.<Color>.pos_2d)
			<Angle> = ($button_models.<Color>.left_angle)
		endif
		FormatText ChecksumName = Name 'big_bolt%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		CreateScreenElement {
			Type = SpriteElement
			Id = <Name>
			PARENT = <container_id>
			Material = sys_Big_Bolt01_sys_Big_Bolt01
			rgba = [255 255 255 255]
			Pos = <pos2d>
			Rot_Angle = <Angle>
			Scale = $star_power_bolt_scale
			just = [Center Bottom]
			z_priority = 6
		}
		FormatText ChecksumName = fx_id 'big_bolt_particle%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx_id>
		<particle_pos> = (<pos2d> - (0.0, 0.0))
		Create2DParticleSystem {
			Id = <fx_id>
			Pos = <particle_pos>
			z_priority = 8.0
			Material = sys_Particle_Star01_sys_Particle_Star01
			PARENT = <container_id>
			start_color = [0 128 255 255]
			end_color = [0 128 128 0]
			start_scale = (0.55, 0.55)
			end_scale = (0.25, 0.25)
			start_angle_spread = 360.0
			min_rotation = -120.0
			max_rotation = 240.0
			emit_start_radius = 0.0
			emit_radius = 2.0
			Emit_Rate = 0.04
			emit_dir = 0.0
			emit_spread = 44.0
			Velocity = 24.0
			Friction = (0.0, 66.0)
			Time = 2.0
		}
		FormatText ChecksumName = fx2_id 'big_bolt_particle2%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		<particle_pos> = (<pos2d> - (0.0, 0.0))
		Create2DParticleSystem {
			Id = <fx2_id>
			Pos = <particle_pos>
			z_priority = 8.0
			Material = sys_Particle_Star02_sys_Particle_Star02
			PARENT = <container_id>
			start_color = [255 255 255 255]
			end_color = [128 128 128 0]
			start_scale = (0.5, 0.5)
			end_scale = (0.25, 0.25)
			start_angle_spread = 360.0
			min_rotation = -120.0
			max_rotation = 508.0
			emit_start_radius = 0.0
			emit_radius = 2.0
			Emit_Rate = 0.04
			emit_dir = 0.0
			emit_spread = 28.0
			Velocity = 22.0
			Friction = (0.0, 55.0)
			Time = 2.0
		}
		FormatText ChecksumName = fx3_id 'big_bolt_particle3%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		<particle_pos> = (<pos2d> - (0.0, 15.0))
		Create2DParticleSystem {
			Id = <fx3_id>
			Pos = <particle_pos>
			z_priority = 8.0
			Material = sys_Particle_Spark01_sys_Particle_Spark01
			PARENT = <container_id>
			start_color = [0 255 255 255]
			end_color = [0 255 255 0]
			start_scale = (1.5, 1.5)
			end_scale = (0.25, 0.25)
			start_angle_spread = 360.0
			min_rotation = -500.0
			max_rotation = 500.0
			emit_start_radius = 0.0
			emit_radius = 2.0
			Emit_Rate = 0.04
			emit_dir = 0.0
			emit_spread = 180.0
			Velocity = 12.0
			Friction = (0.0, 0.0)
			Time = 1.0
		}
	endif
	gem_count = (<gem_count> + 1)
	repeat <array_Size>
	Wait \{$star_power_bolt_time
		Seconds}
	gem_count = 0
	begin
	<note> = ($<Song> [<array_entry>] [(<gem_count> + 1)])
	if (<note> > 0)
		FormatText ChecksumName = Name 'big_bolt%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		DestroyScreenElement Id = <Name>
		FormatText ChecksumName = fx_id 'big_bolt_particle%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx_id>
		FormatText ChecksumName = fx2_id 'big_bolt_particle2%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx2_id>
		FormatText ChecksumName = fx3_id 'big_bolt_particle3%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx3_id>
		Wait \{1
			GameFrame}
	endif
	gem_count = (<gem_count> + 1)
	repeat <array_Size>
endscript

script guitarevent_starsequencebonus_PSWii 
	wait_for_correct_frame player = ($<player_status>.player)
	if ($is_attract_mode = 1)
		return
	endif
	change structurename = <player_status> sp_phrases_hit = ($<player_status>.sp_phrases_hit + 1)
	soundevent \{event = star_power_awarded_sfx}
	formattext checksumname = container_id 'gem_container%p' p = ($<player_status>.text) addtostringlookup = true
	getarraysize \{$gem_colors}
	gem_count = 0
	begin
	<note> = ($<song> [<array_entry>] [(<gem_count> + 1)])
	if (<note> > 0)
		color = ($gem_colors [<gem_count>])
		if ($<player_status>.lefthanded_button_ups = 1)
			<pos2d> = ($button_up_models.<color>.left_pos_2d)
			<angle> = ($button_models.<color>.angle)
		else
			<pos2d> = ($button_up_models.<color>.pos_2d)
			<angle> = ($button_models.<color>.left_angle)
		endif
		formattext checksumname = name 'big_bolt%p%e' p = ($<player_status>.text) e = <gem_count> addtostringlookup = true
		createscreenelement {
			type = spriteelement
			id = <name>
			parent = <container_id>
			material = sys_big_bolt01_sys_big_bolt01
			blend = add
			use_animated_uvs = true
			top_down_v
			frame_length = 0.005
			num_uv_frames = (8.0, 1.0)
			rgba = [255 255 255 255]
			pos = <pos2d>
			rot_angle = <angle>
			scale = (0.5 * $star_power_bolt_scale)
			just = [center bottom]
			z_priority = 6
		}
	endif
	gem_count = (<gem_count> + 1)
	repeat <array_size>
	wait \{$star_power_bolt_time
		seconds}
	gem_count = 0
	begin
	<note> = ($<song> [<array_entry>] [(<gem_count> + 1)])
	if (<note> > 0)
		formattext checksumname = name 'big_bolt%p%e' p = ($<player_status>.text) e = <gem_count> addtostringlookup = true
		destroyscreenelement id = <name>
		waitonegameframe
	endif
	gem_count = (<gem_count> + 1)
	repeat <array_size>
endscript

script GuitarEvent_Multiplier4xOn_Spawned 
	GetGlobalTags \{user_options}
	if (<black_background> = 1)
		return
	endif
	if ($disable_band = 0)
		ObjID = (<player_status>.band_Member)
		GetPakManCurrent \{map = Zones}
		if NOT (<pak> = Z_Soundcheck)
			Wait \{1
				GameFrame}
			SafeGetUniqueCompositeObjectID PreferredId = FingerSparks01 ObjID = <ObjID>
			CreateParticleSystem_Fast Name = <UniqueId> ObjID = <ObjID> groupID = zoneParticles Bone = Bone_Hand_Middle_Mid_L params_Script = $GP_4X_FingerSparks01
			MangleChecksums A = <UniqueId> B = <ObjID>
			Change StructureName = <player_status> FourX_FingerFXID01 = <mangled_ID>
			Wait \{1
				GameFrame}
			SafeGetUniqueCompositeObjectID PreferredId = FingerFlames01 ObjID = <ObjID>
			CreateParticleSystem_Fast Name = <UniqueId> ObjID = <ObjID> groupID = zoneParticles Bone = Bone_Hand_Middle_Mid_L params_Script = $GP_4X_FingerFlames01
			MangleChecksums A = <UniqueId> B = <ObjID>
			Change StructureName = <player_status> FourX_FingerFXID02 = <mangled_ID>
			Wait \{1
				GameFrame}
			SafeGetUniqueCompositeObjectID PreferredId = FingerSparks02 ObjID = <ObjID>
			CreateParticleSystem_Fast Name = <UniqueId> ObjID = <ObjID> groupID = zoneParticles Bone = Bone_Hand_Middle_Mid_R params_Script = {$GP_4X_FingerSparks01 Emit_Target = (0.0, -1.0, 0.0)}
			MangleChecksums A = <UniqueId> B = <ObjID>
			Change StructureName = <player_status> FourX_FingerFXID03 = <mangled_ID>
			Wait \{1
				GameFrame}
			SafeGetUniqueCompositeObjectID PreferredId = FingerFlames02 ObjID = <ObjID>
			CreateParticleSystem_Fast Name = <UniqueId> ObjID = <ObjID> groupID = zoneParticles Bone = Bone_Hand_Middle_Mid_R params_Script = $GP_4X_FingerFlames01
			MangleChecksums A = <UniqueId> B = <ObjID>
			Change StructureName = <player_status> FourX_FingerFXID04 = <mangled_ID>
		endif
	endif
endscript

script GuitarEvent_WhammyOn 
	GetGlobalTags \{user_options}
	if (<no_whammy_particles> = 0)
		WhammyFXOn <...>
	endif
endscript

script highway_pulse_black 
	GetGlobalTags \{user_options}
	if ((<black_highway> = 1) || (<transparent_highway> = 1))
		return
	endif
	<half_time> = ($highway_pulse_time / 2.0)
	FormatText ChecksumName = Highway 'Highway_2D%p' P = <player_Text> AddToStringLookup = TRUE
	DoScreenElementMorph Id = <Highway> rgba = ($highway_pulse) Time = <half_time>
	Wait <half_time> Seconds
	DoScreenElementMorph Id = <Highway> rgba = ($highway_normal) Time = <half_time>
endscript
