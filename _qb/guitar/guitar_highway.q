script move_highway_2d 
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

script create_highway_prepass 
endscript
