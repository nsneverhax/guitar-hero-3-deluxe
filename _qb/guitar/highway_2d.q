script generate_move_table \{interval = 60
		pos_start_orig = 0}
	0x33061fe2
	MathPow (<interval> / 60.0) Exp = 2
	Y = 720
	pos_add = -720
	pos_sub = 1.0
	pos_sub_add = (0.0004386 / <pow>)
	0xaea75032 = (1.0 / <interval>)
	Size = (<interval> * 2.5)
	CastToInteger \{Size}
	CreateIndexArray <Size>
	I = 0
	begin
	<Y> = (<Y> + (<pos_add> * <0xaea75032>))
	<pos_add> = (<pos_add> * <pos_sub>)
	<pos_sub> = (<pos_sub> - <pos_sub_add>)
	Element = (<Y> * 1000.0)
	CastToInteger \{Element}
	SetArrayElement ArrayName = index_array Index = <I> NewValue = <Element>
	if (<Y> <= <pos_start_orig> || <pos_add> >= -0.002)
		break
	endif
	Increment \{I}
	if (<I> >= <Size>)
		break
	endif
	repeat
	0xdabcdb23 <...> 'generate_move_table'
	if (<I> >= <Size>)
		begin
		Printf \{'overshot move table index!!!!!!!!!!!!!'}
		repeat 10
	endif
	return moveTable = <index_array>
endscript