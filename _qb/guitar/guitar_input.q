script control_whammy_pitchshift 
	if ($boss_battle = 1)
		if (($<player_status>.Player) = 2)
			return
		endif
	endif
	<set_pitch> = 0
	if GotParam \{net_whammy_length}
		<len> = <net_whammy_length>
		<set_pitch> = 1
	else
		if GuitarGetAnalogueInfo controller = ($<player_status>.controller)
			<set_pitch> = 1
			if ($<player_status>.bot_play = 1)
				<len> = 0.0
			elseif IsGuitarController controller = ($<player_status>.controller)
				<len> = ((<RightX> - $<player_status>.resting_whammy_position) / (1.0 - $<player_status>.resting_whammy_position))
				if (<len> < 0.0)
					<len> = 0.0
				endif
			else
				if (<leftlength> > 0)
					<len> = <leftlength>
				else
					if (<rightlength> > 0)
						<len> = <rightlength>
					else
						<len> = 0
					endif
				endif
			endif
			if (($is_network_game) && ($<player_status>.Player = 1))
				Change StructureName = <player_status> net_whammy = <len>
			endif
		endif
	endif
	if (<set_pitch> = 1)
		GetGlobalTags \{user_options}
		if (<no_whammy_pitch_shift> = 0)
			set_whammy_pitchshift control = <len> player_status = <player_status>
		endif
		<whammy_scale> = (((<len> * 0.5) + 0.5) * 2.0)
		SetNewWhammyValue Value = <whammy_scale> time_remaining = <Time> player_status = <player_status> Player = (<player_status>.Player)
	endif
endscript

script net_whammy_pitch_shift 
	if ($pitch_dirty = 1)
		Change \{pitch_dirty = 0}
		Change prev_len = <net_whammy_length>
		begin
		control_whammy_pitchshift Song = <Song> array_entry = <array_entry> pattern = <pattern> player_status = <player_status> net_whammy_length = <net_whammy_length> Time = <Time>
		Wait \{1
			GameFrame}
		repeat
	else
		<len_delta> = (<net_whammy_length> - $prev_len)
		<len_base> = ($prev_len)
		Change prev_len = <net_whammy_length>
		<frames> = 5
		<Scale> = (1.0 / <frames>)
		<scale_step> = <Scale>
		begin
		<len> = (<len_base> + (<len_delta> * <Scale>))
		set_whammy_pitchshift control = <len> player_status = <player_status>
		<whammy_scale> = (((<len> * 0.5) + 0.5) * 2.0)
		SetNewWhammyValue Value = <whammy_scale> time_remaining = <Time> player_status = <player_status> Player = (<player_status>.Player)
		<Scale> = (<Scale> + <scale_step>)
		Wait \{1
			GameFrame}
		repeat <frames>
		begin
		if (<no_whammy_pitch_shift> = 0)
			set_whammy_pitchshift control = <net_whammy_length> player_status = <player_status>
		endif
		<whammy_scale> = (((<net_whammy_length> * 0.5) + 0.5) * 2.0)
		SetNewWhammyValue Value = <whammy_scale> time_remaining = <Time> player_status = <player_status> Player = (<player_status>.Player)
		Wait \{1
			GameFrame}
		repeat
	endif
endscript

script star_power_activate_and_drain 
	if ($overlapping_sp = 1)
		Change StructureName = <player_status> star_power_used = 0
		Change StructureName = <player_status> star_power_overlap = 1
	else
		Change StructureName = <player_status> star_power_used = 1
	endif
	SpawnScriptNow hud_activated_star_power Params = {Player = <Player>}
	Wait \{1
		GameFrame}
	LaunchGemEvent Event = star_power_on Player = <Player>
	ExtendCRC star_power_on <player_Text> out = Type
	BroadCastEvent Type = <Type> Data = {player_Text = <player_Text> Player = <Player> player_status = <player_status>}
	SpawnScriptNow \{Crowd_AllPlayAnim
		Params = {
			Anim = STARPOWER
		}}
	begin
	Wait \{1
		GameFrame}
	if ($game_mode = p2_career || $game_mode = p2_coop)
		drain = ($star_power_drain_rate_coop * 1000.0 * ($current_deltatime / $<player_status>.playline_song_measure_time))
	elseif ($game_mode = Tutorial)
		drain = 0
	else
		drain = ($star_power_drain_rate * 1000.0 * ($current_deltatime / $<player_status>.playline_song_measure_time))
	endif
	Change StructureName = <player_status> star_power_amount = ($<player_status>.star_power_amount - <drain>)
	if ($<player_status>.star_power_amount <= 0)
		Change StructureName = <player_status> star_power_amount = 0
		break
	endif
	repeat
	SpawnScriptNow \{Crowd_AllPlayAnim
		Params = {
			Anim = IDLE
		}}
	if ($<player_status>.controller = $primary_controller)
		Change gStar_Power_Triggered = ($gStar_Power_Triggered + 1)
	endif
	Change StructureName = <player_status> star_power_used = 0
	if ($overlapping_sp = 1)
		Change StructureName = <player_status> star_power_overlap = 0
	endif
	UpdateNixie Player = <Player>
	Wait \{1
		GameFrame}
	LaunchGemEvent Event = star_power_off Player = <Player>
	ExtendCRC star_power_off <player_Text> out = Type
	BroadCastEvent Type = <Type> Data = {player_Text = <player_Text> player_status = <player_status>}
	<do_star> = 0
	return <...>
endscript