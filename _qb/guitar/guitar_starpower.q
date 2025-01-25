script Do_StarPower_StageFX 
	GetGlobalTags \{user_options}
	if (<black_background> = 1)
		return
	endif
	switch (<player_status>.character_id)
		case CASEY
		SpawnScriptLater Do_StarPower_ShotgunFX Id = <scriptID> Params = {<...>}
		case JOHNNY
		SpawnScriptLater Do_StarPower_FlameThrowerFX Id = <scriptID> Params = {<...>}
		case JUDY
		SpawnScriptLater Do_StarPower_HeartsFX Id = <scriptID> Params = {<...>}
		case LARS
		case RIPPER
		case SATAN
		SpawnScriptLater Do_StarPower_BatFX Id = <scriptID> Params = {<...>}
		case MIDORI
		SpawnScriptLater Do_StarPower_ButterfliesFX Id = <scriptID> Params = {<...>}
		case XAVIER
		SpawnScriptLater Do_StarPower_PeaceFX Id = <scriptID> Params = {<...>}
		default
		SpawnScriptLater Do_StarPower_TeslaFX Id = <scriptID> Params = {<...>}
	endswitch
endscript
