Ndef(\processInput).kr(8);
(
Ndef(\processInput, {
	var beatz = q.beatz.size - 1;
	var loopz = q.scratch.size - 1;
	[
		Out.kr( ~xFader, ~inputs.subBus(0).kr
		),  /*smaller decimal = faster cut*/
		Out.kr( ~selectBeat, ~inputs.subBus(1).kr
		),
		Out.kr( ~selectLoop, ~inputs.subBus(2).kr // encoder
		),
		/*Out.kr( ~button, ~inputs.subBus(3).kr
		),*/
        Out.kr( ~ampB, ~inputs.subBus(3).kr
		),
        Out.kr( ~ampL, ~inputs.subBus(4).kr
		),
		Out.kr( ~pitchB, ~inputs.subBus(5).kr
		),
		Out.kr( ~pitchL, ~inputs.subBus(6).kr
		),
		Out.kr( ~scratch, ~inputs.subBus(7).kr
		)
    ];
});
);

/*
Ndef(\processInput).clear;
*/
"Process Input Data - LOADED".postString
/*
x = Array.fill(32, { arg i; i })
x.linlin(0, 32, 1, 0).lincurve(0, 1, 0, 1, -20).plot
*/

// { Line.ar(988, 2024, 0.1023).linlin(988, 2024, 0, 2).fold(0, 1).linexp(0, 1, 1, 0.000000001) * (-1) + 1 }.plot(0.1023);
