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
		p1_best_run = ($player1_status.best_run)
		p1_total_notes = ($player1_status.total_notes)
		p1_notes_hit = ($player1_status.NOTES_HIT)
		SetGlobalTags <songname> Params = {NotesHit = <p1_notes_hit>}
		SetGlobalTags <songname> Params = {TotalNotes = <p1_total_notes>}
		if ((<p1_percent_complete> = 100) && (<p1_best_run> = <p1_total_notes>))
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