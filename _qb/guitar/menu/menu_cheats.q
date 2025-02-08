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
