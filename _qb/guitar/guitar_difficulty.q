p2_scroll_time_factor = 1
p2_game_speed_factor = 1

script difficulty_setup 
	scroll_time_factor = 1
	game_speed_factor = 1
	if ($current_num_players = 2 || $end_credits = 1)
		scroll_time_factor = ($p2_scroll_time_factor)
		game_speed_factor = ($p2_game_speed_factor)
	endif
	if ($Cheat_HyperSpeed > 0)
		hyperspeed_scale = -1
		switch $Cheat_HyperSpeed
			case 1
			<hyperspeed_scale> = 0.88
			case 2
			<hyperspeed_scale> = 0.83
			case 3
			<hyperspeed_scale> = 0.78
			case 4
			<hyperspeed_scale> = 0.72999996
			case 5
			<hyperspeed_scale> = 0.68
		endswitch
		if (<hyperspeed_scale> > 0)
			scroll_time_factor = (<scroll_time_factor> * <hyperspeed_scale>)
			game_speed_factor = (<game_speed_factor> * <hyperspeed_scale>)
		endif
	endif
	AddParams ($difficulty_list_props.<DIFFICULTY>)
	Change StructureName = <player_status> scroll_time = (<scroll_time> * <scroll_time_factor>)
	Change StructureName = <player_status> game_speed = (<game_speed> * <game_speed_factor>)
endscript