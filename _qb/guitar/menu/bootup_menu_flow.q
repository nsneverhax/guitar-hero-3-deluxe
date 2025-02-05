script bootup_sequence 
	startrendering
	spawnscriptnow \{ui_flow_manager_respond_to_action
		params = {
			action = skip_bootup_sequence
			play_sound = 1
		}}
endscript
