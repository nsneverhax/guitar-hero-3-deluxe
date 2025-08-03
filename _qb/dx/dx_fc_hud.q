dont_create_fc_hud = 0
fc_hud_spawned = 0
fc_hud_moved = 0
fc_hud_go_away = 0
fc_glowburst_anim_started = 0
fc_hud_rgba = [240 191 116 255]
fc_hud_shadow_rgba = [204 153 102 191]
fc_hud_glowburst_rgba = [246 188 102 255]
fc_hud_glowburst_rgba1 = [250 192 110 255]
fc_hud_glowburst_rgba2 = [252 196 115 255]
fc_hud_glowburst_rgba3 = [255 200 120 255]
fc_hud_glowburst_rgba4 = [255 204 125 255]
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

script song_ended_menu_select_new_song 
    dx_reset_fc_counters
	if GotParam \{Player}
		ui_flow_manager_respond_to_action action = select_new_song create_params = {Player = <Player>}
	else
		ui_flow_manager_respond_to_action \{action = select_new_song}
	endif
endscript

script practice_warning_menu_select_practice 
	dx_reset_fc_counters
	get_song_struct Song = ($current_song)
	if StructureContains Structure = <song_struct> boss
		player_device = ($primary_controller)
		if IsGuitarController controller = <player_device>
			ui_flow_manager_respond_to_action \{action = continue_tutorial}
		endif
	else
		ui_flow_manager_respond_to_action \{action = Continue}
	endif
endscript

script dx_reset_fc_counters 
	Change dont_create_fc_hud = 0
	Change fc_hud_spawned = 0
	Change fc_hud_moved = 0
	Change fc_hud_go_away = 0
	Change fc_glowburst_anim_started = 0
	if ScreenElementExists Id = dx_fc_hud
		DestroyScreenElement Id = dx_fc_hud
	endif
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
			rgba = $fc_hud_rgba
			Pos = $fc_hud_initial_pos
			Scale = 1.0
			Alpha = 0.0
			Shadow
			shadow_rgba = $fc_hud_shadow_rgba
			shadow_offs = (2.0, 2.0)
            z_priority = 2
		}
	    CreateScreenElement {
		    Type = SpriteElement
		    Id = dx_fc_hud_glowburst
		    PARENT = dx_fc_hud
		    texture = Char_Select_Hilite1
		    Pos = (30.0, 20.0)
		    rgba = $fc_hud_glowburst_rgba
		    Scale = 1.0
		    Alpha = 0.0
		    z_priority = 1
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
		Change fc_hud_go_away = 0
	endif
endscript

script animate_dx_fc_glowburst 
	if NOT ScreenElementExists Id = dx_fc_hud_glowburst
		return
	endif
    begin
    dx_fc_hud_glowburst :DoMorph Alpha = 0.2 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba1
    dx_fc_hud_glowburst :DoMorph Alpha = 0.4 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba2
    dx_fc_hud_glowburst :DoMorph Alpha = 0.6 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba3
    dx_fc_hud_glowburst :DoMorph Alpha = 0.8 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba4
    dx_fc_hud_glowburst :DoMorph Alpha = 0.8 Time = 0.3 Motion = linear
    dx_fc_hud_glowburst :DoMorph Alpha = 0.6 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba3
    dx_fc_hud_glowburst :DoMorph Alpha = 0.4 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba2
    dx_fc_hud_glowburst :DoMorph Alpha = 0.2 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba1 
    dx_fc_hud_glowburst :DoMorph Alpha = 0.0 Time = 0.2 Motion = linear rgba = $fc_hud_glowburst_rgba
    repeat
endscript