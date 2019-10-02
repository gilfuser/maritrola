q = q ? ();
s.waitForBoot{
	2.wait;
	s.initTree;
	2.wait;
	"0_Globals/0_loadGlobalUtils.scd".loadRelative;
	2.wait;
	"1_Wiring/busses*".loadRelative;
	1.wait;
	"2_Sounds/_Samples*".loadRelative;
	10.wait;
	"1_Wiring/0_serialFromArduino*".loadRelative;
	10.wait;
	// "1_Wiring/connect-input-to-busses*".loadRelative;
	// 2.wait;
	"2_Sounds/playBufs*".loadRelative;
	/*
	MFdef(\teensy).remove(\post);
	MFdef(\arduino).remove(\post);
	*/
};
