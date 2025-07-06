script is_ps2
     if NOT ((IsWinPort) || (IsMacPort) || (IsPS3) || (IsNGC) || (IsXENON))
          return TRUE
     endif
     return FALSE
endscript