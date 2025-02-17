script GuitarEvent_HitNote 
	SpawnScriptNow GuitarEvent_HitNote_Spawned Params = {<...>}
	if ($firework_gems = 1)
		SpawnScriptNow GuitarEvent_StarSequenceBonus Params = {<...> fireworks = 1}
	endif
endscript

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
	if ($fc_hud_spawned = 0)
		dx_create_fc_hud
	endif
	if ($fc_hud_moved = 0)
		dx_fc_hud_watchdog
	endif
endscript

script GuitarEvent_MissedNote 
	if (<bum_note> = 1)
		Guitar_Wrong_Note_Sound_Logic <...>
	endif
	if ($is_network_game && ($<player_status>.Player = 2))
		if (<silent_miss> = 1)
			SpawnScriptNow highway_pulse_black Params = {player_Text = ($<player_status>.Text)}
		endif
	else
		if NOT ($<player_status>.guitar_volume = 0)
			if (<silent_miss> = 1)
				SpawnScriptNow highway_pulse_black Params = {player_Text = ($<player_status>.Text)}
			else
				Change StructureName = <player_status> guitar_volume = 0
				UpdateGuitarVolume
			endif
		endif
	endif
	CrowdDecrease player_status = <player_status>
	if ($always_strum = FALSE)
		if ($disable_band = 0)
			if CompositeObjectExists Name = (<player_status>.band_Member)
				LaunchEvent Type = Anim_MissedNote Target = (<player_status>.band_Member)
			endif
		endif
	endif
	note_time = ($<Song> [<array_entry>] [0])
	if ($show_play_log = 1)
		output_log_text "Missed Note (%t)" T = <note_time> Color = Orange
	endif
	if ($fc_hud_moved = 0)
		Change dont_create_fc_hud = 1
	endif
	Change fc_hud_go_away = 1
	dx_fc_hud_watchdog
	GetGlobalTags \{user_options}
	if (<insta_fail> = 1)
		GuitarEvent_SongFailed
	endif
endscript

script GuitarEvent_UnnecessaryNote 
	Guitar_Wrong_Note_Sound_Logic <...>
	if NOT ($is_network_game && ($<player_status>.Player = 2))
		Change StructureName = <player_status> guitar_volume = 0
		UpdateGuitarVolume
	endif
	CrowdDecrease player_status = <player_status>
	if ($always_strum = FALSE)
		if ($disable_band = 0)
			if CompositeObjectExists Name = (<player_status>.band_Member)
				LaunchEvent Type = Anim_MissedNote Target = (<player_status>.band_Member)
			endif
		endif
	endif
	if ($show_play_log = 1)
		if (<array_entry> > 0)
			<songtime> = (<songtime> - ($check_time_early * 1000.0))
			next_note = ($<Song> [<array_entry>] [0])
			prev_note = ($<Song> [(<array_entry> -1)] [0])
			next_time = (<next_note> - <songtime>)
			prev_time = (<songtime> - <prev_note>)
			if (<prev_time> < ($check_time_late * 1000.0))
				<prev_time> = 1000000.0
			endif
			if (<next_time> < <prev_time>)
				<next_time> = (0 - <next_time>)
				output_log_text "ME: %n (%t)" N = <next_time> T = <next_note> Color = RED
			else
				output_log_text "ML: %n (%t)" N = <prev_time> T = <prev_note> Color = darkred
			endif
		endif
	endif
	if ($fc_hud_moved = 0)
		Change dont_create_fc_hud = 1
	endif
	Change fc_hud_go_away = 1
	dx_fc_hud_watchdog
	GetGlobalTags \{user_options}
	if (<insta_fail> = 1)
		GuitarEvent_SongFailed
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

script Guitar_Wrong_Note_Sound_Logic
	GetGlobalTags \{user_options}
	if (<no_miss_sfx> = 0)
		if ($current_num_players = 1)
			get_song_rhythm_track Song = ($current_song)
			if ($<player_status>.part = RHYTHM)
				if (<rhythm_track> = 1)
					SoundEvent \{Event = Single_Player_Bad_Note_Guitar}
				else
					SoundEvent \{Event = Single_Player_Bad_Note_Bass}
				endif
			else
				SoundEvent \{Event = Single_Player_Bad_Note_Guitar}
			endif
		else
			if ($<player_status>.Player = 1)
				get_song_rhythm_track Song = ($current_song)
				if ($<player_status>.part = RHYTHM)
					if (<rhythm_track> = 1)
						SoundEvent \{Event = First_Player_Bad_Note_Guitar}
					else
						SoundEvent \{Event = First_Player_Bad_Note_Bass}
					endif
				else
					SoundEvent \{Event = First_Player_Bad_Note_Guitar}
				endif
			else
				get_song_rhythm_track Song = ($current_song)
				if ($boss_battle = 1)
					SoundEvent \{Event = Second_Player_Bad_Note_Guitar}
				else
					if ($<player_status>.part = RHYTHM)
						if (<rhythm_track> = 1)
							SoundEvent \{Event = Second_Player_Bad_Note_Guitar}
						else
							SoundEvent \{Event = Second_Player_Bad_Note_Bass}
						endif
					else
						SoundEvent \{Event = Second_Player_Bad_Note_Guitar}
					endif
				endif
			endif
		endif
	endif
endscript

script GuitarEvent_Multiplier4xOff 
	GetGlobalTags \{user_options}
	if (<no_miss_sfx> = 0)
		SoundEvent \{Event = UI_SFX_Lose_Multiplier_4X}
		SoundEvent \{Event = Lose_Multiplier_Crowd}
	endif
	SpawnScriptNow highway_pulse_multiplier_loss Params = {player_Text = ($<player_status>.Text) Multiplier = 4}
	kill_4x_fx <...>
endscript

script GuitarEvent_Multiplier3xOff 
	GetGlobalTags \{user_options}
	if (<no_miss_sfx> = 0)
		SoundEvent \{Event = UI_SFX_Lose_Multiplier_3X}
	endif
	SpawnScriptNow highway_pulse_multiplier_loss Params = {player_Text = ($<player_status>.Text) Multiplier = 3}
endscript

script GuitarEvent_Multiplier2xOff 
	GetGlobalTags \{user_options}
	if (<no_miss_sfx> = 0)
		SoundEvent \{Event = UI_SFX_Lose_Multiplier_2X}
	endif
	SpawnScriptNow highway_pulse_multiplier_loss Params = {player_Text = ($<player_status>.Text) Multiplier = 2}
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
	if NOT (<fireworks> = 1)
		SoundEvent \{Event = Star_Power_Awarded_SFX}
	endif
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
	if NOT (<fireworks> = 1)
		soundevent \{event = star_power_awarded_sfx}
	endif
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