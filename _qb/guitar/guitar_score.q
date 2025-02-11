script update_score_fast 
	if ((IsPS2) || IsNGC)
		update_score_fast_PSWii <...>
		return
	endif
	GetGlobalTags \{user_options}
	UpdateScoreFastInit player_status = <player_status>
	begin
	GetSongTimeMS
	UpdateScoreFastPerFrame player_status = <player_status> Time = <Time>
	if (<track_muting> = 1)
		Change StructureName = <player_status> guitar_volume = 100
		UpdateGuitarVolume
	endif
	Wait \{1
		GameFrame}
	repeat
endscript

script update_score_fast_PSWii
	updatescorefastinit player_status = <player_status>
	begin
	wait_for_correct_frame player = ($<player_status>.player)
	waitonegameframe
	getsongtimems
	updatescorefastperframe player_status = <player_status> time = <time>
	if (<track_muting> = 1)
		Change StructureName = <player_status> guitar_volume = 100
		UpdateGuitarVolume
	endif
	repeat
endscript