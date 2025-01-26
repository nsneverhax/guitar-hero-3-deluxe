highway_normal_original = [
	255
	255
	255
	255
]
highway_starpower_original = [
	64
	255
	255
	255
]
highway_black = [
	0
	0
	0
	255
]
highway_transparent = [
	0
	0
	0
	0
]

modifiers_editing = 0

selected_modifier_index = 0
selected_modifier_id = BLACK_HIGHWAY
mods_max_entries = 0

mods_menu_index = 0

modifier_options = [
	{
		Name = "Black Highway"
		Id = BLACK_HIGHWAY
		Description = "Your highway will be all black. This is very useful for note readability."
	}
	{
		Name = "Transparent Highway"
		Id = TRANSPARENT_HIGHWAY
		Description = "Your highway will be Transparent. See the Backgrounds with less of a distracting highway!"
	}
	{
		Name = "Black Background"
		Id = BLACK_BACKGROUND
		Description = "Nothing can distract me now!"
	}
	{
		Name = "Song Title Always On"
		Id = SONG_TITLE
		Description = "Now you won't have to answer to \'Hey what song is this?\'"
	}
	{
		Name = "No Highway Shake"
		Id = HIGHWAY_SHAKE
		Description = "Your highway no longer shakes when breaking combo."
	}
	{
		Name = "Show Early Timing"
		Id = EARLY_TIMING
		Description = "Guitar Hero 3 only destroys gems as soon as they cross the strikeline. No more!"
	}
	{
		Name = "No Flames"
		Id = NO_FLAMES
		Description = "Flames no longer appear when hitting notes."
	}
	{
		Name = "Select In Practice"
		Id = SELECT_RESTART
		Description = "You can now press select to restart in Practice mode."
	}
	{
		Name = "Autoplay"
		Id = AUTOPLAY
		Description = "The usual"
	}
	{
		Name = "Debug Mode"
		Id = DEBUG_MODE
		Description = "This gives you access to the debug menu and one dev feature in the DX settings."
	}
	{
		Name = "Enable Viewer"
		Id = ENABLE_VIEWER
		Description = "This enables the menu that appears when pressing select. It's a thing that exists. This cannot be disabled until the game is closed."
	}
	{
		Name = "Awesomeness Detection"
		Id = AWESOMENESS
		Description = "Let NeverHax know that you are awesome!"
	}
]
script create_dx_mods_menu \{Popup = 0}
	disable_pause

	GetArraySize ($modifier_options)
	Change mods_max_entries = <array_Size>

	Change modifiers_editing = 0

	Change selected_modifier_index = 0
	Change selected_modifier_id = BLACK_HIGHWAY

	Change mods_menu_index = 0

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

	event_handlers = [
			{pad_back back_to_retail_ui_flow}
			{pad_up menu_dx_mods_scroll_up}
			{pad_down menu_dx_mods_scroll_down}
	]

	new_menu {
		scrollid = mods_scrolling_menu
		vmenuid = mods_vmenu
		Menu_pos = <Menu_pos>
		Rot_Angle = <Rot_Angle>
		event_handlers = <event_handlers>
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
		Text = 'MODIFIERS'
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 101)
	}

	text_scale = (0.9, 0.9)
	container_params = {Type = ContainerElement PARENT = mods_vmenu Dims = (0.0, 100.0)}

	I = 0
	begin
	FormatText ChecksumName = text_id 'mods_text_%d' D = <I>

	CreateScreenElement {
		<container_params>
		event_handlers = [
			{pad_choose menu_dx_mods_select}
		]
	}

	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		font = fontgrid_title_gh3
		Scale = <text_scale>
		rgba = [210 130 0 250]
		Id = <text_id>
		Text = ($modifier_options [<I>].Name)
		just = [Center Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z>)
	}
	GetScreenElementDims Id = <Id>
	fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
	menu_dx_mods_setprop Element_Id = <text_id> Index = <I>

	<I> = (<I> + 1)
	repeat 4

	SetScreenElementProps Id = mods_text_0 rgba = [210 210 210 250]

    add_user_control_helper \{Text = 'SELECT'
		button = Green
		Z = 100000}
	add_user_control_helper \{Text = 'BACK'
		button = RED
		Z = 100000}
	add_user_control_helper \{Text = 'UP/DOWN'
		button = Strumbar
		Z = 100000}
    LaunchEvent \{ Type = Focus Target = mods_vmenu }
endscript

script destroy_dx_mods_menu 
    if ScreenElementExists \{ Id = mods_scrolling_menu }
        DestroyScreenElement \{ Id = mods_scrolling_menu }
    endif
    clean_up_user_control_helpers
	destroy_pause_menu_frame
	destroy_menu \{menu_id = pause_menu_frame_container}
	destroy_menu_backdrop
endscript

script menu_dx_mods_scroll_up
	make_sound = 1
	if ($mods_menu_index > 0)
		FormatText ChecksumName = mods_text_id 'mods_text_%d' D = $mods_menu_index
		SetScreenElementProps Id = <mods_text_id> rgba = [210 130 0 250]

		Change mods_menu_index = ($mods_menu_index - 1)
		Change selected_modifier_index = ($selected_modifier_index - 1)

		FormatText ChecksumName = mods_text_id 'mods_text_%d' D = $mods_menu_index
		SetScreenElementProps Id = <mods_text_id> rgba = [210 210 210 250]
	else
		if ($selected_modifier_index > 0)
			Change selected_modifier_index = ($selected_modifier_index -1)
			I = 0
			begin
			FormatText ChecksumName = mods_text_id 'mods_text_%d' D = (<I>)
			menu_dx_mods_setprop Element_Id = <mods_text_id> Index = ($selected_modifier_index + <I>)
			<I> = (<I> + 1)
			repeat 4
		else
			<make_sound> = 0
		endif
	endif
	if (<make_sound> = 1)
		generic_menu_up_or_down_sound \{DOWN}
	endif
endscript

script menu_dx_mods_scroll_down
	make_sound = 1
	if ($mods_menu_index < 3)
		FormatText ChecksumName = mods_text_id 'mods_text_%d' D = $mods_menu_index
		SetScreenElementProps Id = <mods_text_id> rgba = [210 130 0 250]

		Change mods_menu_index = ($mods_menu_index + 1)
		Change selected_modifier_index = ($selected_modifier_index + 1)

		FormatText ChecksumName = mods_text_id 'mods_text_%d' D = $mods_menu_index
		SetScreenElementProps Id = <mods_text_id> rgba = [210 210 210 250]
	else
		if ($selected_modifier_index < ($mods_max_entries - 1))
			Change selected_modifier_index = ($selected_modifier_index + 1)
			I = 0
			begin
			FormatText ChecksumName = mods_text_id 'mods_text_%d' D = (3 - <I>)
			menu_dx_mods_setprop Element_Id = <mods_text_id> Index = ($selected_modifier_index - <I>)
			<I> = (<I> + 1)
			repeat 4
		else
			<make_sound> = 0
		endif
	endif
	if (<make_sound> = 1)
		generic_menu_up_or_down_sound \{DOWN}
	endif
endscript

script menu_dx_mods_select ; spaaaaghetti
	Change dx_settings_changed = 1
	GetGlobalTags \{user_options}
	switch (($modifier_options [$selected_modifier_index].Id))
		case BLACK_HIGHWAY
			if (<black_highway> = 0)
				if (<transparent_highway> = 1)
					SetGlobalTags user_options Params = {transparent_highway = 0}
				endif
			 	SetGlobalTags user_options Params = {black_highway = 1}
			 	Change highway_normal = $highway_black
				Change highway_starpower = $highway_black
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {black_highway = 0}
				Change highway_normal = $highway_normal_original
				Change highway_starpower = $highway_starpower_original
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case TRANSPARENT_HIGHWAY
			if (<transparent_highway> = 0)
				if (<black_highway> = 1)
					SetGlobalTags user_options Params = {black_highway = 0}
				endif
			 	SetGlobalTags user_options Params = {transparent_highway = 1}
			 	Change highway_normal = $highway_transparent
				Change highway_starpower = $highway_transparent
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {transparent_highway = 0}
				Change highway_normal = $highway_normal_original
				Change highway_starpower = $highway_starpower_original
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case BLACK_BACKGROUND
			if (<black_background> = 0)
			 	SetGlobalTags user_options Params = {black_background = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {black_background = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case SONG_TITLE
			if (<song_title> = 0)
			 	SetGlobalTags user_options Params = {song_title = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {song_title = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case HIGHWAY_SHAKE
			if (<highway_shake> = 0)
			 	SetGlobalTags user_options Params = {highway_shake = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {highway_shake = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case EARLY_TIMING
			if (<early_timing> = 0)	
			 	SetGlobalTags user_options Params = {early_timing = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {early_timing = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case NO_FLAMES
			if (<no_flames> = 0)
			 	SetGlobalTags user_options Params = {no_flames = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {no_flames = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case SELECT_RESTART
			if (<select_restart> = 0)
			 	SetGlobalTags user_options Params = {select_restart = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {select_restart = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case AUTOPLAY
			if ($player1_status.bot_play = 0 && $player2_status.bot_play = 0)
     		    Change StructureName = player1_status bot_play = 1
      			Change StructureName = player2_status bot_play = 0
      			SoundEvent \{Event = CheckBox_Check_SFX}
    		elseif ($player1_status.bot_play != 0 && $player2_status.bot_play = 0)
   		    	Change StructureName = player1_status bot_play = 0
  		    	Change StructureName = player2_status bot_play = 1
  		    	SoundEvent \{Event = CheckBox_Check_SFX}
 		    elseif ($player1_status.bot_play = 0 && $player2_status.bot_play != 0)
		        Change StructureName = player1_status bot_play = 1
		        Change StructureName = player2_status bot_play = 1
		        SoundEvent \{Event = CheckBox_Check_SFX}
		    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play != 0)
		        Change StructureName = player1_status bot_play = 0
		        Change StructureName = player2_status bot_play = 0
		        SoundEvent \{Event = CheckBox_SFX}
		    endif
    	case DEBUG_MODE
    		if ($enable_button_cheats = 0)
				Change enable_button_cheats = 1
				SoundEvent \{Event = CheckBox_Check_SFX}
			elseif
				Change enable_button_cheats = 0
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case ENABLE_VIEWER
			ui_menu_select_sfx
			LaunchViewer
			Change \{select_shift = 1}
		case AWESOMENESS
			if (<awesomeness> = 0)
			 	SetGlobalTags user_options Params = {awesomeness = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {awesomeness = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
	endswitch
	; jank way of resetting black/transparent highway text if the other is toggled on
	if (($mods_menu_index = 0) && (<black_highway> = 0))
		FormatText ChecksumName = mods_text_id 'mods_text_%d' D = (1)
		menu_dx_mods_setprop Element_Id = <mods_text_id> Index = (1)
	elseif (($mods_menu_index = 1) && (<transparent_highway> = 0))
		FormatText ChecksumName = mods_text_id 'mods_text_%d' D = (0)
		menu_dx_mods_setprop Element_Id = <mods_text_id> Index = (0)
	endif

	FormatText ChecksumName = mods_text_id 'mods_text_%d' D = ($mods_menu_index)
	menu_dx_mods_setprop Element_Id = <mods_text_id> Index = ($selected_modifier_index)
endscript

script menu_dx_mods_setprop ; yeah this sucks my other approach didnt work
	GetGlobalTags \{user_options}
	mod_id = ($modifier_options [<Index>].Id)
	switch (<mod_id>)
		case BLACK_HIGHWAY
			if (<black_highway> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case TRANSPARENT_HIGHWAY
			if (<transparent_highway> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case BLACK_BACKGROUND
			if (<black_background> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case SONG_TITLE
			if (<song_title> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case HIGHWAY_SHAKE
			if (<highway_shake> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case EARLY_TIMING
			if (<early_timing> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case NO_FLAMES
			if (<no_flames> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case SELECT_RESTART
			if (<select_restart> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case AUTOPLAY
			if ($player1_status.bot_play = 0 && $player2_status.bot_play = 0)
				<Element_Id> :SetProps text = "Autoplay: Off"
		    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play = 0)
 		        <Element_Id> :SetProps text = "Autoplay: P1"
		    elseif ($player1_status.bot_play = 0 && $player2_status.bot_play != 0)
 		        <Element_Id> :SetProps text = "Autoplay: P2"
 		    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play != 0)
 		    	<Element_Id> :SetProps text = "Autoplay: P1 + P2"
    		endif
    	case DEBUG_MODE
    		if ($enable_button_cheats = 1)
				<Element_Id> :SetProps text = "Debug Mode: On"
			elseif
				<Element_Id> :SetProps text = "Debug Mode: Off"
			endif
		case ENABLE_VIEWER
			<Element_Id> :SetProps text = ($modifier_options [<Index>].Name)
		case AWESOMENESS
			if (<awesomeness> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
	endswitch
endscript

script menu_dx_mods_focus 
	retail_menu_focus Id = <Id>
	Change modifiers_editing = <editing>
endscript

script menu_dx_mods_lock_selection 
	if NOT ($modifiers_editing)
		SoundEvent \{Event = ui_sfx_select}
	endif
	menu_dx_highlight_item
	GetTags
	LaunchEvent \{Type = unfocus
		Target = mods_vmenu}
	Wait \{1
		GameFrame}
	LaunchEvent Type = Focus Target = <Id>
	SetScreenElementProps {
		Id = <Id>
		event_handlers = [
			{pad_up menu_dx_mods_move_up_selection}
			{pad_down menu_dx_mods_move_down_selection}
		]
		Replace_Handlers
	}
	Change \{modifiers_editing = 1}
endscript

script menu_dx_mods_press_back 
	SoundEvent \{Event = Generic_Menu_Back_SFX}
	menu_dx_remove_highlight
	GetTags
	LaunchEvent Type = unfocus Target = <Id>
	Wait \{1
		GameFrame}
	LaunchEvent \{Type = Focus
		Target = mods_vmenu}
	SetScreenElementProps {
		Id = <Id>
		event_handlers = [
			{pad_up null_script}
			{pad_down null_script}
		]
		Replace_Handlers
	}
	Change \{modifiers_editing = 0}
endscript