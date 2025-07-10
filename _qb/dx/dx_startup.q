script load_dx_settings
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
endscript