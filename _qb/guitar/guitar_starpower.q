script Do_StarPower_StageFX 
	GetGlobalTags \{user_options}
	if (<black_background> = 1)
		return
	endif
	switch (<player_status>.character_id)
		case CASEY
		SpawnScriptLater Do_StarPower_ShotgunFX Id = <scriptID> Params = {<...>}
		case JOHNNY
		SpawnScriptLater Do_StarPower_FlameThrowerFX Id = <scriptID> Params = {<...>}
		case JUDY
		SpawnScriptLater Do_StarPower_HeartsFX Id = <scriptID> Params = {<...>}
		case LARS
		case RIPPER
		case SATAN
		SpawnScriptLater Do_StarPower_BatFX Id = <scriptID> Params = {<...>}
		case MIDORI
		SpawnScriptLater Do_StarPower_ButterfliesFX Id = <scriptID> Params = {<...>}
		case XAVIER
		SpawnScriptLater Do_StarPower_PeaceFX Id = <scriptID> Params = {<...>}
		default
		SpawnScriptLater Do_StarPower_TeslaFX Id = <scriptID> Params = {<...>}
	endswitch
endscript
script proto_show_star_power_ready 
	if ($<player_status>.star_power_used = 1 ||
			$is_attract_mode = 1)
		return
	endif
	SoundEvent Event = Star_Power_Ready_SFX
	SpawnScriptNow rock_meter_star_power_on Params = {player_status = <player_status>}
	ExtendCRC star_power_ready_text ($<player_status>.Text) out = Id
	if (($game_mode = p2_faceoff) || ($game_mode = p2_pro_faceoff) || ($game_mode = p2_coop) || ($game_mode = p2_career))
		if ($<player_status>.Player = 1)
			original_pos = (($hud_screen_elements [0].Pos) - (225.0, -70.0))
		else
			original_pos = (($hud_screen_elements [0].Pos) + (225.0, 70.0))
		endif
		base_scale = 0.8
	else
		original_pos = ($hud_screen_elements [0].Pos)
		base_scale = 1.0
	endif
	DoScreenElementMorph {
		Id = <Id>
		Pos = <original_pos>
		Scale = 0
		Alpha = 1
	}
	DoScreenElementMorph Id = <Id> Scale = <base_scale> Time = 0.2
	Wait 0.2 Seconds
	rotation = 4
	begin
	<rotation> = (<rotation> * -1)
	DoScreenElementMorph {
		Id = <Id>
		Rot_Angle = <rotation>
		Time = 0.1
	}
	Wait 0.13 Seconds
	repeat 8
	DoScreenElementMorph Id = <Id> Rot_Angle = 0
	DoScreenElementMorph {
		Id = <Id>
		Pos = (<original_pos> - (0.0, 400.0))
		Scale = (<base_scale> * 0.5)
		Time = 0.35000002
	}
endscript
script nx_show_star_power_ready 
	if ($Cheat_PerformanceMode = 1)
		return
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		<player_status> = player1_status
	endif
	SoundEvent \{Event = Star_Power_Ready_SFX}
	SpawnScriptNow rock_meter_star_power_on Params = {player_status = <player_status>}
	FormatText ChecksumName = player_container 'HUD_Note_Streak_Combo%d' D = ($<player_status>.Player)
	begin
	if NOT ScreenElementExists Id = <player_container>
		break
	endif
	Wait \{1
		GameFrame}
	repeat
	if ($<player_status>.Player = 1)
		if ($star_power_ready_on_p1 = 1)
			return
		else
			Change \{star_power_ready_on_p1 = 1}
		endif
	else
		if ($star_power_ready_on_p2 = 1)
			return
		else
			Change \{star_power_ready_on_p2 = 1}
		endif
	endif
	if ($<player_status>.star_power_used = 1)
		return
	endif
	ExtendCRC star_power_ready_text ($<player_status>.Text) out = Id
	if (($game_mode = p2_faceoff) || ($game_mode = p2_pro_faceoff))
		if ($<player_status>.Player = 1)
			original_pos = (($hud_screen_elements [0].Pos) - (225.0, 50.0))
		else
			original_pos = (($hud_screen_elements [0].Pos) + (225.0, -50.0))
		endif
		base_scale = 0.8
		scale_big_mult = 1.2
	else
		if ($game_mode = p2_career || $game_mode = p2_coop)
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 60.0))
		else
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 20.0))
		endif
		base_scale = 1.2
		scale_big_mult = 1.5
	endif
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = <original_pos> Scale = 4 rgba = [190 225 255 250] Alpha = 0 Rot_Angle = 3
	endif
	ExtendCRC hud_destroygroup_window ($<player_status>.Text) out = hud_destroygroup
	SpawnScriptNow hud_lightning_alert Params = {Player = ($<player_status>.Player) alert_id = <Id> player_container = <hud_destroygroup>}
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = <original_pos> Scale = <base_scale> Alpha = 1 Time = 0.3 Rot_Angle = -3 Motion = ease_in
	endif
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = <original_pos> Scale = (<base_scale> * <scale_big_mult>) Time = 0.3 Rot_Angle = 4 Motion = ease_out
	endif
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = <original_pos> Scale = <base_scale> Time = 0.3 Rot_Angle = -5 rgba = [145 215 235 250] Motion = ease_in
	endif
	rotation = 10
	begin
	<rotation> = (<rotation> * -0.7)
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = <original_pos> Rot_Angle = <rotation> Alpha = 1 Time = 0.08 Motion = ease_out
	endif
	repeat 12
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = <original_pos> Rot_Angle = 0 Motion = ease_out
	endif
	if ScreenElementExists Id = <Id>
		<Id> :DoMorph Pos = (<original_pos> - (0.0, 230.0)) Scale = (<base_scale> * 0.5) Alpha = 0 Time = 0.3 Motion = ease_in
	endif
	if ($<player_status>.Player = 1)
		Change \{star_power_ready_on_p1 = 0}
	else
		Change \{star_power_ready_on_p2 = 0}
	endif
endscript
script show_star_power_ready 
	if ($Cheat_PerformanceMode = 1)
		return
	endif
	GetGlobalTags \{user_options}
	if (<proto_sp> = 1)
		proto_show_star_power_ready
	else
		nx_show_star_power_ready
	endif
endif
