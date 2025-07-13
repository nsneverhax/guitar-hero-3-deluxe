random_songlist = [
	$dx_songlist
	$download_songlist
]
dx_songlist = [
	anarchyintheuk
	avalancha
	Barracuda
	beforeiforget
	bellyofashark
	blackmagicwoman
	blacksunshine
	bossslash
	bosstom
	bossdevil
	bullsonparade
	cantbesaved
	cherubrock
	citiesonflame
	cliffsofdover
	closer
	CultOfPersonality
	dontholdback
	downndirty
	evenflow
	fcpremix
	generationrock
	gothatfar
	helicopter
	HitMeWithYourBestShot
	hierkommtalex
	holidayincambodia
	imintheband
	Impulse
	inlove
	koolthing
	knightsofcydonia
	lagrange
	LayDown
	mauvaisgarcon
	metalheavylady
	minuscelsius
	mississippiqueen
	MissMurder
	monsters
	mycurse
	mynameisjonas
	nothingformehere
	numberofthebeast
	ONE
	paintitblack
	Paranoid
	prayeroftherefugee
	pridenjoy
	radiosong
	RainingBlood
	reptilia
	rocknrollallnite
	rockulikeahurricane
	ruby
	sabotage
	sameoldsonganddance
	schoolsout
	shebangsadrum
	slowride
	stricken
	storyofmylife
	suckmykiss
	sunshineofyourlove
	talkdirtytome
	takethislife
	themetal
	theseeker
	thewayitends
	threesandsevens
	thrufireandflames
	welcometothejungle
	whenyouwereyoung
]

script dx_get_random_song 
	if ($current_tab = tab_downloads)
		if NOT GlobalExists \{Name = download_songlist
			Type = Array}
			Printf "-- dx_get_random_song -- No downloaded songs detected, aborting random selection"
			return
		endif
		this_songlist = $download_songlist
	else
		this_songlist = $dx_songlist ; TODO: have a seperate list for Bonus songs
	endif
	dx_get_random_song_select songlist = <this_songlist>
	Change current_song = <random_song>
	start_flow_manager \{flow_state = quickplay_play_song_fs}
	destroy_setlist_menu
	create_loading_screen
	quickplay_start_song
endscript

script dx_get_random_song_select \{songlist = none}
	if NOT GotParam songlist
		return
	endif
	first_song_index = (-1)
	last_song_index = (-1)
	array_entry = 0
	GetArraySize {<songlist>}
	begin
	song_checksum = (<songlist> [<array_entry>])
	get_song_struct Song = <song_checksum>
	if ((<song_struct>.version) = gh3)
		if (<first_song_index> = (-1))
			<first_song_index> = <array_entry>
		endif
	endif
	<array_entry> = (<array_entry> + 1)
	repeat <array_Size>
	<last_song_index> = (<array_entry> - 1)
	GetRandomValue Name = random_value Integer A = <first_song_index> B = <last_song_index>
	return random_song = (<songlist> [<random_value>])
endscript