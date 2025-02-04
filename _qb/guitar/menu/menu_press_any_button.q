script create_gh3dx_icon_toast 
	CreateScreenElement {
		Type = TextBlockElement
		PARENT = pab_container
		font = text_a6
		Text = "DELUXE"
		Dims = (500.0, 200.0)
		Pos = (619.0, 350.0)
		just = [LEFT Top]
		internal_just = [Center Top]
		rgba = [220 220 220 255]
		Scale = 0.9
		Shadow
        shadow_offs = (3.0, 3.0)
        shadow_rgba = [110 20 80 250]
	}
endscript

script create_gh3dx_version_toast 
	FormatText TextName = Text "%v" V = ($gh3dx_version)
	if ((IsPS2) || (IsNGC))
		Pos = (730.0, 680.0)
	else
		Pos = (870.0, 680.0)
	endif
	CreateScreenElement {
		Type = TextBlockElement
		PARENT = pab_container
		font = text_a6
		Text = <Text>
		Dims = (750.0, 400.0)
		Pos = <Pos>
		just = [LEFT Top]
		internal_just = [Center Top]
		rgba = [220 220 220 255]
		Scale = 0.6
		Shadow
        shadow_offs = (3.0, 3.0)
        shadow_rgba = [110 20 80 250]
	}
endscript

script menu_press_any_button_create_obvious_text 
	create_gh3dx_icon_toast
	create_gh3dx_version_toast
	Text = "PRESS ANY BUTTON TO ROCK..."
	text_pos = (670.0, 425.0)
	CreateScreenElement {
		Type = TextBlockElement
		PARENT = pab_container
		font = text_a6
		Text = <Text>
		Dims = (500.0, 200.0)
		Pos = <text_pos>
		just = [LEFT Top]
		internal_just = [Center Top]
		rgba = [215 120 40 255]
		Scale = 0.7
		allow_expansion
	}
endscript
