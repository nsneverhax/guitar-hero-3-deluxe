script create_cheats_menu_PSWii 
	disable_pause
	if ($entering_cheat = 0)
		createscreenelement \{type = containerelement
			id = cheats_container
			parent = root_window
			pos = (0.0, 0.0)}
		create_menu_backdrop \{texture = venue_bg}
		displaysprite \{parent = cheats_container
			tex = options_video_poster
			rot_angle = 1
			pos = (640.0, 200.0)
			dims = (820.0, 530.0)
			just = [
				center
				center
			]
			z = 1
			font = $video_settings_menu_font}
		displaytext \{parent = cheats_container
			pos = (910.0, 402.0)
			just = [
				right
				center
			]
			text = 'CHEATS'
			scale = 1.5
			rgba = [
				240
				235
				240
				255
			]
			font = text_a5
			noshadow}
		displaysprite \{parent = cheats_container
			tex = tape_h_03
			pos = (270.0, 185.0)
			rot_angle = -50
			scale = 0.5
			z = 20}
		displaysprite {
			parent = <id>
			tex = tape_h_03
			pos = (5.0, 5.0)
			rgba = [0 0 0 128]
			z = 19
		}
		displaysprite \{parent = cheats_container
			tex = tape_h_04
			pos = (930.0, 380.0)
			rot_angle = -120
			scale = 0.5
			z = 20}
		displaysprite {
			parent = <id>
			tex = tape_h_04
			pos = (5.0, 5.0)
			rgba = [0 0 0 128]
			z = 19
		}
		createscreenelement \{type = containerelement
			id = cheats_warning_container
			parent = root_window
			alpha = 0
			scale = 0.5
			pos = (640.0, 540.0)}
		displaysprite \{parent = cheats_warning_container
			id = cheats_warning
			tex = control_pill_body
			pos = (0.0, 0.0)
			just = [
				center
				center
			]
			rgba = [
				96
				0
				0
				255
			]
			z = 100}
		getplatform
		switch <platform>
			case xenon
			warning = 'WARNING: Some active cheats do not work in career modes and online.'
			warning_cont = 'Also, achievement unlocking and leaderboard posts are turned off.'
			case ps3
			warning = 'WARNING: Some active cheats do not work in career modes and online.'
			warning_cont = 'Also, leaderboard posts are turned off.'
			case ps2
			warning = 'WARNING: Some active cheats do not work in career modes.'
			warning_cont = ''
			default
			warning = 'WARNING: Some active cheats do not work in career modes and online.'
			warning_cont = 'Also, leaderboard posts are turned off.'
		endswitch
		formattext textname = warning_text '%a %b' a = <warning> b = <warning_cont>
		createscreenelement {
			type = textblockelement
			id = first_warning
			parent = cheats_warning_container
			font = text_a6
			scale = 1
			text = <warning_text>
			rgba = [186 105 0 255]
			just = [center center]
			z_priority = 101.0
			pos = (0.0, 0.0)
			dims = (1400.0, 100.0)
			allow_expansion
		}
		getscreenelementdims \{id = first_warning}
		bg_dims = (<width> * (1.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
		cheats_warning :setprops dims = <bg_dims>
		displaysprite {
			parent = cheats_warning_container
			tex = control_pill_end
			pos = (-1 * <width> * (0.5, 0.0))
			rgba = [96 0 0 255]
			dims = ((64.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
			just = [right center]
			flip_v
			z = 100
		}
		displaysprite {
			parent = cheats_warning_container
			tex = control_pill_end
			pos = (<width> * (0.5, 0.0))
			rgba = [96 0 0 255]
			dims = ((64.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
			just = [left center]
			z = 100
		}
		cheats_create_guitar
	endif
	show_cheat_warning
	displaysprite \{parent = cheats_container
		id = cheats_hilite
		tex = white
		rgba = [
			40
			60
			110
			255
		]
		rot_angle = 1.75
		pos = (349.0, 382.0)
		dims = (100.0, 28.0)
		z = 2}
	new_menu \{scrollid = cheats_scroll
		vmenuid = cheats_vmenu
		menu_pos = (360.0, 203.0)
		text_left
		spacing = -3
		rot_angle = 1}
	text_params = {parent = cheats_vmenu type = textelement font = text_a3 rgba = [255 245 225 255] z_priority = 50 rot_angle = 0 scale = 0.9}
	text_params2 = {parent = cheats_vmenu type = textelement font = text_a5 rgba = [255 245 225 255] z_priority = 50 rot_angle = 0 scale = 0.72999996}
	getglobaltags \{user_options}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<unlock_cheat_nofail> > 0)
		dims = (178.0, 30.0)
		if ($cheat_nofail = 1)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [3].name_text)
		else
			if ($cheat_nofail < 0)
				change \{cheat_nofail = 2}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [3].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_nofail_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (350.0, 217.0) dims = <dims> id = cheat_nofail_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_nofail id = cheat_nofail_text index = 3}}
		]
	}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<unlock_cheat_airguitar> > 0)
		dims = (219.0, 30.0)
		if ($cheat_airguitar = 1)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [0].name_text)
		else
			if ($cheat_airguitar < 0)
				change \{cheat_airguitar = 2}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [0].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_airguitar_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (350.0, 244.0) dims = <dims> id = cheat_airguitar_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_airguitar id = cheat_airguitar_text index = 0}}
		]
	}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<unlock_cheat_hyperspeed> > 0)
		dims = (255.0, 30.0)
		if ($cheat_hyperspeed > 0)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [2].name_text)
			if ($cheat_hyperspeed >= 10)
				formattext textname = text "%c, %d" c = <text> d = (($cheat_hyperspeed - 9) * -1)
			else
				formattext textname = text "%c, %d" c = <text> d = ($cheat_hyperspeed)
			endif
		else
			if ($cheat_hyperspeed < 0)
				change \{cheat_hyperspeed = 0}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [2].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_hyperspeed_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (350.0, 270.0) dims = <dims> id = cheat_hyperspeed_text}}
			{pad_choose toggle_hyperspeed params = {cheat = cheat_hyperspeed id = cheat_hyperspeed_text index = 2}}
		]
	}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<unlock_cheat_performancemode> > 0)
		dims = (332.0, 30.0)
		if ($cheat_performancemode = 1)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [1].name_text)
		else
			if ($cheat_performancemode < 0)
				change \{cheat_performancemode = 2}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [1].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_performancemode_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 296.0) dims = <dims> id = cheat_performancemode_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_performancemode id = cheat_performancemode_text index = 1}}
		]
	}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<unlock_cheat_easyexpert> > 0)
		dims = (246.0, 30.0)
		if ($cheat_easyexpert = 1)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [4].name_text)
		else
			if ($cheat_easyexpert < 0)
				change \{cheat_easyexpert = 2}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [4].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_easyexpert_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 321.0) dims = <dims> id = cheat_easyexpert_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_easyexpert id = cheat_easyexpert_text index = 4}}
		]
	}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<unlock_cheat_precisionmode> > 0)
		dims = (283.0, 30.0)
		if ($cheat_precisionmode = 1)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [5].name_text)
		else
			if ($cheat_precisionmode < 0)
				change \{cheat_precisionmode = 2}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [5].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_precisionmode_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 348.0) dims = <dims> id = cheat_precisionmode_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_precisionmode id = cheat_precisionmode_text index = 5}}
		]
	}
	<text> = 'locked'
	dims = (100.0, 30.0)
	if (<0x3c573231> > 0)
		dims = (266.0, 30.0)
		if ($cheat_largegems = 1)
			formattext textname = text '%c : ON' c = ($guitar_hero_cheats [6].name_text)
		else
			if ($cheat_largegems < 0)

				change \{cheat_largegems = 2}
			endif
			formattext textname = text '%c : OFF' c = ($guitar_hero_cheats [6].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = 0xa0d1cdd5
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 377.0) dims = <dims> id = 0xa0d1cdd5}}
			{pad_choose toggle_cheat params = {cheat = cheat_largegems id = 0xa0d1cdd5 index = 6}}
		]
	}
	createscreenelement {
		<text_params>
		text = 'enter cheat'
		id = cheat_entercheat_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 404.0) dims = (196.0, 34.0) id = cheat_entercheat_text}}
			{pad_choose enter_new_cheat}
		]
	}
	clean_up_user_control_helpers
	add_user_control_helper \{text = 'SELECT'
		button = green
		z = 100}
	add_user_control_helper \{text = 'BACK'
		button = red
		z = 100}
	add_user_control_helper \{text = 'UP/DOWN'
		button = strumbar
		z = 100}
	change \{entering_cheat = 0}
	change \{guitar_hero_cheats_completed = [
			0
			0
			0
			0
			0
			0
			0
			0
			0
		]}
endscript

script create_cheats_menu 
	if ((IsPS2) || IsNGC)
		create_cheats_menu_PSWii <...>
		return
	endif
	disable_pause
	if ($entering_cheat = 0)
		createscreenelement \{type = containerelement
			id = cheats_container
			parent = root_window
			pos = (0.0, 0.0)}
		create_menu_backdrop \{texture = venue_bg}
		displaysprite \{parent = cheats_container
			tex = options_video_poster
			rot_angle = 1
			pos = (640.0, 215.0)
			dims = (820.0, 440.0)
			just = [
				center
				center
			]
			z = 1
			font = $video_settings_menu_font}
		displaytext \{parent = cheats_container
			pos = (910.0, 402.0)
			just = [
				right
				center
			]
			text = "CHEATS"
			scale = 1.5
			rgba = [
				240
				235
				240
				255
			]
			font = text_a5
			noshadow}
		displaysprite \{parent = cheats_container
			tex = tape_h_03
			pos = (270.0, 185.0)
			rot_angle = -50
			scale = 0.5
			z = 20}
		displaysprite {
			parent = <id>
			tex = tape_h_03
			pos = (5.0, 5.0)
			rgba = [0 0 0 128]
			z = 19
		}
		displaysprite \{parent = cheats_container
			tex = tape_h_04
			pos = (930.0, 380.0)
			rot_angle = -120
			scale = 0.5
			z = 20}
		displaysprite {
			parent = <id>
			tex = tape_h_04
			pos = (5.0, 5.0)
			rgba = [0 0 0 128]
			z = 19
		}
		createscreenelement \{type = containerelement
			id = cheats_warning_container
			parent = root_window
			alpha = 0
			scale = 0.5
			pos = (640.0, 540.0)}
		displaysprite \{parent = cheats_warning_container
			id = cheats_warning
			tex = control_pill_body
			pos = (0.0, 0.0)
			just = [
				center
				center
			]
			rgba = [
				96
				0
				0
				255
			]
			z = 100}
		getplatform
		switch <platform>
			case xenon
			warning = "WARNING: Some active cheats do not work in career modes and online."
			warning_cont = "Also, achievement unlocking and leaderboard posts are turned off."
			case ps3
			warning = "WARNING: Some active cheats do not work in career modes and online."
			warning_cont = "Also, leaderboard posts are turned off."
			case ps2
			warning = "WARNING: Some active cheats do not work in career modes."
			warning_cont = ""
			default
			warning = "WARNING: Some active cheats do not work in career modes and online."
			warning_cont = "Also, leaderboard posts are turned off."
		endswitch
		formattext textname = warning_text "%a %b" a = <warning> b = <warning_cont>
		createscreenelement {
			type = textblockelement
			id = first_warning
			parent = cheats_warning_container
			font = text_a6
			scale = 1
			text = <warning_text>
			rgba = [186 105 0 255]
			just = [center center]
			z_priority = 101.0
			pos = (0.0, 0.0)
			dims = (1400.0, 100.0)
			allow_expansion
		}
		getscreenelementdims \{id = first_warning}
		bg_dims = (<width> * (1.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
		cheats_warning :setprops dims = <bg_dims>
		displaysprite {
			parent = cheats_warning_container
			tex = control_pill_end
			pos = (-1 * <width> * (0.5, 0.0))
			rgba = [96 0 0 255]
			dims = ((64.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
			just = [right center]
			flip_v
			z = 100
		}
		displaysprite {
			parent = cheats_warning_container
			tex = control_pill_end
			pos = (<width> * (0.5, 0.0))
			rgba = [96 0 0 255]
			dims = ((64.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
			just = [left center]
			z = 100
		}
		cheats_create_guitar
	endif
	show_cheat_warning
	displaysprite \{parent = cheats_container
		id = cheats_hilite
		tex = white
		rgba = [
			40
			60
			110
			255
		]
		rot_angle = 1
		pos = (349.0, 382.0)
		dims = (230.0, 30.0)
		z = 2}
	new_menu \{scrollid = cheats_scroll
		vmenuid = cheats_vmenu
		menu_pos = (360.0, 191.0)
		text_left
		spacing = -12
		rot_angle = 1}
	text_params = {parent = cheats_vmenu type = textelement font = text_a3 rgba = [255 245 225 255] z_priority = 50 rot_angle = 0 scale = 1}
	text_params2 = {parent = cheats_vmenu type = textelement font = text_a5 rgba = [255 245 225 255] z_priority = 50 rot_angle = 0 scale = 0.63}
	getglobaltags \{user_options}
	<text> = "locked"
	if (<unlock_cheat_nofail> > 0)
		if ($cheat_nofail = 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [3].name_text)
		else
			if ($cheat_nofail < 0)
				change \{cheat_nofail = 2}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [3].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_nofail_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 206.0) id = cheat_nofail_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_nofail id = cheat_nofail_text index = 3}}
		]
	}
	<text> = "locked"
	if (<unlock_cheat_airguitar> > 0)
		if ($cheat_airguitar = 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [0].name_text)
		else
			if ($cheat_airguitar < 0)
				change \{cheat_airguitar = 2}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [0].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_airguitar_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 229.0) id = cheat_airguitar_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_airguitar id = cheat_airguitar_text index = 0}}
		]
	}
	<text> = "locked"
	if (<unlock_cheat_hyperspeed> > 0)
		if ($cheat_hyperspeed > 0)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [2].name_text)
			if ($cheat_hyperspeed >= 10)
				formattext textname = text "%c, %d" c = <text> d = (($cheat_hyperspeed - 9) * -1)
			else
				formattext textname = text "%c, %d" c = <text> d = ($cheat_hyperspeed)
			endif
		else
			if ($cheat_hyperspeed < 0)
				change \{cheat_hyperspeed = 0}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [2].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_hyperspeed_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 252.0) id = cheat_hyperspeed_text}}
			{pad_choose toggle_hyperspeed params = {cheat = cheat_hyperspeed id = cheat_hyperspeed_text index = 2}}
		]
	}
	<text> = "locked"
	if (<unlock_cheat_performancemode> > 0)
		if ($cheat_performancemode = 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [1].name_text)
		else
			if ($cheat_performancemode < 0)
				change \{cheat_performancemode = 2}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [1].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_performancemode_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 275.0) id = cheat_performancemode_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_performancemode id = cheat_performancemode_text index = 1}}
		]
	}
	<text> = "locked"
	if (<unlock_cheat_easyexpert> > 0)
		if ($cheat_easyexpert = 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [4].name_text)
		else
			if ($cheat_easyexpert < 0)
				change \{cheat_easyexpert = 2}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [4].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_easyexpert_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 298.0) id = cheat_easyexpert_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_easyexpert id = cheat_easyexpert_text index = 4}}
		]
	}
	<text> = "locked"
	if (<unlock_cheat_precisionmode> > 0)
		if ($cheat_precisionmode = 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [5].name_text)
		else
			if ($cheat_precisionmode < 0)
				change \{cheat_precisionmode = 2}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [5].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_precisionmode_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 321.0) id = cheat_precisionmode_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_precisionmode id = cheat_precisionmode_text index = 5}}
		]
	}
	<text> = "locked"
	if (<unlock_cheat_bretmichaels> > 0)
		if ($cheat_bretmichaels = 1)
			formattext textname = text "%c : ON" c = ($guitar_hero_cheats [6].name_text)
		else
			if ($cheat_bretmichaels < 0)
				change \{cheat_bretmichaels = 2}
			endif
			formattext textname = text "%c : OFF" c = ($guitar_hero_cheats [6].name_text)
		endif
	endif
	createscreenelement {
		<text_params2>
		text = <text>
		id = cheat_bretmichaels_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 344.0) id = cheat_bretmichaels_text}}
			{pad_choose toggle_cheat params = {cheat = cheat_bretmichaels id = cheat_bretmichaels_text index = 6}}
		]
	}
	createscreenelement {
		<text_params>
		text = "enter cheat"
		id = cheat_entercheat_text
		event_handlers = [
			{focus cheats_morph_hilite params = {pos = (349.0, 375.0) id = cheat_entercheat_text}}
			{pad_choose enter_new_cheat}
		]
	}
	clean_up_user_control_helpers
	change \{user_control_pill_text_color = [
			0
			0
			0
			255
		]}
	change \{user_control_pill_color = [
			180
			180
			180
			255
		]}
	add_user_control_helper \{text = "SELECT"
		button = green
		z = 100}
	add_user_control_helper \{text = "BACK"
		button = red
		z = 100}
	add_user_control_helper \{text = "UP/DOWN"
		button = strumbar
		z = 100}
	change \{entering_cheat = 0}
	change \{guitar_hero_cheats_completed = [
			0
			0
			0
			0
			0
			0
			0
			0
			0
		]}
endscript

script toggle_hyperspeed 
	GetGlobalTags \{user_options}
	if ($<cheat> >= 0)
		if ($<cheat> = 14)
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
			if ($<new_value> >= 10)
				formattext textname = text "%c, %d" c = <text> d = ((<new_value> - 9) * -1)
			else
				formattext textname = text "%c, %d" c = <text> d = (<new_value>)
			endif
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