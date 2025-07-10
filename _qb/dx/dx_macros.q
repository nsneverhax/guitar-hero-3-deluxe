script is_ps2
     if NOT ((IsWinPort) || (IsMacPort) || (IsPS3) || (IsNGC) || (IsXENON))
          return TRUE
     endif
     return FALSE
endscript

script dx_printf \{Text = "NONE"}
	if ($enable_button_cheats = 0)
		return
	endif
	if NOT ScreenElementExists \{Id = DX_PRINTF_ELEMENT}
		CreateScreenElement {
			Type = TextElement
			Id = DX_PRINTF_ELEMENT
			PARENT = root_window
			Text = ""
			font = Debug
			Pos = (80.0, 20.0)
               just = [LEFT Top]
               Dims = (200.0, 0)
               allow_expansion
			Scale = 1.0
               Shadow
               shadow_offs = (2.0, 2.0)
               shadow_rgba = [0 0 0 255]
			z_priority = 999999
		}
	endif
     DX_PRINTF_ELEMENT :SetProps Text = <Text>
endscript
