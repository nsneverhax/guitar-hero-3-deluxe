dlc_script_version = 1

script intro_song_info 
	begin
	getsongtimems
	if ($current_intro.song_title_start_time + $current_starttime < <time>)
		break
	endif
	wait \{1
		gameframe}
	repeat
	if ($current_intro.song_title_on_time = 0)
		return
	endif
	get_song_title song = ($current_song)
	GetUpperCaseString <song_title>
	intro_song_info_text :setprops text = <uppercasestring>
	intro_song_info_text :DoMorph Pos = ($current_intro.song_title_pos)
	get_song_artist song = ($current_song)
	GetUpperCaseString <song_artist>
	intro_artist_info_text :setprops text = <uppercasestring>
	intro_artist_info_text :DoMorph Pos = ($current_intro.song_artist_pos)
	get_song_artist_text song = ($current_song)
	GetUpperCaseString <song_artist_text>
	intro_performed_by_text :setprops text = <uppercasestring>
	intro_performed_by_text :DoMorph Pos = ($current_intro.performed_by_pos)
	get_song_covered_by song = ($current_song)
	if GotParam \{covered_by}
		GetUpperCaseString <covered_by>
		CreateScreenElement \{type = TextElement
		parent = root_window
		id = intro_covered_by_text
		font = text_a10
		just = [
			left
			top
		]
		Scale = (1.0, 0.5)
		rgba = [
			230
			205
			160
			255
		]
		text = "COVERED BY"
		z_priority = 5.0
		alpha = 0
		shadow
		shadow_offs = (1.0, 1.0)}
		CreateScreenElement \{type = TextElement
			parent = root_window
			id = intro_covered_by
			font = text_a10
			just = [
				left
				top
			]
			Scale = 1.0
			rgba = [
				255
				190
				70
				255
			]
			text = "Coverer"
			z_priority = 5.0
			alpha = 0
			shadow
			shadow_offs = (1.0, 1.0)}
		intro_covered_by_text :DoMorph Pos = ((255.0, 200.0))
		intro_covered_by :setprops text = <uppercasestring>
		intro_covered_by :DoMorph Pos = ((255.0, 215.0))
	endif
	intro_song_info_text :setprops \{z_priority = 5.0}
	intro_artist_info_text :setprops \{z_priority = 5.0}
	intro_performed_by_text :setprops \{z_priority = 5.0}
	DoScreenElementMorph id = intro_song_info_text alpha = 1 time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph id = intro_performed_by_text alpha = 1 time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph id = intro_artist_info_text alpha = 1 time = ($current_intro.song_title_fade_time / 1000.0)
	if GotParam \{covered_by}
		DoScreenElementMorph id = intro_covered_by_text alpha = 1 time = ($current_intro.song_title_fade_time / 1000.0)
		DoScreenElementMorph id = intro_covered_by alpha = 1 time = ($current_intro.song_title_fade_time / 1000.0)
	endif
	wait ($current_intro.song_title_on_time / 1000.0) seconds
	DoScreenElementMorph id = intro_song_info_text alpha = 0 time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph id = intro_artist_info_text alpha = 0 time = ($current_intro.song_title_fade_time / 1000.0)
	DoScreenElementMorph id = intro_performed_by_text alpha = 0 time = ($current_intro.song_title_fade_time / 1000.0)
	if GotParam \{covered_by}
		DoScreenElementMorph id = intro_covered_by_text alpha = 0 time = ($current_intro.song_title_fade_time / 1000.0)
		DoScreenElementMorph id = intro_covered_by alpha = 0 time = ($current_intro.song_title_fade_time / 1000.0)
		wait ($current_intro.song_title_fade_time / 1000.0) seconds
		DestroyScreenElement \{id = intro_covered_by_text}
		DestroyScreenElement \{id = intro_covered_by}
	endif
endscript

script destroy_intro 
	KillSpawnedScript \{id = intro_scripts}
	KillSpawnedScript \{name = Song_Intro_Kick_SFX_Waiting}
	KillSpawnedScript \{name = Song_Intro_Highway_Up_SFX_Waiting}
	KillSpawnedScript \{name = move_highway_2d}
	KillSpawnedScript \{name = intro_buttonup_ripple}
	KillSpawnedScript \{name = intro_hud_move}
	DoScreenElementMorph \{id = intro_song_info_text
		alpha = 0}
	DoScreenElementMorph \{id = intro_artist_info_text
		alpha = 0}
	DoScreenElementMorph \{id = intro_performed_by_text
		alpha = 0}
	if ScreenElementExists \{id = intro_covered_by}
		DestroyScreenElement \{id = intro_covered_by}
	endif
	if ScreenElementExists \{id = intro_covered_by_text}
		DestroyScreenElement \{id = intro_covered_by_text}
	endif
	player = 1
	begin
	FormatText checksumname = player_status 'player%i_status' i = <player> addtostringlookup
	EnableInput controller = ($<player_status>.controller)
	player = (<player> + 1)
	repeat $current_num_players
endscript

script get_song_covered_by \{song = invalid}
	if StructureContains structure = $gh3_songlist_props <song>
		if StructureContains structure = ($gh3_songlist_props.<song>) covered_by
			return covered_by = ($gh3_songlist_props.<song>.covered_by) TRUE
		else
			return \{FALSE}
		endif
	endif
	printstruct <...>
	scriptassert \{"Song not found"}
endscript

script setlist_songpreview_monitor 
	begin
	if NOT ($current_setlist_songpreview = $target_setlist_songpreview)
		change \{setlist_songpreview_changing = 1}
		song = ($target_setlist_songpreview)
		SongUnLoadFSB
		wait \{0.5 second}
		if ($target_setlist_songpreview != <song> || $target_setlist_songpreview = None)
			change \{current_setlist_songpreview = None}
			change \{setlist_songpreview_changing = 0}
		else
			get_song_prefix song = <song>
			get_song_struct song = <song>
			if StructureContains structure = <song_struct> streamname
				song_prefix = (<song_struct>.streamname)
			endif
			if NOT SongLoadFSB song_prefix = <song_prefix>
				change \{setlist_songpreview_changing = 0}
				downloadcontentlost
				return
			endif
			FormatText checksumname = song_preview '%s_preview' s = <song_prefix>
			get_song_struct song = <song>
			soundbussunlock \{music_setlist}
			if StructureContains structure = <song_struct> name = band_playback_volume
				setlistvol = ((<song_struct>.band_playback_volume))
				setsoundbussparams {music_setlist = {vol = <setlistvol>}}
			else
				setsoundbussparams \{music_setlist = {vol = 0.0}}
			endif
			SoundBussLock \{music_setlist}
			playsound <song_preview> buss = music_setlist
			change current_setlist_songpreview = <song>
			change \{setlist_songpreview_changing = 0}
		endif
	elseif NOT ($current_setlist_songpreview = None)
		song = ($current_setlist_songpreview)
		get_song_prefix song = <song>
		FormatText checksumname = song_preview '%s_preview' s = <song_prefix>
		if NOT issoundplaying <song_preview>
			change \{setlist_songpreview_changing = 1}
			if NOT SongLoadFSB song_prefix = <song_prefix>
				change \{setlist_songpreview_changing = 0}
				downloadcontentlost
				return
			endif
			playsound <song_preview> buss = music_setlist
			change \{setlist_songpreview_changing = 0}
		endif
	endif
	wait \{1 gameframe}
	repeat
endscript

script downloadcontentlost 
	change \{is_changing_levels = 0}
	change \{practice_songpreview_changing = 0}
	printscriptinfo \{"DownloadContentLost"}
	spawnscriptnow \{noqbid DownloadContentLost_Spawned}
	KillSpawnedScript \{name = setlist_choose_song}
	KillSpawnedScript \{name = downloadcontentlost}
endscript

script SongUnLoadFSBIfDownloaded 
	GetContentFolderIndexFromFile ($song_fsb_name)
	if NOT ($song_fsb_id = -1)
		if (<device> = content)
			UnLoadFSB \{fsb_index = $song_fsb_id}
			spawnscriptnow Downloads_CloseContentFolder params = {content_index = <content_index>}
			change \{song_fsb_id = -1}
			change \{song_fsb_name = 'none'}
		endif
	endif
endscript

script Downloads_CloseContentFolder \{force = 0}
	mark_unsafe_for_shutdown
	if (<force> = 1)
		if ($downloadcontentfolder_index = -1)
			mark_safe_for_shutdown
			return
		endif
	endif
	if (<force> = 1)
		change \{downloadcontentfolder_count = 0}
	else
		change downloadcontentfolder_count = ($downloadcontentfolder_count - 1)
		if ($downloadcontentfolder_count > 0)
			mark_safe_for_shutdown
			return \{TRUE}
		endif
	endif
	if (<force> = 1)
		content_index = ($downloadcontentfolder_index)
	else
		change \{downloadcontentfolder_index = -1}
	endif
	if NOT CloseContentFolder content_index = <content_index>
		change \{downloadcontentfolder_lock = 0}
		mark_safe_for_shutdown
		return \{FALSE}
	endif
	begin
	GetContentFolderState
	if (<contentfolderstate> = free)
		break
	endif
	wait \{1 gameframe}
	repeat
	change \{downloadcontentfolder_lock = 0}
	mark_safe_for_shutdown
	return \{TRUE}
endscript

script Downloads_OpenContentFolder 
	unpausespawnedscript \{Downloads_CloseContentFolder}
	mark_unsafe_for_shutdown
	begin
	if ($downloadcontentfolder_lock = 0)
		break
	endif
	if ($downloadcontentfolder_index = <content_index>)
		change downloadcontentfolder_count = ($downloadcontentfolder_count + 1)
		mark_safe_for_shutdown
		return \{TRUE}
	endif
	wait \{1 gameframe}
	repeat
	change \{downloadcontentfolder_lock = 1}
	if NOT OpenContentFolder content_index = <content_index>
		mark_safe_for_shutdown
		return \{FALSE}
	endif
	begin
	GetContentFolderState
	if (<contentfolderstate> = failed)
		change \{downloadcontentfolder_lock = 0}
		mark_safe_for_shutdown
		return \{FALSE}
	endif
	if (<contentfolderstate> = opened)
		break
	endif
	wait \{1 gameframe}
	repeat
	change downloadcontentfolder_count = ($downloadcontentfolder_count + 1)
	change downloadcontentfolder_index = <content_index>
	mark_safe_for_shutdown
	return \{TRUE}
endscript

script crowd_monitor_performance 
	lighters_on = FALSE
	begin
	get_skill_level
	if ($current_song = dlc19)
		skill = good
	endif
	if (<skill> != bad)
		if (<lighters_on> = FALSE)
			Crowd_AllSetHand \{Hand = RIGHT type = lighter}
			Crowd_AllPlayAnim \{anim = special}
			lighters_on = TRUE
			Crowd_ToggleLighters \{on}
		endif
	else
		if (<lighters_on> = TRUE)
			Crowd_AllSetHand \{Hand = RIGHT type = clap}
			Crowd_AllPlayAnim \{anim = idle}
			lighters_on = FALSE
			Crowd_ToggleLighters \{Off}
		endif
	endif
	wait \{1 gameframe}
	repeat
endscript

script Transition_StartRendering 
	printf \{"Transition_StartRendering"}
	startrendering
	enable_pause
	change \{is_changing_levels = 0}
	if ($blade_active = 1)
		gh3_start_pressed
	endif
	if ($current_song = dlc19)
		crowd_create_lighters
		Crowd_StartLighters
	endif
endscript

script first_gem_fx 
	extendcrc <gem_id> '_particle' out = fx_id
	if GotParam \{is_star}
		if ($game_mode = p2_battle || $boss_battle = 1)
			<Pos> = (125.0, 170.0)
		else
			if ($player1_status.star_power_used = 1)
				<Pos> = (95.0, 20.0)
			else
				<Pos> = (255.0, 170.0)
			endif
		endif
	else
		<Pos> = (66.0, 20.0)
	endif
	destroy2dparticlesystem id = <fx_id>
	create2dparticlesystem {
		id = <fx_id>
		Pos = <Pos>
		z_priority = 8.0
		material = sys_Particle_lnzflare02_sys_Particle_lnzflare02
		parent = <gem_id>
		start_color = [255 255 255 255]
		end_color = [255 255 255 0]
		start_scale = (1.0, 1.0)
		end_scale = (2.0, 2.0)
		start_angle_spread = 360.0
		min_rotation = -500.0
		max_rotation = 500.0
		emit_start_radius = 0.0
		emit_radius = 0.0
		emit_rate = 0.3
		emit_dir = 0.0
		emit_spread = 160.0
		velocity = 0.01
		friction = (0.0, 0.0)
		time = 1.25
	}
	spawnscriptnow destroy_first_gem_fx params = {gem_id = <gem_id> fx_id = <fx_id>}
	wait \{0.8 seconds}
	destroy2dparticlesystem id = <fx_id> kill_when_empty
endscript
