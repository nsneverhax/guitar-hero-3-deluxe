script start_bootup_sequence 
	if ($show_movies = 0)
		StartRendering
		SpawnScriptNow \{ui_flow_manager_respond_to_action
			Params = {
				action = skip_bootup_sequence
				play_sound = 0
			}}
		return
	endif
	SpawnScriptNow \{bootup_sequence}
endscript
