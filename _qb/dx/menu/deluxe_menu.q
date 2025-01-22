set_speeds_locked = 0

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
	disable_pause

	Rot_Angle = 2
	pause_z = 10000

	if ((IsNGC) || (IsPS2))
		Spacing = -65
		<Menu_pos> = (640.0, 220.0)
	else
		Spacing = -45
		<Menu_pos> = (640.0, 210.0)
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
			{Focus retail_menu_focus Params = {Id = modifiers_menuitem}}
			{unfocus retail_menu_unfocus Params = {Id = modifiers_menuitem}}
			{pad_choose ui_flow_manager_respond_to_action Params = {action = select_modifiers}}
		]
	}
  	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = modifiers_menuitem
		Text = 'MODIFIERS'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))

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
		Text = 'MANAGE GIG'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus menu_dx_set_speeds_focus Params = {Id = song_speed_menuitem}}
			{unfocus retail_menu_unfocus Params = {Id = song_speed_menuitem}}
			{pad_choose menu_dx_set_speeds_lock_selection}
			{pad_back menu_dx_set_speeds_press_back}
		]
	}
    CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = song_speed_menuitem
		Text = "Song Speed: "
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
	menu_dx_set_speeds_song_speed_setprop

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
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
	toggle_debug_setprop

	if NOT ((IsNGC) || (IsPS2) || $enable_button_cheats = 0)
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
		GetScreenElementDims Id = <Id>
		fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
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
	destroy_menu \{menu_id = pause_menu_frame_container}
	destroy_menu_backdrop
endscript

script menu_dx_set_song_speed
	generic_menu_up_or_down_sound

	speedfactor = ($current_speedfactor * 10.0)

	switch (<direction>)
    	case UP
    		speedfactor = (<speedfactor> + 0.5)
    	case DOWN 
    		speedfactor = (<speedfactor> - 0.5)
    endswitch

	if (<speedfactor> > 20)
     	speedfactor = 20
   	endif

    if (<speedfactor> < 1)
        speedfactor = 1
    endif

    Change current_speedfactor = (<speedfactor> / 10.0)
    update_slomo_custom
 	menu_dx_set_speeds_song_speed_setprop
endscript

script menu_dx_set_speeds_song_speed_setprop 
	speedfactor = $current_speedfactor
	speedfactor = (<speedfactor> * 100)
	CastToInteger speedfactor
    FormatText TextName = songs_text 'Song Speed: %s\%' s = <speedfactor>
    song_speed_menuitem :SetProps text = <songs_text>
endscript

script menu_dx_set_speeds_focus 
	retail_menu_focus Id = <Id>
endscript

script menu_dx_set_speeds_lock_selection 
	if NOT ($set_speeds_locked)
		SoundEvent \{Event = ui_sfx_select}
	endif
	menu_dx_highlight_item
	GetTags
	LaunchEvent \{Type = unfocus
		Target = custom_vmenu}
	Wait \{1
		GameFrame}
	LaunchEvent Type = Focus Target = <Id>
	SetScreenElementProps {
		Id = <Id>
		event_handlers = [
			{pad_up menu_dx_set_song_speed Params = {direction = UP}}
			{pad_down menu_dx_set_song_speed Params = {direction = DOWN}}
		]
		Replace_Handlers
	}
	Change \{set_speeds_locked = 1}
endscript

script menu_dx_set_speeds_press_back 
	SoundEvent \{Event = Generic_Menu_Back_SFX}
	menu_dx_remove_highlight
	GetTags
	LaunchEvent Type = unfocus Target = <Id>
	Wait \{1
		GameFrame}
	LaunchEvent \{Type = Focus
		Target = custom_vmenu}
	SetScreenElementProps {
		Id = <Id>
		event_handlers = [
			{pad_up null_script}
			{pad_down null_script}
		]
		Replace_Handlers
	}
	update_song_speed
	Change \{set_speeds_locked = 0}
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

script menu_dx_highlight_item
	GetTags
	set_focus_color rgba = [0 255 255 250] ; i would rather not do this but none of the other ways i tried worked
endscript

script menu_dx_remove_highlight 
	GetTags
	set_focus_color rgba = [210 210 210 250] ; same goes
endscript
