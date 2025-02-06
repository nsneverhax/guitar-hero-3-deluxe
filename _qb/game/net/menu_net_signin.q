script create_winport_account_management_status_screen 
	printf \{"--- create_winport_account_management_status_screen"}
	create_menu_backdrop \{texture = online_background}
	z = 110
	createscreenelement \{type = containerelement
		parent = root_window
		id = accountstatuscontainer
		pos = (0.0, 0.0)}
	createscreenelement \{type = vscrollingmenu
		parent = accountstatuscontainer
		just = [
			center
			top
		]
		dims = (500.0, 150.0)
		pos = (640.0, 465.0)
		z_priority = 1}
	menu_id = <id>
	createscreenelement {
		type = vmenu
		parent = <menu_id>
		id = <vmenu_id>
		pos = (298.0, 0.0)
		just = [center top]
		internal_just = [center top]
		dims = (500.0, 150.0)
		event_handlers = [
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
		]
	}
	vmenu_id = <id>
	change \{menu_focus_color = [
			180
			50
			50
			255
		]}
	change \{menu_unfocus_color = [
			0
			0
			0
			255
		]}
	create_pause_menu_frame \{parent = accountstatuscontainer
		z = 5}
	displaysprite \{parent = accountstatuscontainer
		tex = dialog_title_bg
		dims = (224.0, 224.0)
		z = 9
		pos = (640.0, 100.0)
		just = [
			right
			top
		]
		flip_v}
	displaysprite \{parent = accountstatuscontainer
		tex = dialog_title_bg
		dims = (224.0, 224.0)
		z = 9
		pos = (640.0, 100.0)
		just = [
			left
			top
		]}
	createscreenelement \{type = textelement
		parent = accountstatuscontainer
		font = fontgrid_title_gh3
		scale = 1.2
		rgba = [
			223
			223
			223
			250
		]
		text = "Online"
		just = [
			center
			top
		]
		z_priority = 10.0
		pos = (640.0, 182.0)
		shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [
			0
			0
			0
			255
		]}
	createscreenelement {
		type = textblockelement
		parent = accountstatuscontainer
		id = statusmessage
		font = text_a4
		scale = 0.8
		rgba = [210 210 210 250]
		just = [center top]
		internal_just = [center top]
		internal_scale = <scale>
		z_priority = <z>
		pos = (640.0, 310.0)
		dims = (800.0, 320.0)
		line_spacing = 1.0
	}
	launchevent type = focus target = <vmenu_id>
	netsessionfunc \{func = executelogintask}
	begin
	netsessionfunc \{func = getnetworkstatus}
	switch (<currentnetworktask>)
		case "CREATE_ACCOUNT"
		switch (<currentnetworkstatus>)
			case "PENDING"
			statustext = "Requesting Account Creation"
			case "DONE"
			statustext = "Account Created"
			success = true
			case "FAILED"
			statustext = "Unable to Create Account"
			success = false
			default
			statustext = "Internal Error: Unexpected Network State!"
			success = false
		endswitch
		case "LOGIN_ACCOUNT"
		switch (<currentnetworkstatus>)
			case "PENDING"
			statustext = "Authorizing Account"
			case "DONE"
			statustext = "Account Authorized"
			success = true
			case "FAILED"
			statustext = "Unable to Authorize Account"
			success = false
			default
			statustext = "Internal Error: Unexpected Network State!"
			success = false
		endswitch
		case "CHANGE_ACCOUNT"
		switch (<currentnetworkstatus>)
			case "PENDING"
			statustext = "Requesting Password Change"
			case "DONE"
			statustext = "Password Changed"
			success = true
			case "FAILED"
			statustext = "Unable to Change Password"
			success = false
			default
			statustext = "Internal Error: Unexpected Network State!"
			success = false
		endswitch
		case "RESET_ACCOUNT"
		switch (<currentnetworkstatus>)
			case "PENDING"
			statustext = "Requesting Account Reset"
			case "DONE"
			statustext = "Account Password Reset"
			success = true
			case "FAILED"
			statustext = "Unable to Reset Account"
			success = false
			default
			statustext = "Internal Error: Unexpected Network State!"
			success = false
		endswitch
		case "DELETE_ACCOUNT"
		switch (<currentnetworkstatus>)
			case "PENDING"
			statustext = "Requesting Account Deletion"
			case "DONE"
			statustext = "Account Deleted"
			success = true
			case "FAILED"
			statustext = "Unable to Delete Account"
			success = false
			default
			statustext = "Internal Error: Unexpected Network State!"
			success = false
		endswitch
		default
		printf "Unexpected state = %s" s = <currentnetworktask>
		statustext = "Internal Error: Unexpected Network State!"
		success = false
	endswitch
	setscreenelementprops id = statusmessage text = <statustext>
	fit_text_into_menu_item \{id = statusmessage
		max_width = 480}
	if gotparam \{success}
		break
	endif
	wait \{1
		frame}
	if NOT (screenelementexists id = accountstatuscontainer)
		return
	endif
	repeat
	if (<success> = false)
		netsessionfunc \{func = getautologinsetting}
		if (<autologinsetting> = autologinon && netsessionfunc func = hasexistinglogin)
			netsessionfunc \{func = setautologinsetting
				params = {
					autologinsetting = autologinprompt
				}}
		endif
		netsessionfunc \{func = getfailurecode}
		switch <failurecode>
			case 666
			statustext = "New password fields do not match"
			case 667
			statustext = "Authorization Service failed"
			case 668
			statustext = "Usernames must be between 6 and 16 characters long"
			case 669
			statustext = "Passwords must be between 6 and 16 characters long"
			case 700
			statustext = "Task Succeeded"
			case 701
			statustext = "Bad Authorization Request"
			case 702
			statustext = "Server Configuration Error"
			case 703
			statustext = "Invalid Game Title Id"
			case 704
			statustext = "Invalid Account Information"
			case 705
			statustext = "Illegal Authorization Request"
			case 706
			statustext = "Invalid License Code"
			case 707
			statustext = "Username Already Exists"
			case 708
			statustext = "Invalid Username Format"
			case 709
			statustext = "Username Declined"
			case 710
			statustext = "Too Many Accounts for License Code"
			case 711
			statustext = "Account Migration not Supported"
			case 712
			statustext = "Title has been disabled"
			case 713
			statustext = "Account has Expired"
			case 714
			statustext = "Account is Locked"
			case 715
			statustext = "Authentication Error: Online functions will not be available until Guitar Hero III is quit and relaunched."
			case 716
			statustext = "Incorrect Password"
		endswitch
		setscreenelementprops id = statusmessage text = <statustext>
		fit_text_into_menu_item \{id = statusmessage
			max_width = 480}
		displaysprite \{parent = accountstatuscontainer
			id = options_bg_1
			tex = dialog_bg
			pos = (640.0, 500.0)
			dims = (320.0, 64.0)
			z = 9
			just = [
				center
				botom
			]}
		displaysprite \{parent = accountstatuscontainer
			id = options_bg_2
			tex = dialog_bg
			pos = (640.0, 530.0)
			dims = (320.0, 64.0)
			z = 9
			just = [
				center
				top
			]
			flip_h}
		createscreenelement {
			type = containerelement
			parent = <vmenu_id>
			dims = (100.0, 50.0)
			event_handlers = [
				{focus net_warning_focus}
				{unfocus net_warning_unfocus}
				{pad_choose ui_flow_manager_respond_to_action params = {action = erroraction}}
				{pad_back ui_flow_manager_respond_to_action params = {action = erroraction}}
			]
		}
		container_id = <id>
		createscreenelement {
			type = textelement
			parent = <container_id>
			local_id = text
			font = fontgrid_title_gh3
			scale = 0.85
			rgba = ($menu_unfocus_color)
			text = "TRY AGAIN"
			just = [center top]
			z_priority = (<z> + 0.1)
		}
		fit_text_into_menu_item id = <id> max_width = 480
		getscreenelementdims id = <id>
		createscreenelement {
			type = spriteelement
			parent = <container_id>
			local_id = bookend_left
			texture = dialog_highlight
			alpha = 0.0
			just = [right center]
			pos = ((0.0, 20.0) + (1.0, 0.0) * (<width> / (-2)) + (-5.0, 0.0))
			z_priority = (<z> + 0.1)
			scale = (1.0, 1.0)
			flip_v
		}
		createscreenelement {
			type = spriteelement
			parent = <container_id>
			local_id = bookend_right
			texture = dialog_highlight
			alpha = 0.0
			just = [left center]
			pos = ((0.0, 20.0) + (1.0, 0.0) * (<width> / (2)) + (5.0, 0.0))
			z_priority = (<z> + 0.1)
			scale = (1.0, 1.0)
		}
		clean_up_user_control_helpers
		add_user_control_helper \{text = "SELECT"
			button = green
			z = 100}
		add_user_control_helper \{text = "BACK"
			button = red
			z = 100}
		launchevent type = focus target = <vmenu_id>
		return
	endif
	ui_flow_manager_respond_to_action \{action = successaction}
	netsessionfunc \{func = stats_init}
endscript
