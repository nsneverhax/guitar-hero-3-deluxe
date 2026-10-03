whammy_cutoff = 1120.0

script generate_move_table \{interval = 60
		pos_start_orig = 0}
	0x33061fe2
	MathPow (<interval> / 60.0) Exp = 2
	Y = 720
	pos_add = -720
	pos_sub = 1.0
	pos_sub_add = (0.0004386 / <pow>)
	0xaea75032 = (1.0 / <interval>)
	Size = (<interval> * 2.5)
	CastToInteger \{Size}
	CreateIndexArray <Size>
	I = 0
	begin
	<Y> = (<Y> + (<pos_add> * <0xaea75032>))
	<pos_add> = (<pos_add> * <pos_sub>)
	<pos_sub> = (<pos_sub> - <pos_sub_add>)
	Element = (<Y> * 1000.0)
	CastToInteger \{Element}
	SetArrayElement ArrayName = index_array Index = <I> NewValue = <Element>
	if (<Y> <= <pos_start_orig> || <pos_add> >= -0.002)
		break
	endif
	Increment \{I}
	if (<I> >= <Size>)
		break
	endif
	repeat
	0xdabcdb23 <...> 'generate_move_table'
	if (<I> >= <Size>)
		begin
		Printf \{'overshot move table index!!!!!!!!!!!!!'}
		repeat 10
	endif
	return moveTable = <index_array>
endscript

script generate_pos_table 
	GetGlobalTags \{user_options}
	if (<hw_angle> = "GH3_2P")
		change \{ghighwaytiling = $ghighwaytiling2}
		change \{highway_playline = $highway_playline2}
		change \{highway_height = $highway_height2}
		change \{highway_top_width = $highway_top_width2}
		change \{widthoffsetfactor = $widthoffsetfactor2}
		change \{highway_fade = $highway_fade2}
		change \{gem_start_scale = $gem_start_scale2}
		change \{gem_end_scale = $gem_end_scale2}
		change \{gem_star_scale = $gem_star_scale2}
		change \{gem_y_just = $gem_y_just2}
		change \{star_y_just = $star_y_just2}
		change \{fretbar_start_scale = $fretbar_start_scale2}
		change \{whammy_top_width = $whammy_top_width2}
		change \{whammy_width_offset = $whammy_width_offset2}
		change \{sidebar_x_offset = $sidebar_x_offset2}
		change \{sidebar_x_scale = $sidebar_x_scale2}
		change \{sidebar_y_scale = $sidebar_y_scale2}
		change \{starpower_fx_scale = $starpower_fx_scale2}
		change \{nowbar_scale_x = $nowbar_scale_x2}
		change \{nowbar_scale_y = $nowbar_scale_y2}
		change \{string_scale_x = $string_scale_x2}
		change \{string_scale_y = $string_scale_y2}
	elseif ($current_num_players = 1 && $end_credits = 0)
		change \{ghighwaytiling = $ghighwaytiling1}
		change \{highway_playline = $highway_playline1}
		change \{highway_height = $highway_height1}
		change \{highway_top_width = $highway_top_width1}
		change \{widthoffsetfactor = $widthoffsetfactor1}
		change \{highway_fade = $highway_fade1}
		change \{gem_start_scale = $gem_start_scale1}
		change \{gem_end_scale = $gem_end_scale1}
		change \{gem_star_scale = $gem_star_scale1}
		change \{gem_y_just = $gem_y_just1}
		change \{star_y_just = $star_y_just1}
		change \{fretbar_start_scale = $fretbar_start_scale1}
		change \{whammy_top_width = $whammy_top_width1}
		change \{whammy_width_offset = $whammy_width_offset1}
		change \{sidebar_x_offset = $sidebar_x_offset1}
		change \{sidebar_x_scale = $sidebar_x_scale1}
		change \{sidebar_y_scale = $sidebar_y_scale1}
		change \{starpower_fx_scale = $starpower_fx_scale1}
		change \{nowbar_scale_x = $nowbar_scale_x1}
		change \{nowbar_scale_y = $nowbar_scale_y1}
		change \{string_scale_x = $string_scale_x1}
		change \{string_scale_y = $string_scale_y1}
	else
		change \{ghighwaytiling = $ghighwaytiling2}
		change \{highway_playline = $highway_playline2}
		change \{highway_height = $highway_height2}
		change \{highway_top_width = $highway_top_width2}
		change \{widthoffsetfactor = $widthoffsetfactor2}
		change \{highway_fade = $highway_fade2}
		change \{gem_start_scale = $gem_start_scale2}
		change \{gem_end_scale = $gem_end_scale2}
		change \{gem_star_scale = $gem_star_scale2}
		change \{gem_y_just = $gem_y_just2}
		change \{star_y_just = $star_y_just2}
		change \{fretbar_start_scale = $fretbar_start_scale2}
		change \{whammy_top_width = $whammy_top_width2}
		change \{whammy_width_offset = $whammy_width_offset2}
		change \{sidebar_x_offset = $sidebar_x_offset2}
		change \{sidebar_x_scale = $sidebar_x_scale2}
		change \{sidebar_y_scale = $sidebar_y_scale2}
		change \{starpower_fx_scale = $starpower_fx_scale2}
		change \{nowbar_scale_x = $nowbar_scale_x2}
		change \{nowbar_scale_y = $nowbar_scale_y2}
		change \{string_scale_x = $string_scale_x2}
		change \{string_scale_y = $string_scale_y2}
	endif
	setallwhammyvalues \{value = 1.0
		player = 1}
	setallwhammyvalues \{value = 1.0
		player = 2}
	<hheight> = ($highway_height - 162)
	if (<hheight> < 0)
		<hheight> = 0
	endif
	if (<hheight> > 510)
		<hheight> = 510
	endif
	change heightperspfact = ($heightperspfacttable [<hheight>])
	change heightperspexp = ($heightperspexptable [<hheight>])
	heightoffsetfactor = $heightperspfact
	heightoffsetexp = $heightperspexp
	starty = ($highway_playline - $highway_height)
	rows = $highway_lines
	normal_rows = $real_highway_lines
	height = $highway_height
	rowheightnormalizationfactor = 0.0
	htx = (640.0 - ($highway_top_width / 2.0))
	gts = ($highway_top_width / 5.0)
	gsx = (<htx> + (<gts> / 2.0) + (<gts> * 0.0))
	rsx = (<htx> + (<gts> / 2.0) + (<gts> * 1.0))
	ysx = (<htx> + (<gts> / 2.0) + (<gts> * 2.0))
	bsx = (<htx> + (<gts> / 2.0) + (<gts> * 3.0))
	osx = (<htx> + (<gts> / 2.0) + (<gts> * 4.0))
	hbw = ($highway_top_width + ($highway_top_width * $widthoffsetfactor))
	hbx = (640.0 - (<hbw> / 2.0))
	gbs = (<hbw> / 5.0)
	gex = (<hbx> + (<gbs> / 2.0) + (<gbs> * 0.0))
	rex = (<hbx> + (<gbs> / 2.0) + (<gbs> * 1.0))
	yex = (<hbx> + (<gbs> / 2.0) + (<gbs> * 2.0))
	bex = (<hbx> + (<gbs> / 2.0) + (<gbs> * 3.0))
	oex = (<hbx> + (<gbs> / 2.0) + (<gbs> * 4.0))
	atan2 x = $highway_height y = (<gsx> - <gex>)
	ga = <atan>
	atan2 x = $highway_height y = (<rsx> - <rex>)
	ra = <atan>
	atan2 x = $highway_height y = (<ysx> - <yex>)
	ya = <atan>
	atan2 x = $highway_height y = (<bsx> - <bex>)
	ba = <atan>
	atan2 x = $highway_height y = (<osx> - <oex>)
	oa = <atan>
	setbuttondata array = button_models color = green angle = <ga> start_x = <gsx> start_y = <starty> end_x = <gex> end_y = ($highway_playline) left_start_x = <osx> left_end_x = <oex> left_angle = <oa>
	setbuttondata array = button_models color = red angle = <ra> start_x = <rsx> start_y = <starty> end_x = <rex> end_y = ($highway_playline) left_start_x = <bsx> left_end_x = <bex> left_angle = <ba>
	setbuttondata array = button_models color = yellow angle = <ya> start_x = <ysx> start_y = <starty> end_x = <yex> end_y = ($highway_playline) left_start_x = <ysx> left_end_x = <yex> left_angle = <ya>
	setbuttondata array = button_models color = blue angle = <ba> start_x = <bsx> start_y = <starty> end_x = <bex> end_y = ($highway_playline) left_start_x = <rsx> left_end_x = <rex> left_angle = <ra>
	setbuttondata array = button_models color = orange angle = <oa> start_x = <osx> start_y = <starty> end_x = <oex> end_y = ($highway_playline) left_start_x = <gsx> left_end_x = <gex> left_angle = <ga>
	setbuttondata array = button_up_models color = green pos_x = <gex> pos_y = ($highway_playline) left_pos_x = <oex>
	setbuttondata array = button_up_models color = red pos_x = <rex> pos_y = ($highway_playline) left_pos_x = <bex>
	setbuttondata array = button_up_models color = yellow pos_x = <yex> pos_y = ($highway_playline) left_pos_x = <yex>
	setbuttondata array = button_up_models color = blue pos_x = <bex> pos_y = ($highway_playline) left_pos_x = <rex>
	setbuttondata array = button_up_models color = orange pos_x = <oex> pos_y = ($highway_playline) left_pos_x = <gex>
	change fretbar_end_scale = ($fretbar_start_scale + ($fretbar_start_scale * $widthoffsetfactor))
	change gem_end_scale = ($gem_start_scale + ($gem_start_scale * $widthoffsetfactor))
	fe = ($highway_playline - $highway_height)
	fs = (<fe> + $highway_fade)
	change ghighwaystartfade = <fs>
	change ghighwayendfade = <fe>
	stx = (640.0 - ($highway_top_width / 2.0))
	sbx = (640.0 - (<hbw> / 2.0))
	atan2 x = $highway_height y = (<stx> - <sbx>)
	change sidebar_angle = <atan>
	vec_x = (<sbx> - <stx>)
	vec_y = $highway_height
	change sidebar_x = ((<sbx> + (<vec_x> * 0.25)) - $sidebar_x_offset)
	change sidebar_y = ($highway_playline + (<vec_y> * 0.25))
	setarrayelement \{arrayname = rowheightnormalizeddistance
		index = 0
		newvalue = 1.0
		globalarray}
	<index> = 1
	begin
	value = ($rowheightnormalizeddistance [(<index> -1)] * <heightoffsetfactor>)
	mathpow <value> exp = <heightoffsetexp>
	setarrayelement arrayname = rowheightnormalizeddistance index = <index> newvalue = <pow> globalarray
	<index> = (<index> + 1)
	repeat (<rows> -1)
	<index> = 0
	begin
	<rowheightnormalizationfactor> = (<rowheightnormalizationfactor> + $rowheightnormalizeddistance [<index>])
	<index> = (<index> + 1)
	repeat <normal_rows>
	<rowheightnormalizationfactor> = (1.0 / <rowheightnormalizationfactor>)
	<index> = 0
	begin
	value = ($rowheightnormalizeddistance [<index>] * <rowheightnormalizationfactor>)
	setarrayelement arrayname = rowheightnormalizeddistance index = <index> newvalue = <value> globalarray
	setarrayelement arrayname = gem_time_table512 index = <index> newvalue = <value> globalarray
	<index> = (<index> + 1)
	repeat <rows>
	setarrayelement arrayname = rowheight index = 0 newvalue = <starty> globalarray
	<index> = 1
	begin
	value = ($rowheight [(<index> -1)] + (<height> * ($rowheightnormalizeddistance [(<index> -1)])))
	setarrayelement arrayname = rowheight index = <index> newvalue = <value> globalarray
	<index> = (<index> + 1)
	repeat <rows>
	setarrayelement \{arrayname = time_accum_table
		index = 0
		newvalue = 0.0
		globalarray}
	<index> = 1
	begin
	value = ($time_accum_table [(<index> -1)] + $gem_time_table512 [<index>])
	setarrayelement arrayname = time_accum_table index = <index> newvalue = <value> globalarray
	<index> = (<index> + 1)
	repeat (<rows> -1)
	setrowheighttables
	setgemconstants
endscript