script hit_note_fx 
	NoteFX <...>
	Wait \{100
		0x8d07dc15}
	Destroy2DParticleSystem Id = <particle_id> Kill_when_empty
	Wait \{167
		0x8d07dc15}
	if ScreenElementExists Id = <fx_id>
		DestroyScreenElement Id = <fx_id>
	endif
endscript