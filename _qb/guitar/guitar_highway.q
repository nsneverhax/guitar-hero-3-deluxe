script move_highway_2d 
	; yeah im putting that there fight me about it bitch
    Change StructureName = player1_status double_notes = $double_notes_p1
   	Change StructureName = player2_status double_notes = $double_notes_p2

	if ((IsNGC) || (IsPS2)) ; breaks on old hardware, not needed anyway
		Change \{start_2d_move = 0}
		begin
		if ($start_2d_move = 1)
			break
		endif
		WaitOneGameFrame
		repeat
		highway_start_y = 720
		pos_start_orig = 0
		pos_add = -720
		pos_sub = 1.0
		pos_sub_add = -0.00044
		begin
		<Pos> = (((<Container_pos>.(1.0, 0.0)) * (1.0, 0.0)) + (<highway_start_y> * (0.0, 1.0)))
		SetScreenElementProps Id = <container_id> Pos = <Pos>
		GetDeltaTime \{ignore_slomo}
		<highway_start_y> = (<highway_start_y> + (<pos_add> * <delta_time>))
		<pos_add> = (<pos_add> * <pos_sub>)
		<pos_sub> = (<pos_sub> + <pos_sub_add>)
		if (<highway_start_y> <= <pos_start_orig>)
			<Pos> = (((<Container_pos>.(1.0, 0.0)) * (1.0, 0.0)) + (<pos_start_orig> * (0.0, 1.0)))
			SetScreenElementProps Id = <container_id> Pos = <Pos>
			break
		endif
		WaitOneGameFrame
		repeat
	else
		Change \{start_2d_move = 0}
		begin
		if ($start_2d_move = 1)
			break
		endif
		Wait \{1
			GameFrame}
		repeat
		GetDeltaTime \{ignore_slomo}
		interval = (1.0 / <delta_time> / $current_speedfactor)
		Clamp <interval> Min = 60 MAX = 144
		pos_start_orig = 0
		GetSongTimeMS
		movetime = ($current_intro.highway_move_time / 2200.0)
		if (<movetime> < 0.001)
			SetScreenElementProps Id = <container_id> Pos = (((<Container_pos>.(1.0, 0.0)) * (1.0, 0.0)) + (<pos_start_orig> * (0.0, 1.0)))
			return
		endif
		i1000 = (1000.0 / <clamped>)
		generate_move_table interval = <clamped> pos_start_orig = <pos_start_orig>
		GetArraySize \{moveTable}
		start_time = (<Time> - (400.0 * <movetime>))
		last_time = -1
		begin
		GetSongTimeMS
		Time2 = (((<Time> - <start_time>) / <i1000>) / <movetime>)
		CastToInteger \{Time2}
		if NOT (<last_time> = <Time2>)
			Y = (<moveTable> [<Time2>] / 1000.0)
			SetScreenElementProps Id = <container_id> Pos = (((<Container_pos>.(1.0, 0.0)) * (1.0, 0.0)) + (<Y> * (0.0, 1.0)))
			last_time = <Time2>
		endif
		if (<Y> <= <pos_start_orig> || <Time2> > <array_Size>)
			SetScreenElementProps Id = <container_id> Pos = (((<Container_pos>.(1.0, 0.0)) * (1.0, 0.0)) + (<pos_start_orig> * (0.0, 1.0)))
			break
		endif
		Wait \{1
			GameFrame}
		repeat
		endif
	endif
endscript

script highway_pulse_multiplier_loss \{player_Text = 'p1'
		Multiplier = 1}
		
	GetGlobalTags \{user_options}
	if (<highway_shake> = 1)
		return
	endif

	if ($game_mode = p2_battle || $boss_battle = 1)
		return
	endif
	Time = 0.1
	switch <Multiplier>
		case 1
		push_pos = (0.0, 3.0)
		case 2
		push_pos = (0.0, 4.0)
		case 3
		push_pos = (0.0, 10.0)
		case 4
		push_pos = (0.0, 15.0)
		Time = 0.11
		default
		push_pos = (0.0, 3.0)
	endswitch
	if (($game_mode = p2_faceoff) || ($game_mode = p2_pro_faceoff) || ($game_mode = p2_career) || ($game_mode = p2_coop))
		<push_pos> = (<push_pos> * 0.6)
	endif
	if (<player_Text> = 'p1')
		highway_pulse = $highway_pulse_p1
	else
		highway_pulse = $highway_pulse_p2
	endif
	if (<highway_pulse> = 0)
		Change \{highway_pulse = 1}
		FormatText ChecksumName = container_id 'gem_container%p' P = <player_Text> AddToStringLookup = TRUE
		GetScreenElementPosition Id = <container_id>
		original_position = <ScreenELementPos>
		GetRandomValue \{Name = random_x
			A = -7
			B = 7
			Integer}
		DoScreenElementMorph {Id = <container_id> Pos = (<original_position> + <push_pos> + ((1.0, 0.0) * <random_x>)) just = [Center Bottom] Time = <Time>}
		Wait <Time> Seconds
		GetRandomValue \{Name = random_x
			A = -7
			B = 7
			Integer}
		DoScreenElementMorph {Id = <container_id> Pos = (<original_position> - (<push_pos> * 0.7) + ((1.0, 0.0) * <random_x>)) just = [Center Bottom] Time = <Time>}
		Wait <Time> Seconds
		GetRandomValue \{Name = random_x
			A = -5
			B = 5
			Integer}
		DoScreenElementMorph {Id = <container_id> Pos = (<original_position> + (<push_pos> * 0.4) + ((1.0, 0.0) * <random_x>)) just = [Center Bottom] Time = <Time>}
		Wait <Time> Seconds
		GetRandomValue \{Name = random_x
			A = -5
			B = 5
			Integer}
		DoScreenElementMorph {Id = <container_id> Pos = (<original_position> - (<push_pos> * 0.3) + ((1.0, 0.0) * <random_x>)) just = [Center Bottom] Time = <Time>}
		Wait <Time> Seconds
		GetRandomValue \{Name = random_x
			A = -3
			B = 3
			Integer}
		DoScreenElementMorph {Id = <container_id> Pos = (<original_position> + (<push_pos> * 0.2) + ((1.0, 0.0) * <random_x>)) just = [Center Bottom] Time = <Time>}
		Wait <Time> Seconds
		DoScreenElementMorph {Id = <container_id> Pos = <original_position> just = [Center Bottom] Time = <Time>}
	endif
	Change \{highway_pulse = 0}
endscript
