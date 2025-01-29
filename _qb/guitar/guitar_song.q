script preload_song \{starttime = 0
		fadeintime = 0.0}
	printf "song %s" s = <song_name>
	change \{song_stream_id = null}
	change \{song_unique_id = null}
	change \{guitar_player1_stream_id = null}
	change \{guitar_player1_unique_id = null}
	change \{guitar_player2_stream_id = null}
	change \{guitar_player2_unique_id = null}
	change \{extra_stream_id = null}
	change \{extra_unique_id = null}
	change \{band_stream_id = null}
	change \{band_unique_id = null}
	change \{crowd_stream_id = null}
	change \{crowd_unique_id = null}
	get_song_prefix song = <song_name>
	get_song_struct song = <song_name>
	if structurecontains structure = <song_struct> streamname
		song_prefix = (<song_struct>.streamname)
	endif
	if NOT songloadfsb song_prefix = <song_prefix>
		downloadcontentlost
		return
	endif
	stream_config = gh1
	get_song_struct song = <song_name>
	if structurecontains structure = <song_struct> name = version
		stream_config = (<song_struct>.version)
	endif
	soundbussunlock \{band_balance}
	soundbussunlock \{guitar_balance}
	if structurecontains structure = <song_struct> name = band_playback_volume
		setsoundbussparams {band_balance = {vol = ((<song_struct>.band_playback_volume) - 1.5)}} time = <fadeintime>
	else
		setsoundbussparams {band_balance = {vol = -1.5}} time = <fadeinttime>
	endif
	if structurecontains structure = <song_struct> name = guitar_playback_volume
		setsoundbussparams {guitar_balance = {vol = ((<song_struct>.guitar_playback_volume) - 1.5)}} time = <fadeintime>
	else
		setsoundbussparams {guitar_balance = {vol = -1.5}} time = <fadeintime>
	endif
	soundbusslock \{band_balance}
	soundbusslock \{guitar_balance}
	change stream_config = <stream_config>
	formattext checksumname = song_stream '%s_song' s = <song_prefix> addtostringlookup
	formattext checksumname = guitar_stream '%s_guitar' s = <song_prefix> addtostringlookup
	formattext checksumname = rhythm_stream '%s_rhythm' s = <song_prefix> addtostringlookup
	formattext checksumname = crowd_stream '%s_crowd' s = <song_prefix> addtostringlookup
	if ($game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_bass_quickplay ||
			($game_mode = training && ($player1_status.part = rhythm)))
		if structurecontains structure = <song_struct> use_coop_notetracks
			formattext checksumname = song_stream '%s_coop_song' s = <song_prefix> addtostringlookup
			formattext checksumname = guitar_stream '%s_coop_guitar' s = <song_prefix> addtostringlookup
			formattext checksumname = rhythm_stream '%s_coop_rhythm' s = <song_prefix> addtostringlookup
		endif
	endif
	change song_stream_id = <song_stream>
	if preloadstream <song_stream> buss = master
		change song_unique_id = <unique_id>
	else
		scriptassert "Could not load song track for %s" s = <song_prefix>
	endif
	extra_stream = null
	if (<stream_config> = gh3)
		change crowd_stream_id = <crowd_stream>
		if preloadstream <crowd_stream> buss = master
			change crowd_unique_id = <unique_id>
		endif
		<extra_stream> = <rhythm_stream>
	endif
	if structurecontains structure = <song_struct> name = extra_stream
		formattext checksumname = extra_stream '%s_%t' s = <song_prefix> t = (<song_struct>.extra_stream) addtostringlookup
	endif
	if ($current_num_players = 1)
		if (($player1_status.part) = rhythm && (<stream_config> != gh1))
			if NOT preloadstream <extra_stream> buss = master
				scriptassert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
			change guitar_player1_unique_id = <unique_id>
			<extra_stream> = <guitar_stream>
		else
			if NOT preloadstream <guitar_stream> buss = master
				scriptassert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
			change guitar_player1_unique_id = <unique_id>
			<extra_stream> = <rhythm_stream>
		endif
		if NOT (<extra_stream> = null)
			change extra_stream_id = <extra_stream>
			if preloadstream <extra_stream> buss = master
				change extra_unique_id = <unique_id>
			endif
		endif
	else
		if (($player1_status.part) = rhythm && (<stream_config> != gh1))
			change guitar_player1_stream_id = <extra_stream>
			if NOT preloadstream <extra_stream> buss = master
				scriptassert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
		else
			change guitar_player1_stream_id = <guitar_stream>
			if NOT preloadstream <guitar_stream> buss = master
				scriptassert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
		endif
		change guitar_player1_unique_id = <unique_id>
		if (($player2_status.part) = rhythm && (<stream_config> != gh1))
			change guitar_player2_stream_id = <extra_stream>
			if NOT preloadstream <extra_stream> buss = master
				scriptassert "Could not load player2 guitar track for %s" s = <song_prefix>
			endif
		else
			change guitar_player2_stream_id = <guitar_stream>
			if NOT preloadstream <guitar_stream> buss = master
				scriptassert "Could not load player2 guitar track for %s" s = <song_prefix>
			endif
		endif
		change guitar_player2_unique_id = <unique_id>
		if (<stream_config> != gh1)
			if NOT ((($player1_status.part) = rhythm) || (($player2_status.part) = rhythm))
				change extra_stream_id = <extra_stream>
				if preloadstream <extra_stream> buss = master
					change extra_unique_id = <unique_id>
				endif
			endif
		endif
	endif
	waitforpreload_song <...>
	change \{song_paused = 1}
	setlastguitarvolume \{player = 1
		last_guitar_volume = 100}
	setlastguitarvolume \{player = 2
		last_guitar_volume = 100}
	startpreloadpaused_song
	setseekposition_song position = <starttime>
endscript
