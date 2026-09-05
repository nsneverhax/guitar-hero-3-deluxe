dx_initialized = 0

script load_dx_settings 
    if ($dx_initialized = 1)
        return
    endif
	GetGlobalTags \{user_options}
	Change GlobalName = Cheat_HyperSpeed NewValue = <Cheat_HyperSpeed>
	Change GlobalName = Cheat_AirGuitar NewValue = <Cheat_AirGuitar>
	Change GlobalName = Cheat_NoFail NewValue = <Cheat_NoFail>
	Change GlobalName = Cheat_BretMichaels NewValue = <Cheat_BretMichaels>
	if (<black_highway> = 1)
		Change highway_normal = [0 0 0 255]
		Change highway_starpower = [0 0 0 255]
	endif
	if (<transparent_highway> > 0)
		set_transparent_highway
	endif
	if (<song_title> = 1)
		Change intro_sequence_props = $dx_intro_sequence_props
		Change fastintro_sequence_props = $dx_fastintro_sequence_props
		Change practice_sequence_props = $dx_practice_sequence_props
		Change immediate_sequence_props = $dx_immediate_sequence_props
	endif
	if (<nopostproc> = 1)
		dx_set_postproc {Action = Disable}
	endif
	if (<dx_large_gems> = 1)
		Change gem_start_scale1 = ($gem_start_scale1_normal * $dx_large_gem_scale)
		Change gem_end_scale1 = ($gem_end_scale1_normal * $dx_large_gem_scale)
		Change gem_start_scale2 = ($gem_start_scale2_normal * $dx_large_gem_scale)
		Change gem_end_scale2 = ($gem_end_scale2_normal * $dx_large_gem_scale)
		Change whammy_top_width1 = ($whammy_top_width1_normal * $dx_large_gem_scale)
		Change whammy_top_width2 = ($whammy_top_width2_normal * $dx_large_gem_scale)
	endif
    if (<fast_highway> = 1)
        dx_set_intro_trans \{Action = ON}
    endif
	GetGlobalTags $0xaebf2394 noassert = 1
	if (<ondisp_dispfps_text> = 1)
		enable_dispfps
	endif
	if (<hw_angle> = "GH2")
		Change highway_playline1 = 676
		Change highway_height1 = 325
		Change highway_top_width1 = 191.0
		Change widthOffsetFactor1 = 1.83
		Change highway_fade1 = 75.0
		Change gem_start_scale1 = 0.3
		Change fretbar_start_scale1 = 0.19
		Change sidebar_y_scale1 = 0.92
	elseif (<hw_angle> = "RB1")
	    Change highway_playline1 = 637
		Change highway_height1 = 340
		Change highway_top_width1 = 222.0
		Change widthoffsetfactor1 = 1.17
		Change highway_fade1 = 70.0
		Change gem_start_scale1 = 0.34
		Change fretbar_start_scale1 = 0.21
		Change sidebar_x_offset1 = 5.0
		Change sidebar_x_scale1 = 0.35
		Change sidebar_y_scale1 = 0.94
		Change nowbar_scale_x1 = 0.75
		Change nowbar_scale_y1 = 0.795
		Change string_scale_x1 = 0.0
		Change string_scale_y1 = 0.0
		Change highway_height2 = 300.0
		Change highway_fade2 = 80.0
		Change sidebar_y_scale2 = 0.85
		Change nowbar_scale_x2 = 0.6
		Change nowbar_scale_y2 = 0.6
		Change string_scale_x2 = 2.6
		Change string_scale_y2 = 0.7
		Change whammy_cutoff = 1120.0
	endif
    Change dx_initialized = 1
endscript