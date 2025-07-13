script Transition_SelectTransition \{practice_intro = 0}
	if (<practice_intro> = 1)
		return
	endif

	GetGlobalTags \{user_options}
	using_z_dive = 0
	GetPakManCurrent \{map = Zones}
	switch <pak>
		case Z_Dive 
			using_z_dive = 1
	endswitch
	if (<dx_force_encore> = 1 && <using_z_dive> = 1)
		Change \{current_transition = ENCORE}
		return
	endif

	if ($current_transition = debugintro)
		Change \{current_transition = INTRO}
		return
	endif
	if ($game_mode = p1_career ||
			$game_mode = p2_career)
		get_progression_globals game_mode = ($game_mode) use_current_tab = 1
		Career_Songs = <tier_global>
		Tier = ($setlist_selection_tier)
		FormatText ChecksumName = tier_checksum 'tier%s' S = <Tier>
		if NOT StructureContains Structure = ($<Career_Songs>) <tier_checksum>
			Change \{current_transition = INTRO}
			return
		endif
		if Progression_IsBossSong tier_global = <tier_global> Tier = <Tier> Song = ($current_song)
			if should_play_boss_intro
				if NOT ($current_song = bossdevil)
					Change \{current_transition = boss}
				else
					Change \{current_transition = FASTINTRO}
				endif
			else
				Change \{current_transition = FASTINTRO}
			endif
			return
		endif
		if Progression_IsEncoreSong tier_global = <tier_global> Tier = <Tier> Song = ($current_song)
			Change \{current_transition = ENCORE}
			return
		endif
	endif
	if ($game_mode = p1_quickplay)
		get_progression_globals game_mode = ($game_mode) use_current_tab = 1
		SetList_Songs = <tier_global>
		Tier = ($setlist_selection_tier)
		FormatText ChecksumName = tier_checksum 'tier%s' S = <Tier>
		if NOT StructureContains Structure = ($<SetList_Songs>) <tier_checksum>
			Change \{current_transition = INTRO}
			return
		endif
	endif
	Change \{current_transition = INTRO}
endscript