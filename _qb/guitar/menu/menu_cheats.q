script toggle_hyperspeed 
	if ($<cheat> >= 0)
		if ($<cheat> = 9)
			change globalname = <cheat> newvalue = 0
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [<index>].name_text)
			setscreenelementprops id = <id> text = <text>
		else
			change globalname = <cheat> newvalue = ($<cheat> + 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [<index>].name_text)
			formattext textname = text "%c, %d" c = <text> d = ($cheat_hyperspeed)
			setscreenelementprops id = <id> text = <text>
		endif
	endif
endscript
