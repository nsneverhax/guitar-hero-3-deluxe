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

script GuitarEvent_StarSequenceBonus 
	if ($is_attract_mode = 1)
		return
	endif
	Change StructureName = <player_status> sp_phrases_hit = ($<player_status>.sp_phrases_hit + 1)
	SoundEvent \{Event = Star_Power_Awarded_SFX}
	FormatText ChecksumName = container_id 'gem_container%p' P = ($<player_status>.Text) AddToStringLookup = TRUE
	GetArraySize \{$gem_colors}
	gem_count = 0
	begin
	<note> = ($<Song> [<array_entry>] [(<gem_count> + 1)])
	if (<note> > 0)
		Color = ($gem_colors [<gem_count>])
		if ($<player_status>.lefthanded_button_ups = 1)
			<pos2d> = ($button_up_models.<Color>.left_pos_2d)
			<Angle> = ($button_models.<Color>.Angle)
		else
			<pos2d> = ($button_up_models.<Color>.pos_2d)
			<Angle> = ($button_models.<Color>.left_angle)
		endif
		FormatText ChecksumName = Name 'big_bolt%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		CreateScreenElement {
			Type = SpriteElement
			Id = <Name>
			PARENT = <container_id>
			Material = sys_Big_Bolt01_sys_Big_Bolt01
			rgba = [255 255 255 255]
			Pos = <pos2d>
			Rot_Angle = <Angle>
			Scale = $star_power_bolt_scale
			just = [Center Bottom]
			z_priority = 6
		}
		FormatText ChecksumName = fx_id 'big_bolt_particle%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx_id>
		<particle_pos> = (<pos2d> - (0.0, 0.0))
		Create2DParticleSystem {
			Id = <fx_id>
			Pos = <particle_pos>
			z_priority = 8.0
			Material = sys_Particle_Star01_sys_Particle_Star01
			PARENT = <container_id>
			start_color = [0 128 255 255]
			end_color = [0 128 128 0]
			start_scale = (0.55, 0.55)
			end_scale = (0.25, 0.25)
			start_angle_spread = 360.0
			min_rotation = -120.0
			max_rotation = 240.0
			emit_start_radius = 0.0
			emit_radius = 2.0
			Emit_Rate = 0.04
			emit_dir = 0.0
			emit_spread = 44.0
			Velocity = 24.0
			Friction = (0.0, 66.0)
			Time = 2.0
		}
		FormatText ChecksumName = fx2_id 'big_bolt_particle2%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		<particle_pos> = (<pos2d> - (0.0, 0.0))
		Create2DParticleSystem {
			Id = <fx2_id>
			Pos = <particle_pos>
			z_priority = 8.0
			Material = sys_Particle_Star02_sys_Particle_Star02
			PARENT = <container_id>
			start_color = [255 255 255 255]
			end_color = [128 128 128 0]
			start_scale = (0.5, 0.5)
			end_scale = (0.25, 0.25)
			start_angle_spread = 360.0
			min_rotation = -120.0
			max_rotation = 508.0
			emit_start_radius = 0.0
			emit_radius = 2.0
			Emit_Rate = 0.04
			emit_dir = 0.0
			emit_spread = 28.0
			Velocity = 22.0
			Friction = (0.0, 55.0)
			Time = 2.0
		}
		FormatText ChecksumName = fx3_id 'big_bolt_particle3%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		<particle_pos> = (<pos2d> - (0.0, 15.0))
		Create2DParticleSystem {
			Id = <fx3_id>
			Pos = <particle_pos>
			z_priority = 8.0
			Material = sys_Particle_Spark01_sys_Particle_Spark01
			PARENT = <container_id>
			start_color = [0 255 255 255]
			end_color = [0 255 255 0]
			start_scale = (1.5, 1.5)
			end_scale = (0.25, 0.25)
			start_angle_spread = 360.0
			min_rotation = -500.0
			max_rotation = 500.0
			emit_start_radius = 0.0
			emit_radius = 2.0
			Emit_Rate = 0.04
			emit_dir = 0.0
			emit_spread = 180.0
			Velocity = 12.0
			Friction = (0.0, 0.0)
			Time = 1.0
		}
	endif
	gem_count = (<gem_count> + 1)
	repeat <array_Size>
	Wait \{$star_power_bolt_time
		Seconds}
	gem_count = 0
	begin
	<note> = ($<Song> [<array_entry>] [(<gem_count> + 1)])
	if (<note> > 0)
		FormatText ChecksumName = Name 'big_bolt%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		DestroyScreenElement Id = <Name>
		FormatText ChecksumName = fx_id 'big_bolt_particle%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx_id>
		FormatText ChecksumName = fx2_id 'big_bolt_particle2%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx2_id>
		FormatText ChecksumName = fx3_id 'big_bolt_particle3%p%e' P = ($<player_status>.Text) E = <gem_count> AddToStringLookup = TRUE
		Destroy2DParticleSystem Id = <fx3_id>
		Wait \{1
			GameFrame}
	endif
	gem_count = (<gem_count> + 1)
	repeat <array_Size>
endscript