custom_menu_fs = {
	Create = create_custom_menu
	Destroy = destroy_custom_menu
	actions = [
		{
			action = go_back
			flow_state = main_menu_fs
			use_last_flow_state
		}
	]
}

script create_custom_menu \{Popup = 0}
	Rot_Angle = 2
	pause_z = 10000

	if ((IsNGC) || (IsPS2))
		Spacing = -65
		<Menu_pos> = (640.0, 200.0)
	else
		Spacing = -45
		<Menu_pos> = (640.0, 190.0)
	endif

	if (<Popup> = 0)
		create_menu_backdrop
	endif

	flame_handlers = [
			{pad_back back_to_retail_ui_flow}
			{pad_up generic_menu_up_or_down_sound Params = {UP}}
			{pad_down generic_menu_up_or_down_sound Params = {DOWN}}
	]

	new_menu {
		scrollid = custom_scrolling_menu
		vmenuid = custom_vmenu
		Menu_pos = <Menu_pos>
		Rot_Angle = <Rot_Angle>
		event_handlers = <flame_handlers>
		Spacing = <Spacing>
		use_backdrop = (1)
	}

	create_pause_menu_frame x_scale = 1.2 y_scale = 1.2 Z = (<pause_z> - 10)

	CreateScreenElement {
		Type = SpriteElement
		PARENT = pause_menu_frame_container
		texture = Dialog_Title_BG
		flip_v
		Dims = (300.0, 224.0)
		Pos = (490.0, 130.0)
		just = [Center Center]
		z_priority = (<pause_z> + 100)
	}

	CreateScreenElement {
		Type = SpriteElement
		PARENT = pause_menu_frame_container
		texture = Dialog_Title_BG
		Dims = (300.0, 224.0)
		Pos = (790.0, 130.0)
		just = [Center Center]
		z_priority = (<pause_z> + 100)
	}

	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = text_a5
		Scale = (0.6, 0.6)
		Pos = (0.0, 47)
		Id = dx_settings_text
		Text = 'DELUXE SETTINGS'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 101)
	}

	text_scale = (0.9, 0.9)
	container_params = {Type = ContainerElement PARENT = custom_vmenu Dims = (0.0, 100.0)}

    CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = toggle_bot_menuitem}}
			{unfocus retail_menu_unfocus Params = {Id = toggle_bot_menuitem}}
			{pad_choose toggle_bot}
		]
	}
  	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = toggle_bot_menuitem
		Text = 'Autoplay: Disabled'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	toggle_bot_setprop

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = select_slomo_menuitem}}
			{unfocus retail_menu_unfocus Params = {Id = select_slomo_menuitem}}
			{pad_choose select_slomo_custom}
		]
	}
	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = select_slomo_menuitem
		Text = 'Song Speed: 1.0'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	select_slomo_setprop_custom

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = debug_func_menuitem}}
			{unfocus retail_menu_unfocus Params = {Id = debug_func_menuitem}}
			{pad_choose toggle_debug}
		]
	}
    CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = debug_func_menuitem
		Text = 'Debug Mode: Off'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	toggle_debug_setprop

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = open_mangig_menuitem}}
			{unfocus retail_menu_unfocus Params = {Id = open_mangig_menuitem}}
			{pad_choose ui_flow_manager_respond_to_action Params = {action = select_manage_gig}}
		]
	}
    CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = open_mangig_menuitem
		Text = 'Manage Gig'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = 0xb44a0b9b}}
			{unfocus retail_menu_unfocus Params = {Id = 0xb44a0b9b}}
			{pad_choose select_dispfps}
		]
	}
	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Id = 0xb44a0b9b
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Text = "Display FPS: Off"
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = (<pause_z>)
		OSFPSPos = <OSFPSPos>
	}
	toggle_dispfps_setprop

	if NOT ((IsNGC) || (IsPS2) || $enable_button_cheats = 0) ; doesnt work on those platforms
		CreateScreenElement {
			<container_params>
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = reload_gh3dx_menuitem}}
				{unfocus retail_menu_unfocus Params = {Id = reload_gh3dx_menuitem}}
				{pad_choose reload_gh3dx}
			]
		}
   	 	CreateScreenElement {
			Type = TextElement
			PARENT = <Id>
			font = fontgrid_title_gh3
			Scale = (0.2, 0.2)
			rgba = [210 130 0 250]
			Id = reload_gh3dx_menuitem
			Text = 'Reload gh3dx.pak'
			just = [Center Top]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba [0 0 0 255]
			z_priority = (<pause_z>)
		}
	endif

    add_user_control_helper \{Text = 'SELECT'
		button = Green
		Z = 100000}
	add_user_control_helper \{Text = 'BACK'
		button = RED
		Z = 100000}
	add_user_control_helper \{Text = 'UP/DOWN'
		button = Strumbar
		Z = 100000}
    LaunchEvent \{ Type = Focus Target = custom_vmenu }
endscript

script destroy_custom_menu 
    if ScreenElementExists \{ Id = custom_scrolling_menu }
        DestroyScreenElement \{ Id = custom_scrolling_menu }
    endif
    clean_up_user_control_helpers
	destroy_pause_menu_frame
	destroy_menu \{menu_id = scrolling_custom_menu}
	destroy_menu \{menu_id = pause_menu_frame_container}
	destroy_menu_backdrop
endscript

script select_slomo_custom 
    ui_menu_select_sfx
    speedfactor = ($current_speedfactor * 10.0)
    speedfactor = (<speedfactor> + 0.5)
    if (<speedfactor> > 20)
        speedfactor = 1
    endif
    if (<speedfactor> < 1)
        speedfactor = 1
    endif
    Change current_speedfactor = (<speedfactor> / 10.0)
    update_slomo_custom
    select_slomo_setprop_custom
endscript

script update_slomo_custom 
    SetSlomo \{ $current_speedfactor }
   	setslomo_song \{ slomo = $current_speedfactor }
    Player = 1
    begin
    FormatText ChecksumName = player_status 'player%i_status' i = <Player>
    Change StructureName = <player_status> check_time_early = ($check_time_early * $current_speedfactor)
    Change StructureName = <player_status> check_time_late = ($check_time_late * $current_speedfactor)
    Player = (<Player> + 1)
    repeat $current_num_players
endscript

script select_slomo_setprop_custom 
    FormatText \{ textname = slomo_text 'Song Speed: %s' s = $current_speedfactor }
    select_slomo_menuitem :SetProps text = <slomo_text>
endscript

script toggle_bot_setprop 
    if ($player1_status.bot_play = 0 && $player2_status.bot_play = 0)
        toggle_bot_menuitem :SetProps text = "Autoplay: Disabled"
    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play = 0)
        toggle_bot_menuitem :SetProps text = "Autoplay: P1"
    elseif ($player1_status.bot_play = 0 && $player2_status.bot_play != 0)
        toggle_bot_menuitem :SetProps text = "Autoplay: P2"
    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play != 0)
        toggle_bot_menuitem :SetProps text = "Autoplay: P1 + P2"
    endif
endscript

script toggle_bot 
    ui_menu_select_sfx
    if ($player1_status.bot_play = 0 && $player2_status.bot_play = 0)
        Change StructureName = player1_status bot_play = 1
        Change StructureName = player2_status bot_play = 0
    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play = 0)
        Change StructureName = player1_status bot_play = 0
        Change StructureName = player2_status bot_play = 1
    elseif ($player1_status.bot_play = 0 && $player2_status.bot_play != 0)
        Change StructureName = player1_status bot_play = 1
        Change StructureName = player2_status bot_play = 1
    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play != 0)
        Change StructureName = player1_status bot_play = 0
        Change StructureName = player2_status bot_play = 0
    endif
    toggle_bot_setprop
endscript

script toggle_debug 
    ui_menu_select_sfx
	if ($enable_button_cheats = 0)
		Change enable_button_cheats = 1
	elseif
		Change enable_button_cheats = 0
	endif
	toggle_debug_setprop
endscript

script toggle_debug_setprop 
    if ($enable_button_cheats = 1)
		debug_func_menuitem :SetProps text = "Debug Mode: On"
	elseif
		debug_func_menuitem :SetProps text = "Debug Mode: Off"
	endif
endscript

script toggle_dispfps_setprop 
	change_dispfps_text
	if (<ondisp_dispfps_text> = 0)
		FormatText TextName = 0x0b076348 "Display FPS: Off"
	else
		FormatText TextName = 0x0b076348 "Display FPS: On"
	endif
	SetScreenElementProps Id = 0xb44a0b9b Text = <0x0b076348>
endscript
0x3b1abe4a = 0

script select_dispfps 
	ui_menu_select_sfx
	change_dispfps_text
	0x34e762be ondisp_dispfps_text = (1 - <ondisp_dispfps_text>)
	enable_dispfps
	toggle_dispfps_setprop
endscript

script 0x4511087e 
	begin
	FormatText TextName = 0x0b076348 "%a FPS" A = ($framerate_value)
	SetScreenElementProps Id = 0xeb440d42 Text = <0x0b076348>
	Wait 0.4 Second
	repeat
endscript

script change_dispfps_text 
	ondisp_dispfps_text = 0
	GetGlobalTags $0xaebf2394 noassert = 1
	return ondisp_dispfps_text = <ondisp_dispfps_text>
endscript

script 0x34e762be 
	0x1e5afd34 $0xaebf2394 Params = {ondisp_dispfps_text = <ondisp_dispfps_text>}
endscript
0xaebf2394 = 0x838c0d91

script enable_dispfps 
	if ((IsNGC) || (IsPS2))
		<OSFPSPos> = (160.0, 35.0)
	else
		<OSFPSPos> = (80.0, 35.0)
	endif

	change_dispfps_text

	if (<ondisp_dispfps_text> = 1)
		if NOT ObjectExists Id = 0x419bc9e7
			SetScreenElementLock Id = root_window OFF
			CreateScreenElement {
				Type = ContainerElement
				PARENT = root_window
				Id = 0x419bc9e7
				Pos = <OSFPSPos>
				just = [LEFT Center]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = 0x419bc9e7
				Id = 0xeb440d42
				Pos = (4.0, 6.0)
				Text = "??? FPS"
				font = fontgrid_title_gh3
				rgba = [255 255 255 255]
				just = [LEFT Center]
				Scale = 0.65
				z_priority = 100
			}
			CreateScreenElement {
				Type = SpriteElement
				PARENT = 0x419bc9e7
				Pos = (0.0, 0.0)
				texture = white2
				rgba = [0 0 0 255]
				just = [LEFT Center]
				Scale = (2.5, 0.5)
				z_priority = 99
			}
			SetScreenElementLock Id = root_window ON
		endif
		if NOT ScriptIsRunning 0x4511087e
			SpawnScriptLater 0x4511087e
		endif
	else
		if ScriptIsRunning 0x4511087e
			KillSpawnedScript Name = 0x4511087e
		endif
		if ObjectExists Id = 0x419bc9e7
			DestroyScreenElement Id = 0x419bc9e7
		endif
	endif
endscript

script 0x1e5afd34 
	SetGlobalTags <...>
endscript