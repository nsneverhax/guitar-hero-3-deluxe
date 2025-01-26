memcard_content_name = "DX-Progress"

script dx_memcard_sequence_begin_autosave 
	if ($dx_settings_changed = 1)
		Change dx_settings_changed = 0
	else
		start_flow_manager \{flow_state = main_menu_fs}
		return
	endif
	SpawnScriptNow memcard_sequence_begin_autosave_logic Params = <...>
endscript