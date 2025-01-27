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

script create_highway_prepass 
endscript

script setup_highway \{Player = 1}
	generate_pos_table
	SetScreenElementLock \{Id = root_window
		OFF}
	if ($current_num_players = 1)
		<Pos> = (0.0, 0.0)
		<Scale> = (1.0, 1.0)
	else
		if (<Player> = 1)
			<Pos> = ((0 - $x_offset_p2) * (1.0, 0.0))
		else
			if NOT ($devil_finish = 1)
				<Pos> = ($x_offset_p2 * (1.0, 0.0))
			else
				<Pos> = (1000.0, 0.0)
			endif
		endif
		<Scale> = (1.0, 1.0)
	endif
	<Container_pos> = (<Pos> + (0.0, 720.0))
	FormatText ChecksumName = container_id 'gem_container%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = ContainerElement
		Id = <container_id>
		PARENT = root_window
		Pos = <Container_pos>
		just = [LEFT Top]
		Scale = <Scale>
		z_priority = 0
	}
	hpos = ((640.0 - ($highway_top_width / 2.0)) * (1.0, 0.0))
	hDims = ($highway_top_width * (1.0, 0.0))
	<highway_material> = ($<player_status>.highway_material)
	FormatText ChecksumName = highway_name 'Highway_2D%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <highway_name>
		PARENT = <container_id>
		clonematerial = <highway_material>
		rgba = $highway_normal
		Pos = <hpos>
		Dims = <hDims>
		just = [LEFT LEFT]
		z_priority = 0.1
	}
	highway_speed = (0.0 - ($gHighwayTiling / ($<player_status>.scroll_time - $destroy_time)))
	Printf "Setting highway speed to: %h" H = <highway_speed>
	Set2DHighwaySpeed SPEED = <highway_speed> Id = <highway_name> player_status = <player_status>
	fe = ($highway_playline - $highway_height)
	fs = (<fe> + $highway_fade)
	Set2DHighwayFade Start = <fs> End = <fe> Id = <highway_name> Player = <Player>
	Pos = ((640 * (1.0, 0.0)) + ($highway_playline * (0.0, 1.0)))
	now_scale = (($nowbar_scale_x * (1.0, 0.0)) + ($nowbar_scale_y * (0.0, 1.0)))
	lpos = (($sidebar_x * (1.0, 0.0)) + ($sidebar_y * (0.0, 1.0)))
	langle = ($sidebar_angle)
	rpos = ((((640.0 - $sidebar_x) + 640.0) * (1.0, 0.0)) + ($sidebar_y * (0.0, 1.0)))
	rangle = (0.0 - ($sidebar_angle))
	Scale = (($sidebar_x_scale * (1.0, 0.0)) + ($sidebar_y_scale * (0.0, 1.0)))
	rscale = (((0 - $sidebar_x_scale) * (1.0, 0.0)) + ($sidebar_y_scale * (0.0, 1.0)))
	FormatText ChecksumName = cont 'sidebar_container_left%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = ContainerElement
		Id = <cont>
		PARENT = <container_id>
		Pos = <lpos>
		Rot_Angle = <langle>
		just = [Center Bottom]
		z_priority = 3
	}
	FormatText ChecksumName = Name 'sidebar_left%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_sidebar2D_sys_sidebar2D
		rgba = [255 255 255 255]
		Pos = (0.0, 0.0)
		Scale = <Scale>
		just = [Center Bottom]
		z_priority = 3
	}
	Set2DGemFade Id = <Name> Player = <Player>
	FormatText ChecksumName = cont 'starpower_container_left%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = ContainerElement
		Id = <cont>
		PARENT = <container_id>
		Pos = <lpos>
		Rot_Angle = <langle>
		just = [Center Bottom]
		z_priority = 3
	}
	starpower_pos = (((-55.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((55.0 * $starpower_fx_scale) * (0.0, 1.0)))
	starpower_scale = (((1.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((1.1 * $starpower_fx_scale) * (0.0, 1.0)))
	FormatText ChecksumName = Name 'sidebar_left_glow%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_Starpower_SDGLOW_sys_Starpower_SDGLOW
		rgba = [255 255 255 255]
		Pos = <starpower_pos>
		Scale = <starpower_scale>
		just = [Center Bottom]
		z_priority = 0
	}
	starpower_pos = (((0.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((0 * $starpower_fx_scale) * (0.0, 1.0)))
	starpower_scale = (((-0.5 * $starpower_fx_scale) * (1.0, 0.0)) + ((0.9 * $starpower_fx_scale) * (0.0, 1.0)))
	FormatText ChecksumName = Name 'sidebar_left_Lightning01%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_Big_Bolt01_sys_Big_Bolt01
		rgba = [0 0 128 128]
		Pos = <starpower_pos>
		Rot_Angle = (180)
		Scale = <starpower_scale>
		just = [Center Top]
		z_priority = 4
	}
	starpower_pos = (((0.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((0.0 * $starpower_fx_scale) * (0.0, 1.0)))
	starpower_scale = (((2.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((0.9 * $starpower_fx_scale) * (0.0, 1.0)))
	FormatText ChecksumName = Name 'sidebar_left_Lightning02%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_Big_Bolt01_sys_Big_Bolt01
		rgba = [255 255 255 255]
		Pos = <starpower_pos>
		Rot_Angle = (180)
		Scale = <starpower_scale>
		just = [Center Top]
		z_priority = 0.02
	}
	FormatText ChecksumName = cont 'sidebar_container_right%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = ContainerElement
		Id = <cont>
		PARENT = <container_id>
		Pos = <rpos>
		Rot_Angle = <rangle>
		just = [Center Bottom]
		z_priority = 3
	}
	FormatText ChecksumName = Name 'sidebar_right%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_sidebar2D_sys_sidebar2D
		rgba = [255 255 255 255]
		Pos = (0.0, 0.0)
		Scale = <rscale>
		just = [Center Bottom]
		z_priority = 3
	}
	Set2DGemFade Id = <Name> Player = <Player>
	FormatText ChecksumName = cont 'starpower_container_right%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = ContainerElement
		Id = <cont>
		PARENT = <container_id>
		Pos = <rpos>
		Rot_Angle = <rangle>
		just = [Center Bottom]
		z_priority = 3
	}
	starpower_pos = (((55.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((55.0 * $starpower_fx_scale) * (0.0, 1.0)))
	starpower_scale = (((-1.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((1.1 * $starpower_fx_scale) * (0.0, 1.0)))
	FormatText ChecksumName = Name 'sidebar_Right_glow%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_Starpower_SDGLOW_sys_Starpower_SDGLOW
		rgba = [255 255 255 255]
		Pos = <starpower_pos>
		Scale = <starpower_scale>
		just = [Center Bottom]
		z_priority = 0
	}
	starpower_pos = (((0.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((0 * $starpower_fx_scale) * (0.0, 1.0)))
	starpower_scale = (((0.5 * $starpower_fx_scale) * (1.0, 0.0)) + ((0.9 * $starpower_fx_scale) * (0.0, 1.0)))
	FormatText ChecksumName = Name 'sidebar_Right_Lightning01%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_Big_Bolt01_sys_Big_Bolt01
		rgba = [0 0 128 128]
		Pos = <starpower_pos>
		Rot_Angle = (180)
		Scale = <starpower_scale>
		just = [Center Top]
		z_priority = 4
	}
	starpower_pos = (((0.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((0.0 * $starpower_fx_scale) * (0.0, 1.0)))
	starpower_scale = (((2.0 * $starpower_fx_scale) * (1.0, 0.0)) + ((0.9 * $starpower_fx_scale) * (0.0, 1.0)))
	FormatText ChecksumName = Name 'sidebar_Right_Lightning02%p' P = <player_Text> AddToStringLookup = TRUE
	CreateScreenElement {
		Type = SpriteElement
		Id = <Name>
		PARENT = <cont>
		Material = sys_Big_Bolt01_sys_Big_Bolt01
		rgba = [255 255 255 255]
		Pos = <starpower_pos>
		Rot_Angle = (180)
		Scale = <starpower_scale>
		just = [Center Top]
		z_priority = 0.02
	}
	FormatText ChecksumName = cont 'starpower_container_left%p' P = <player_Text> AddToStringLookup = TRUE
	DoScreenElementMorph Id = <cont> Alpha = 0
	FormatText ChecksumName = cont 'starpower_container_right%p' P = <player_Text> AddToStringLookup = TRUE
	DoScreenElementMorph Id = <cont> Alpha = 0
	GetArraySize \{$gem_colors}
	array_count = 0
	begin
	Color = ($gem_colors [<array_count>])
	if StructureContains Structure = ($button_up_models.<Color>) Name = Name
		if ($<player_status>.lefthanded_button_ups = 1)
			<pos2d> = ($button_up_models.<Color>.left_pos_2d)
		else
			<pos2d> = ($button_up_models.<Color>.pos_2d)
		endif
		Pos = (640.0, 643.0)
		FormatText ChecksumName = name_base '%s_base%p' S = ($button_up_models.<Color>.name_string) P = <player_Text> AddToStringLookup = TRUE
		FormatText ChecksumName = name_string '%s_string%p' S = ($button_up_models.<Color>.name_string) P = <player_Text> AddToStringLookup = TRUE
		FormatText ChecksumName = name_lip '%s_lip%p' S = ($button_up_models.<Color>.name_string) P = <player_Text> AddToStringLookup = TRUE
		FormatText ChecksumName = name_mid '%s_mid%p' S = ($button_up_models.<Color>.name_string) P = <player_Text> AddToStringLookup = TRUE
		FormatText ChecksumName = name_neck '%s_neck%p' S = ($button_up_models.<Color>.name_string) P = <player_Text> AddToStringLookup = TRUE
		FormatText ChecksumName = name_head '%s_head%p' S = ($button_up_models.<Color>.name_string) P = <player_Text> AddToStringLookup = TRUE
		<Pos> = (((<pos2d>.(1.0, 0.0)) * (1.0, 0.0)) + (1024 * (0.0, 1.0)))
		if ($<player_status>.lefthanded_button_ups = 1)
			<playline_scale> = (((0 - <now_scale>.(1.0, 0.0)) * (1.0, 0.0)) + (<now_scale>.(0.0, 1.0) * (0.0, 1.0)))
		else
			<playline_scale> = <now_scale>
		endif
		CreateScreenElement {
			Type = ContainerElement
			Id = <name_base>
			PARENT = <container_id>
			Pos = (0.0, 0.0)
			just = [Center Bottom]
			z_priority = 3
		}
		CreateScreenElement {
			Type = SpriteElement
			Id = <name_lip>
			PARENT = <name_base>
			Material = ($button_up_models.<Color>.material_lip)
			rgba = [255 255 255 255]
			Pos = <pos2d>
			Scale = <playline_scale>
			just = [Center Bottom]
			z_priority = 3.9
		}
		CreateScreenElement {
			Type = SpriteElement
			Id = <name_mid>
			PARENT = <name_base>
			Material = ($button_up_models.<Color>.material_mid)
			rgba = [255 255 255 255]
			Pos = <pos2d>
			Scale = <playline_scale>
			just = [Center Bottom]
			z_priority = 3.6
		}
		<y_scale> = ($neck_lip_add / $neck_sprite_size)
		<Pos> = (<pos2d> - ($neck_lip_base * (0.0, 1.0)))
		<neck_scale> = (((<playline_scale>.(1.0, 0.0)) * (1.0, 0.0)) + (<y_scale> * (0.0, 1.0)))
		CreateScreenElement {
			Type = SpriteElement
			Id = <name_neck>
			PARENT = <name_base>
			Material = ($button_up_models.<Color>.material_neck)
			rgba = [255 255 255 255]
			Pos = <Pos>
			Scale = <neck_scale>
			just = [Center Bottom]
			z_priority = 3.7
		}
		CreateScreenElement {
			Type = SpriteElement
			Id = <name_head>
			PARENT = <name_base>
			Material = ($button_up_models.<Color>.material_head)
			rgba = [255 255 255 255]
			Pos = <pos2d>
			Scale = <playline_scale>
			just = [Center Bottom]
			z_priority = 3.8
		}
		string_pos2d = ($button_up_models.<Color>.pos_2d)
		<string_scale> = (($string_scale_x * (1.0, 0.0)) + ($string_scale_y * (0.0, 1.0)))
		CreateScreenElement {
			Type = SpriteElement
			Id = <name_string>
			PARENT = <container_id>
			Material = sys_String01_sys_String01
			rgba = [200 200 200 200]
			Scale = <string_scale>
			Rot_Angle = ($button_models.<Color>.Angle)
			Pos = <string_pos2d>
			just = [Center Bottom]
			z_priority = 2
		}
	endif
	array_count = (<array_count> + 1)
	repeat <array_Size>
	SpawnScriptLater move_highway_2d Params = {<...>}
	create_highway_prepass <...>
	SetScreenElementLock \{Id = root_window
		ON}
	dx_create_input_viewer
endscript

script dx_create_input_viewer 
	
endscript
