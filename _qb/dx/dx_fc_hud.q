dont_create_fc_hud = 0
fc_hud_spawned = 0
fc_hud_moved = 0
fc_hud_go_away = 0
fc_hud_initial_pos = (340.0, 490.0)
fc_hud_new_pos = (340.0, 440.0)

script create_highway_prepass 
	if ($fc_hud_spawned = 0)
		dx_create_fc_hud
	endif
endscript

script restart_warning_select_restart \{Player = 1}
	dx_reset_fc_counters
	GH3_SFX_fail_song_stop_sounds
	ui_flow_manager_respond_to_action action = Continue create_params = {Player = <Player>}
endscript

script quit_warning_select_quit \{Player = 1}
	dx_reset_fc_counters
	GH3_SFX_fail_song_stop_sounds
	ui_flow_manager_respond_to_action action = Continue create_params = {Player = <Player>}
endscript

script dx_reset_fc_counters 
	Change dont_create_fc_hud = 0
	Change fc_hud_spawned = 0
	Change fc_hud_moved = 0
	Change fc_hud_go_away = 0
endscript

script dx_create_fc_hud 
	if ($dont_create_fc_hud = 1)
		return
	endif
	if ($fc_hud_spawned = 0)
		CreateScreenElement {
			Type = TextElement
			Id = dx_fc_hud
			PARENT = gem_containerp1
			Text = "FC"
			font = text_a6
			rgba = $deluxe_text_rgba
			Pos = $fc_hud_initial_pos
			Scale = 1.0
			Alpha = 0.0
			Shadow
			shadow_rgba = $deluxe_text_shadow_rgba
			shadow_offs = (2.0, 2.0)
		}
		Change fc_hud_spawned = 1
	endif
endscript

script dx_fc_hud_watchdog 
	if NOT ScreenElementExists Id = dx_fc_hud
		return
	endif
	if ($dont_create_fc_hud = 1)
		return
	endif
	if ($fc_hud_moved = 0)
		;dx_fc_hud :SetProps Alpha = 1.0
		dx_fc_hud :DoMorph {Pos = $fc_hud_new_pos
            Alpha = 1.0
			Time = 0.2
			Motion = linear}
		Change fc_hud_moved = 1
	endif
	if ($fc_hud_go_away = 1)
		dx_fc_hud :DoMorph {Pos = $fc_hud_initial_pos
            Alpha = 0.0
			Time = 0.2
			Motion = linear}
		;dx_fc_hud :SetProps Alpha = 0.0
		Change fc_hud_go_away = 0
	endif
endscript