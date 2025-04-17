memcard_content_name = "DX-Progress"

script dx_memcard_sequence_begin_autosave 
	if ($dx_settings_changed = 1)
		Change dx_settings_changed = 0
	else
		start_flow_manager \{flow_state = main_menu_fs}
		return
	endif
	if ($enable_saving = 0)
		start_flow_manager \{flow_state = main_menu_fs}
		return
	endif
	if ($reenable_saving = 1)
		handle_signin_changed
		return
	endif
	SpawnScriptNow memcard_sequence_begin_autosave_logic Params = <...>
endscript

script create_signin_changed_menu 
	destroy_popup_warning_menu
	if ($reenable_saving = 1)
		create_popup_warning_menu \{Title = "SAVING RE-ENABLED"
			title_props = {
				Scale = 1.0
			}
			textblock = {
				Text = "A deluxe setting that stopped saving is no longer active, so the game has restarted to allow saving."
				Pos = (640.0, 380.0)
			}
			Menu_pos = (640.0, 510.0)
			options = [
				{
					func = signing_change_confirm_reboot
					Text = "CONTINUE"
					Scale = (1.0, 1.0)
				}
			]}
	else
		create_popup_warning_menu \{Title = "SIGN-IN CHANGED"
			title_props = {
				Scale = 1.0
			}
			textblock = {
				Text = "A user sign-in change has caused the game to lose ownership of saves and achievements. As a result, the game has restarted."
				Pos = (640.0, 380.0)
			}
			Menu_pos = (640.0, 510.0)
			options = [
				{
					func = signing_change_confirm_reboot
					Text = "CONTINUE"
					Scale = (1.0, 1.0)
				}
			]}
	endif
endscript

script signing_change_confirm_reboot 
	Printf \{"signing_change_confirm_reboot"}
	if ($reenable_saving = 1)
		Change reenable_saving = 0
	endif
	destroy_signin_changed_menu
	enable_pause
	Wait \{5
		GameFrames}
	start_flow_manager \{flow_state = bootup_press_any_button_fs}
	Printf \{"signing_change_confirm_reboot end"}
endscript

script memcard_save_file \{overwriteconfirmed = 0}
	printf \{"==> memcard_save_file"}
	change \{memcardsavingorloading = saving}
	if ($memcard_using_new_save_system = 0)
		if isps3
			return
		endif
		setsavefilename \{filetype = progress
			name = "GH3Progress"}
		if NOT savetomemorycard \{filetype = progress}
			printstruct <...>
			return \{failed = 1}
		endif
	else
		memcard_check_for_card
		resettimer
		<overwrite> = 0
		if mc_folderexists \{foldername = $memcard_content_name}
			if (<overwriteconfirmed> = 1)
				<overwrite> = 1
				create_overwrite_menu
				mc_setactivefolder \{foldername = $memcard_content_name}
			else
				goto \{create_confirm_overwrite_menu}
			endif
		else
			if isps3
				if NOT mc_spacefornewfolder \{desc = guitarcontent}
					memcard_error \{error = create_out_of_space_menu}
				endif
			endif
			create_save_menu
			mc_createfolder \{name = $memcard_content_name
				desc = guitarcontent}
			if (<result> = false)
				if (<errorcode> = outofspace)
					memcard_error \{error = create_out_of_space_menu}
				else
					memcard_error \{error = create_save_failed_menu}
				endif
			endif
		endif
		memcard_pre_save_progress
		savetomemorycard \{filename = $memcard_file_name
			filetype = progress
			usepaddingslot = always}
		if (<result> = false)
			if (<errorcode> = outofspace)
				memcard_error \{error = create_out_of_space_menu}
			else
				if (<overwrite> = 1)
					memcard_error \{error = create_overwrite_failed_menu}
				else
					memcard_error \{error = create_save_failed_menu}
				endif
			endif
		endif
		change \{memcardsuccess = true}
		if (<overwrite> = 1)
			create_overwrite_success_menu
		else
			create_save_success_menu
		endif
	endif
	memcard_sequence_quit
endscript

script memcard_check_for_existing_save
	if ($memcard_using_new_save_system = 0)
		if isps3
			return \{found = 0}
		endif
		memcard_choose_storage_device
		getmemcarddirectorylisting \{filetype = progress}
		if (<totalthps4filesoncard> = 1)
			printf \{"Found save file"}
			return \{found = 1
				corrupt = 0}
		endif
	else
		memcard_enum_folders
		mc_waitasyncopsfinished
		memcard_check_for_card
		if mc_folderexists \{foldername = $memcard_content_name}
			mc_setactivefolder \{foldername = $memcard_content_name}
			printf \{"LOADING SAVE FILE"}
			printf \{"LOADING SAVE FILE"}
			mc_loadtocinactivefolder
			if (<result> = false)
				printf \{"LOADING FAILED, RETRYING"}
				printf \{"LOADING FAILED, RETRYING"}
				memcard_sequence_begin_bootup
			endif
			if memcardfileexists \{filename = $memcard_file_name
					filetype = progress}
				return \{found = 1
					corrupt = 0}
			else
				return \{found = 1
					corrupt = 1}
			endif
		endif
	endif
	return \{found = 0
		corrupt = 0}
	printf \{"memcard_check_for_existing_save done"}
endscript

script memcard_load_file \{loadconfirmed = 0}
	printf \{"==> memcard_load_file"}
	change \{memcardsavingorloading = loading}
	if ($memcard_using_new_save_system = 0)
		if isps3
			return
		endif
		setsavefilename \{filetype = progress
			name = "GH3Progress"}
		getglobaltags \{globaltag_checksum
			params = globaltag_checksum}
		oldglobaltag_checksum = <globaltag_checksum>
		if NOT loadfrommemorycard \{filetype = progress}
			printstruct <...>
			if gotparam \{corrupteddata}
				return \{corrupteddata = 1}
			else
				printstruct <...>
				return \{failed = 1}
			endif
		endif
	else
		mc_waitasyncopsfinished
		memcard_check_for_card
		resettimer
		if mc_folderexists \{foldername = $memcard_content_name}
			if (<loadconfirmed> = 1)
				mc_setactivefolder \{foldername = $memcard_content_name}
			else
				goto \{create_confirm_load_menu}
			endif
		else
			memcard_error \{error = create_no_save_found_menu}
		endif
		mc_setactivefolder \{foldername = $memcard_content_name}
		create_load_file_menu
		loadfrommemorycard \{filename = $memcard_file_name
			filetype = progress}
		if (<result> = false)
			if (<errorcode> = corrupt)
				memcard_error \{error = create_corrupted_data_menu}
			else
				memcard_error \{error = create_load_failed_menu}
			endif
		endif
		change \{memcardsuccess = true}
		create_load_success_menu
		memcard_post_load_progress
	endif
	memcard_sequence_quit
endscript
