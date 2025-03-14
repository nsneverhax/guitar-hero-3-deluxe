script toggle_hyperspeed 
	GetGlobalTags \{user_options}
	if ($<cheat> >= 0)
		if ($<cheat> = 9)
			new_value = 0
			Change GlobalName = <cheat> NewValue = <new_value>
			SetGlobalTags user_options Params = {Cheat_HyperSpeed = <new_value>}
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [<index>].name_text)
			setscreenelementprops id = <id> text = <text>
		else
			new_value = ($<cheat> + 1)
			Change GlobalName = <cheat> NewValue = ($<cheat> + 1)
			SetGlobalTags user_options Params = {Cheat_HyperSpeed = <new_value>}
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [<index>].name_text)
			formattext textname = text "%c, %d" c = <text> d = (<new_value>)
			setscreenelementprops id = <id> text = <text>
		endif
	endif
endscript

script toggle_cheat 
	GetGlobalTags \{user_options}
	if ($<cheat> > 0)
		if ($<cheat> = 1)
			change globalname = <cheat> newvalue = 2
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [<index>].name_text)
			setscreenelementprops id = <id> text = <text>
			if ($cheat_easyexpert = 2 || $cheat_precisionmode = 2)
				change \{check_time_early = $original_check_time_early}
				change \{check_time_late = $original_check_time_late}
			endif
			turnoff_cheat = ($guitar_hero_cheats [<index>].name)
			switch (<turnoff_cheat>)
				case airguitar
					SetGlobalTags user_options Params = {Cheat_AirGuitar = 2}
				case nofail
					SetGlobalTags user_options Params = {Cheat_NoFail = 2}
				case bretmichaels
					SetGlobalTags user_options Params = {Cheat_BretMichaels = 2}
			endswitch
		else
			change globalname = <cheat> newvalue = 1
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [<index>].name_text)
			turnon_cheat = ($guitar_hero_cheats [<index>].name)
			setscreenelementprops id = <id> text = <text>
			switch (<turnon_cheat>)
				case airguitar
					SetGlobalTags user_options Params = {Cheat_AirGuitar = 1}
				case nofail
					SetGlobalTags user_options Params = {Cheat_NoFail = 1}
				case bretmichaels
					SetGlobalTags user_options Params = {Cheat_BretMichaels = 1}
			endswitch
			if (<turnon_cheat> = easyexpert)
				change check_time_early = ($original_check_time_early * 2)
				change check_time_late = ($original_check_time_late * 2)
				if ($cheat_precisionmode = 1)
					formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [5].name_text)
					change \{globalname = cheat_precisionmode
						newvalue = 2}
					setscreenelementprops id = cheat_precisionmode_text text = <text>
				endif
			endif
			if (<turnon_cheat> = precisionmode)
				change check_time_early = ($original_check_time_early / 2)
				change check_time_late = ($original_check_time_late / 2)
				if ($cheat_easyexpert = 1)
					formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [4].name_text)
					change \{globalname = cheat_easyexpert
						newvalue = 2}
					setscreenelementprops id = cheat_easyexpert_text text = <text>
				endif
			endif
			if (<turnon_cheat> = 0x7186cc04)
				change gem_start_scale1 = ($gem_start_scale1_normal * $large_gem_scale)
				change gem_end_scale1 = ($gem_end_scale1_normal * $large_gem_scale)
				change gem_start_scale2 = ($gem_start_scale2_normal * $large_gem_scale)
				change gem_end_scale2 = ($gem_end_scale2_normal * $large_gem_scale)
				change whammy_top_width1 = ($whammy_top_width1_normal * $large_gem_scale)
				change whammy_top_width2 = ($whammy_top_width2_normal * $large_gem_scale)
			endif
		endif
	else
		setscreenelementprops id = <id> text = "locked"
	endif
	show_cheat_warning
endscript