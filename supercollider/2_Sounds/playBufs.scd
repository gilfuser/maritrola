(
Ndef(\beatz, { | amp=1, t_trig=1, loop=1 |
	var sig, buf, pitch, index;
	buf = Select.kr( ~selectBeat.kr, q.beatz );
	pitch = ~pitchB.kr;
	sig = PlayBuf.ar(
		2, buf, BufRateScale.kr(buf) * pitch, t_trig, loop: 1
	) * ~ampB.kr;
}).play;
);

//
/*
Ndef(\beatz).stop;
~selectLoop.getSynchronous;
~button.getnSynchronous;
q.scratch.size
*/

(
Ndef(\loop, { | amp=1 |
	var sig, buf, bufdur, bufframes, playbackRatio, needle, scratch, finger, xFader, pitch;
	buf = Select.kr( ~selectLoop.kr, q.loopz );
	bufdur = BufDur.kr(buf);
	bufframes = BufFrames.kr(buf);
	playbackRatio = BufRateScale.kr(buf);
	xFader = ~xFader.kr;
	pitch = ~pitchL.kr;
	scratch = (~scratch.kr + (bufframes * 0.5).ceil).wrap(0, bufframes).linlin(0, bufframes, 0.01, 100).lag2(0.1); // change to big encoder
	finger = Trig1.kr(Changed.kr(~scratch.kr), 0.1).lag2(0.05);
	needle = LFSaw.ar(
		bufdur.reciprocal * pitch * ( 1 - finger ), add: scratch
	).range(0, bufframes);
	sig = BufRd.ar(
		2, buf, needle, 1
	) * xFader * ~ampL.kr;
	// sig = BufRd.ar( 2, buf, Phasor.ar(0, playbackRatio * 1, 0, bufframes), loop: 1 ) /** amp*/;

}).play;
);
/*
Ndef(\loop).stop;
*/
// 0.dbamp