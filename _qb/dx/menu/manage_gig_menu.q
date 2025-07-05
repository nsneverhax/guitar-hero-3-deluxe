manage_gig_locked = 0
manage_gig_editing = VENUE
forced_venue = 0
forced_guitarist = 0
forced_bassist = 0
forced_drummer = 0
forced_vocalist = 0

musician_profile_pool = $Musician_Profiles
musician_profile_poolsize = 0

script create_dx_manage_gig_menu \{Popup = 0}
	disable_pause

	set_musician_profile_pool
	Rot_Angle = 2
	pause_z = 10000

	if (current_screen_mode = standard_screen_mode)
		Spacing = -65
		<Menu_pos> = (640.0, 280.0)
	else
		Spacing = -45
		<Menu_pos> = (640.0, 270.0)
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
		scrollid = mangig_scrolling_menu
		vmenuid = mangig_vmenu
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
		Text = 'MANAGE GIG'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 101)
	}

	text_scale = (0.9, 0.9)
	container_params = {Type = ContainerElement PARENT = mangig_vmenu Dims = (0.0, 100.0)}

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus menu_dx_manage_gig_focus Params = {Id = mg_venue editing = VENUE}}
			{unfocus retail_menu_unfocus Params = {Id = mg_venue}}
			{pad_choose menu_dx_manage_gig_lock_selection}
			{pad_back menu_dx_manage_gig_press_back}
		]
	}
    CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = mg_venue
		Text = "Venue: "
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
	menu_dx_manage_gig_setprop_venue
	
	CreateScreenElement {
		<container_params>
		event_handlers = [
			{Focus menu_dx_manage_gig_focus Params = {Id = mg_guitarist editing = GUITARIST}}
			{unfocus retail_menu_unfocus Params = {Id = mg_guitarist}}
			{pad_choose menu_dx_manage_gig_lock_selection}
			{pad_back menu_dx_manage_gig_press_back}
		]
	}
    CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = mg_guitarist
		Text = "Guitarist: "
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
	menu_dx_manage_gig_setprop_guitarist

    add_user_control_helper \{Text = 'SELECT'
		button = Green
		Z = 100000}
	add_user_control_helper \{Text = 'BACK'
		button = RED
		Z = 100000}
	add_user_control_helper \{Text = 'UP/DOWN'
		button = Strumbar
		Z = 100000}
    LaunchEvent \{ Type = Focus Target = mangig_vmenu }
endscript

script destroy_dx_manage_gig_menu 
    if ScreenElementExists \{ Id = mangig_scrolling_menu }
        DestroyScreenElement \{ Id = mangig_scrolling_menu }
    endif
    clean_up_user_control_helpers
	destroy_pause_menu_frame
	destroy_menu \{menu_id = pause_menu_frame_container}
	destroy_menu_backdrop
endscript

; i dont know why i have to do this dont ask
script set_musician_profile_pool 
	if ((IsNGC) || (IsPS2))
		Change musician_profile_pool = $Musician_Profiles_PSWii
	endif
	cs_get_total_guitarists
	Change musician_profile_poolsize = (<num_guitarists>)
endscript

script menu_dx_manage_gig_move_up_selection 
	generic_menu_up_or_down_sound
	switch ($manage_gig_editing)
		case VENUE
			menu_dx_manage_gig_up_selection_venue
		case GUITARIST
			menu_dx_manage_gig_up_selection_guitarist
		case BASSIST
			menu_dx_manage_gig_up_selection_bassist
		case DRUMMER
			menu_dx_manage_gig_up_selection_drummer
		case VOCALIST
			menu_dx_manage_gig_up_selection_vocalist
	endswitch 
endscript

script menu_dx_manage_gig_move_down_selection 
	generic_menu_up_or_down_sound
	switch ($manage_gig_editing)
		case VENUE
			menu_dx_manage_gig_down_selection_venue
		case GUITARIST
			menu_dx_manage_gig_down_selection_guitarist
		case BASSIST
			menu_dx_manage_gig_down_selection_bassist
		case DRUMMER
			menu_dx_manage_gig_down_selection_drummer
		case VOCALIST
			menu_dx_manage_gig_down_selection_vocalist
	endswitch 
endscript

script menu_dx_manage_gig_up_selection_venue
	selected_venue = $forced_venue

	selected_venue = (<selected_venue> - 1)
	if (<selected_venue> = 9)
		selected_venue = (<selected_venue> - 1)
	endif

	if (<selected_venue> > 11)
        selected_venue = 0
    endif

    if (<selected_venue> < 0)
        selected_venue = 11
    endif

    Change forced_venue = <selected_venue>
    menu_dx_manage_gig_setprop_venue
endscript

script menu_dx_manage_gig_down_selection_venue
	selected_venue = $forced_venue

	selected_venue = (<selected_venue> + 1)
	if (<selected_venue> = 9)
		selected_venue = (<selected_venue> + 1)
	endif

	if (<selected_venue> > 11)
        selected_venue = 0
    endif

    if (<selected_venue> < 0)
        selected_venue = 11
    endif

	Change forced_venue = <selected_venue>
    menu_dx_manage_gig_setprop_venue
endscript

script menu_dx_manage_gig_setprop_venue
	venue_title = 'Unforced'
    if ($forced_venue != 0)
    	venue_index = ($forced_venue - 1)
    	venue_title = ($LevelZones.($LevelZoneArray [<venue_index>]).Title)
    endif
    
	FormatText TextName = current_venue 'Venue: %s' s = <venue_title>
    mg_venue :SetProps text = <current_venue>
endscript

script menu_dx_manage_gig_up_selection_guitarist
	selected_guitarist = $forced_guitarist

	selected_guitarist = (<selected_guitarist> - 1)

	if (<selected_guitarist> > $musician_profile_poolsize)
        selected_guitarist = 0
    endif

    if (<selected_guitarist> < 0)
        selected_guitarist = $musician_profile_poolsize
    endif

    Change forced_guitarist = <selected_guitarist>
    menu_dx_manage_gig_setprop_guitarist
endscript

script menu_dx_manage_gig_down_selection_guitarist
	selected_guitarist = $forced_guitarist

	selected_guitarist = (<selected_guitarist> + 1)

	if (<selected_guitarist> > $musician_profile_poolsize)
        selected_guitarist = 0
    endif

    if (<selected_guitarist> < 0)
        selected_guitarist = $musician_profile_poolsize
    endif

	Change forced_guitarist = <selected_guitarist>
    menu_dx_manage_gig_setprop_guitarist
endscript

script menu_dx_manage_gig_setprop_guitarist
	guitarist_title = 'Unforced'
    if ($forced_guitarist != 0)
    	guitarist_index = ($forced_guitarist - 1)
    	guitarist_title = (($musician_profile_pool [<guitarist_index>]).fullname)
    endif
    
	FormatText TextName = current_guitarist 'Guitarist: %s' s = <guitarist_title>
    mg_guitarist :SetProps text = <current_guitarist>
endscript

script menu_dx_manage_gig_focus 
	retail_menu_focus Id = <Id>
	Change manage_gig_editing = <editing>
endscript

script menu_dx_manage_gig_lock_selection 
	if NOT ($manage_gig_locked)
		SoundEvent \{Event = ui_sfx_select}
	endif
	menu_dx_highlight_item
	GetTags
	LaunchEvent \{Type = unfocus
		Target = mangig_vmenu}
	Wait \{1
		GameFrame}
	LaunchEvent Type = Focus Target = <Id>
	SetScreenElementProps {
		Id = <Id>
		event_handlers = [
			{pad_up menu_dx_manage_gig_move_up_selection}
			{pad_down menu_dx_manage_gig_move_down_selection}
		]
		Replace_Handlers
	}
	Change \{manage_gig_locked = 1}
endscript

script menu_dx_manage_gig_press_back 
	SoundEvent \{Event = Generic_Menu_Back_SFX}
	menu_dx_remove_highlight
	GetTags
	LaunchEvent Type = unfocus Target = <Id>
	Wait \{1
		GameFrame}
	LaunchEvent \{Type = Focus
		Target = mangig_vmenu}
	SetScreenElementProps {
		Id = <Id>
		event_handlers = [
			{pad_up null_script}
			{pad_down null_script}
		]
		Replace_Handlers
	}
	Change \{manage_gig_locked = 0}
endscript
