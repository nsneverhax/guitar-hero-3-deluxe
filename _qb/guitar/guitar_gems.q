script kill_object_later 
	GetGlobalTags \{user_options}
	if (<early_timing = 0)
		begin
		if ScreenElementExists Id = <gem_id>
			GetScreenElementPosition Id = <gem_id> local
			py = (<ScreenELementPos>.(0.0, 1.0))
			if (<py> >= $highway_playline)
				DestroyGem Name = <gem_id>
				break
			endif
			Wait \{1
				GameFrame}
		else
			break
		endif
		repeat
	else
		if ScreenElementExists Id = <gem_id>
			DestroyGem Name = <gem_id>
		endif
	endif
endscript