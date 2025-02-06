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

; some stuff for newgen
dx_large_gem_scale = 1.5
gem_start_scale1_normal = 0.25
gem_end_scale1_normal = 0.8
gem_start_scale2_normal = 0.27
gem_end_scale2_normal = 0.8
whammy_top_width1_normal = 10.0
whammy_top_width2_normal = 9.2

modifiers_editing = 0

selected_modifier_index = 0
selected_modifier_id = BLACK_HIGHWAY
mods_max_entries = 0

mods_menu_index = 0

;dont save these options
firework_gems = 0
overlapping_sp = 0

scroller_rgba = [210 130 0 250]

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
		Name = "Large Gems"
		Id = LARGEGEMS
		Description = "Large gems but you don't have to use a PS2/Wii."
	}
	{
		Name = "Firework Gems"
		Id = FIREWORK_GEMS
		Description = "Ooooooooooooh. Ahhhhhhhhhhhh."
	}
	{
		Name = "Flames"
		Id = NO_FLAMES
		Description = "Flames no longer appear when hitting notes."
	}
	{
		Name = "Whammy Particles"
		Id = NO_WHAMMY_PARTICLES
		Description = "Whammy Particles no longer appear when hitting sustains."
	}
	{
		Name = "Highway Shake"
		Id = HIGHWAY_SHAKE
		Description = "Your highway no longer shakes when breaking combo."
	}
	{
		Name = "Whammy Pitch Shifting"
		Id = NO_WHAMMY_PITCH_SHIFT
		Description = "Whammy no longer changes the pitch of the song."
	}
	{
		Name = "Miss SFX"
		Id = NO_MISS_SFX
		Description = "Disables miss sound effects"
	}
	{
		Name = "Show Early Timing"
		Id = EARLY_TIMING
		Description = "Guitar Hero 3 only destroys gems as soon as they cross the strikeline. No more!"
	}
	{
		Name = "Insta Fail"
		Id = INSTA_FAIL
		Description = "Miss a note, fail the song!"
	}
	{
		Name = "Black Background"
		Id = BLACK_BACKGROUND
		Description = "Nothing can distract me now!"
	}
	{
		Name = "Post Processing"
		Id = NOPOSTPROC
		Description = "Removes all post-processing effects."
	}
	{
		Name = "Song Title Always"
		Id = SONG_TITLE
		Description = "Now you won't have to answer to \'Hey what song is this?\'"
	}
	{
		Name = "Select In Practice"
		Id = SELECT_RESTART
		Description = "You can now press select to restart in Practice mode."
	}
	{
		Name = "Awesomeness Detection"
		Id = AWESOMENESS
		Description = "Let NeverHax know that you are awesome!"
	}
	{
		Name = "Autoplay"
		Id = AUTOPLAY
		Description = "Hey! No cheating!"
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
		Name = "Unlock All"
		Id = UNLOCK_ALL
		Description = "Unlocks everything, including cheats"
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
	CreateScreenElement {
		Type = TextElement
		Id = dx_settings_scroller_up
		PARENT = <Id>
		font = text_a1
		Pos = (83.0, 105.0)
		Text = '^'
		rgba = $scroller_rgba
		just = [Center Top]
		Scale = (0.9, 1.4)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 103)
	}
	CreateScreenElement {
		Type = TextElement
		Id = dx_settings_scroller_down
		PARENT = pause_menu_frame_container
		font = text_a3
		Pos = (640.0, 510.0)
		Text = 'v'
		rgba = $scroller_rgba
		just = [Center Top]
		Scale = (1.6, 0.9)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 103)
	}
	CreateScreenElement {
		Type = TextBlockElement
		Id = dx_desc_text
		PARENT = pause_menu_frame_container
		font = text_a1
		Pos = (640.0, 475.0)
		Dims = (950.0, 0.0)
		Text = ""
		rgba = $scroller_rgba
		just = [Center Top]
		Scale = 0.32
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 103)
		allow_expansion
	}

	CreateScreenElement {
		Type = TextBlockElement
		Id = modifier_warning
		PARENT = pause_menu_frame_container
		font = text_a1
		Pos = (785.0, 210.0)
		Dims = (950.0, 0.0)
		Text = "(SAVING DISABLED)"
		rgba = [255 0 0 255]
		just = [Center Top]
		Scale = 0.75
		Alpha = 0
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba [0 0 0 255]
		z_priority = (<pause_z> + 103)
		allow_expansion
	}

	show_modifiers_warning

	dx_desc_text :SetProps Text = ($modifier_options [0].Description)
	
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

script show_modifiers_warning 
	if ($enable_saving = 0)
		DoScreenElementMorph \{Id = modifier_warning
			Alpha = 1
			Time = 0.1}
	else
		DoScreenElementMorph \{Id = modifier_warning
			Alpha = 0
			Time = 0.1}
	endif
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
	dx_desc_text :SetProps Text = ($modifier_options [$selected_modifier_index].Description)
	if (<make_sound> = 1)
		generic_menu_up_or_down_sound \{UP}
		dx_settings_scroller_up :SetProps rgba = [255 255 255 240]
		dx_settings_scroller_up :SetProps Pos = (83.0, 100.0)
		Wait \{200
			milliseconds}
		dx_settings_scroller_up :SetProps rgba = $scroller_rgba
		dx_settings_scroller_up :SetProps Pos = (83.0, 105.0)
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
	dx_desc_text :SetProps Text = ($modifier_options [$selected_modifier_index].Description)
	if (<make_sound> = 1)
		generic_menu_up_or_down_sound \{DOWN}
		dx_settings_scroller_down :SetProps rgba = [255 255 255 240]
		dx_settings_scroller_down :SetProps Pos = (640.0, 515.0)
		Wait \{200
			milliseconds}
		dx_settings_scroller_down :SetProps rgba = $scroller_rgba
		dx_settings_scroller_down :SetProps Pos = (640.0, 510.0)
	endif
endscript

script menu_dx_mods_select
	Change dx_settings_changed = 1
	GetGlobalTags \{user_options}
	switch (($modifier_options [$selected_modifier_index].Id))
		case BLACK_HIGHWAY
			if (<black_highway> = 0)
				if (<transparent_highway> = 1)
					SetGlobalTags user_options Params = {transparent_highway = 0}
					FormatText ChecksumName = mods_text_id 'mods_text_%d' D = (1)
					menu_dx_mods_setprop Element_Id = <mods_text_id> Index = (1)
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
					FormatText ChecksumName = mods_text_id 'mods_text_%d' D = (0)
					menu_dx_mods_setprop Element_Id = <mods_text_id> Index = (0)
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
				Change intro_sequence_props = $dx_intro_sequence_props
				Change fastintro_sequence_props = $dx_fastintro_sequence_props
				Change practice_sequence_props = $dx_practice_sequence_props
				Change immediate_sequence_props = $dx_immediate_sequence_props
			else
				SetGlobalTags user_options Params = {song_title = 0}
				SoundEvent \{Event = CheckBox_SFX}
				Change intro_sequence_props = $nx_intro_sequence_props
				Change fastintro_sequence_props = $nx_fastintro_sequence_props
				Change practice_sequence_props = $nx_practice_sequence_props
				Change immediate_sequence_props = $nx_immediate_sequence_props
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
		case NO_WHAMMY_PARTICLES
			if (<no_whammy_particles> = 0)
			 	SetGlobalTags user_options Params = {no_whammy_particles = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {no_whammy_particles = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case FIREWORK_GEMS
			if ($firework_gems = 0)
			 	change firework_gems = 1
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				change firework_gems = 0
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case NO_WHAMMY_PITCH_SHIFT
			if (<no_whammy_pitch_shift> = 0)
			 	SetGlobalTags user_options Params = {no_whammy_pitch_shift = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {no_whammy_pitch_shift = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case NO_MISS_SFX
			if (<no_miss_sfx> = 0)
			 	SetGlobalTags user_options Params = {no_miss_sfx = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {no_miss_sfx = 0}
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
      			SetGlobalTags user_options Params = {autosave = 0}
				Change enable_saving = 0
      			SoundEvent \{Event = CheckBox_Check_SFX}
    		elseif ($player1_status.bot_play != 0 && $player2_status.bot_play = 0)
   		    	Change StructureName = player1_status bot_play = 0
  		    	Change StructureName = player2_status bot_play = 1
  		    	SetGlobalTags user_options Params = {autosave = 0}
				Change enable_saving = 0
  		    	SoundEvent \{Event = CheckBox_Check_SFX}
 		    elseif ($player1_status.bot_play = 0 && $player2_status.bot_play != 0)
		        Change StructureName = player1_status bot_play = 1
		        Change StructureName = player2_status bot_play = 1
		        SetGlobalTags user_options Params = {autosave = 0}
				Change enable_saving = 0
		        SoundEvent \{Event = CheckBox_Check_SFX}
		    elseif ($player1_status.bot_play != 0 && $player2_status.bot_play != 0)
		        Change StructureName = player1_status bot_play = 0
		        Change StructureName = player2_status bot_play = 0
		        if ($lock_saving = 0 && $enable_button_cheats = 0)
		        	SetGlobalTags user_options Params = {autosave = 1}
					Change enable_saving = 1
				elseif ($enable_button_cheats = 0)
					SetGlobalTags user_options Params = {autosave = 1}
					Change enable_saving = 1
					Change reenable_saving = 1
				endif
		        SoundEvent \{Event = CheckBox_SFX}
		    endif
    	case DEBUG_MODE
    		if ($enable_button_cheats = 0)
				Change enable_button_cheats = 1
				SetGlobalTags user_options Params = {autosave = 0}
				Change enable_saving = 0
				SoundEvent \{Event = CheckBox_Check_SFX}
			elseif
				Change enable_button_cheats = 0
				if ($lock_saving = 0 && $player1_status.bot_play = 0 && $player2_status.bot_play = 0)
					SetGlobalTags user_options Params = {autosave = 1}
					Change enable_saving = 1
				elseif ($player1_status.bot_play = 0 && $player2_status.bot_play = 0)
					SetGlobalTags user_options Params = {autosave = 1}
					Change enable_saving = 1
					Change reenable_saving = 1
				endif
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case ENABLE_VIEWER
			ui_menu_select_sfx
			LaunchViewer
			Change \{select_shift = 1}
		case UNLOCK_ALL
			ui_menu_select_sfx
			playday_unlockall
			SetGlobalTags user_options Params = {unlock_Cheat_AirGuitar = 1}
			SetGlobalTags user_options Params = {unlock_Cheat_PerformanceMode = 1}
			SetGlobalTags user_options Params = {unlock_Cheat_Hyperspeed = 1}
			SetGlobalTags user_options Params = {unlock_Cheat_NoFail = 1}
			SetGlobalTags user_options Params = {unlock_Cheat_EasyExpert = 1}
			SetGlobalTags user_options Params = {unlock_Cheat_PrecisionMode = 1}
			SetGlobalTags user_options Params = {unlock_Cheat_BretMichaels = 1}
		case AWESOMENESS
			if (<awesomeness> = 0)
			 	SetGlobalTags user_options Params = {awesomeness = 1}
			 	SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {awesomeness = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case NOPOSTPROC
			; custom scripts with arguments :money_mouth: - Charlotte/kernaltrap8
			if (<nopostproc> = 0)
				dx_set_postproc {Action = Disable}
				SetGlobalTags user_options Params = {nopostproc = 1}
				SoundEvent \{Event = CheckBox_Check_SFX}
			else
				dx_set_postproc {Action = Enable}
				SetGlobalTags user_options Params = {nopostproc = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
		case LARGEGEMS
			if ((IsPS3) || (IsXenon))
				if (<dx_large_gems> = 0)
					SetGlobalTags user_options Params = {dx_large_gems = 1}
					SoundEvent \{Event = CheckBox_Check_SFX}
					Change gem_start_scale1 = ($gem_start_scale1_normal * $dx_large_gem_scale)
					Change gem_end_scale1 = ($gem_end_scale1_normal * $dx_large_gem_scale)
					Change gem_start_scale2 = ($gem_start_scale2_normal * $dx_large_gem_scale)
					Change gem_end_scale2 = ($gem_end_scale2_normal * $dx_large_gem_scale)
					Change whammy_top_width1 = ($whammy_top_width1_normal * $dx_large_gem_scale)
					Change whammy_top_width2 = ($whammy_top_width2_normal * $dx_large_gem_scale)
				else
					SetGlobalTags user_options Params = {dx_large_gems = 0}
					SoundEvent \{Event = CheckBox_SFX}
					Change {gem_start_scale1 = $gem_start_scale1_normal}
					Change {gem_end_scale1 = $gem_end_scale1_normal}
					Change {gem_start_scale2 = $gem_start_scale2_normal}
					Change {gem_end_scale2 = $gem_end_scale2_normal}
					Change {whammy_top_width1 = $whammy_top_width1_normal}
					Change {whammy_top_width2 = $whammy_top_width2_normal}
				endif
			endif
		case INSTA_FAIL
			if (<insta_fail> = 0)
				SetGlobalTags user_options Params = {insta_fail = 1}
				SoundEvent \{Event = CheckBox_Check_SFX}
			else
				SetGlobalTags user_options Params = {insta_fail = 0}
				SoundEvent \{Event = CheckBox_SFX}
			endif
	endswitch

	show_modifiers_warning

	FormatText ChecksumName = mods_text_id 'mods_text_%d' D = ($mods_menu_index)
	menu_dx_mods_setprop Element_Id = <mods_text_id> Index = ($selected_modifier_index)
endscript

script dx_set_postproc {Action = NONE}
	; this looks bad i know, but if it aint broke dont fix it - Charlotte/kernaltrap8
	switch <Action>
		case Disable
			Change {Default_TOD_Manager = $dx_Default_TOD_Manager}
			Change {DOF_CloseUp01_TOD_Manager = $dx_DOF_CloseUp01_TOD_Manager}
			Change {DOF_CloseUp02_TOD_Manager = $dx_DOF_CloseUp02_TOD_Manager}
			Change {DOF_CloseUp03_TOD_Manager = $dx_DOF_CloseUp03_TOD_Manager}
			Change {DOF_Medium01_TOD_Manager = $dx_DOF_Medium01_TOD_Manager}
			Change {DOF_Medium02_TOD_Manager = $dx_DOF_Medium02_TOD_Manager}
			Change {DOF_Medium03_TOD_Manager = $dx_DOF_Medium03_TOD_Manager}
			Change {DOF_Medium04_TOD_Manager = $dx_DOF_Medium04_TOD_Manager}
			Change {DOF_OFF_TOD_Manager = $dx_DOF_OFF_TOD_Manager}
			Change {DOF_Temp_tod_manager = $dx_DOF_Temp_tod_manager}
			Change {ScreenFlash_TOD_Manager = $dx_ScreenFlash_TOD_Manager}
			Change {ScreenToBlack_TOD_Manager = $dx_ScreenToBlack_TOD_Manager}
		case Enable
			Change {Default_TOD_Manager = $nx_Default_TOD_Manager}
			Change {DOF_CloseUp01_TOD_Manager = $nx_DOF_CloseUp01_TOD_Manager}
			Change {DOF_CloseUp02_TOD_Manager = $nx_DOF_CloseUp02_TOD_Manager}
			Change {DOF_CloseUp03_TOD_Manager = $nx_DOF_CloseUp03_TOD_Manager}
			Change {DOF_Medium02_TOD_Manager = $nx_DOF_Medium02_TOD_Manager}
			Change {DOF_Medium01_TOD_Manager = $nx_DOF_Medium01_TOD_Manager}
			Change {DOF_Medium03_TOD_Manager = $nx_DOF_Medium03_TOD_Manager}
			Change {DOF_Medium04_TOD_Manager = $nx_DOF_Medium04_TOD_Manager}
			Change {DOF_OFF_TOD_Manager = $nx_DOF_OFF_TOD_Manager}
			Change {DOF_Temp_tod_manager = $nx_DOF_Temp_tod_manager}
			Change {ScreenFlash_TOD_Manager = $nx_ScreenFlash_TOD_Manager}
			Change {ScreenToBlack_TOD_Manager = $nx_ScreenToBlack_TOD_Manager}
		case NONE
			ScriptAssert "hey, you forgot to pass an Action to dx_set_postproc!"
	endswitch
endscript

script menu_dx_mods_setprop
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
			 	FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
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
			 	FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case NO_WHAMMY_PARTICLES
			if (<no_whammy_particles> = 1)
			 	FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case FIREWORK_GEMS
			if ($firework_gems = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case NO_WHAMMY_PITCH_SHIFT
			if (<no_whammy_pitch_shift> = 1)
			 	FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case NO_MISS_SFX
			if (<no_miss_sfx> = 1)
			 	FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
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
		case UNLOCK_ALL
			<Element_Id> :SetProps text = ($modifier_options [<Index>].Name)
		case AWESOMENESS
			if (<awesomeness> = 1)
			 	FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case NOPOSTPROC
			if (<nopostproc> = 1)
				FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			elseif
				FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
				<Element_Id> :SetProps text = <mod_text>
			endif
		case LARGEGEMS
			if ((IsPS3) || (IsXenon))
				if (<dx_large_gems> = 1)
					FormatText TextName = mod_text '%n: On' n = ($modifier_options [<Index>].Name)
					<Element_Id> :SetProps text = <mod_text>
				elseif
					FormatText TextName = mod_text '%n: Off' n = ($modifier_options [<Index>].Name)
					<Element_Id> :SetProps text = <mod_text>
				endif
			endif
		case INSTA_FAIL
			if (<insta_fail> = 1)
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
