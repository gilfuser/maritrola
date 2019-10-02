// sound file load mechanism
q=q?();
// have all the samples stored in this Dir !!
{
	q.mainSampDir = (thisProcess.nowExecutingPath.dirname +/+ "Samples").pathMatch.first;
	0.1.wait;

	// single function to load folders of sounds into Buffer Arrays;
	// supports a number of sample formats
	q.loadSamples = { |q, dir, mainDir|
		var formaz = ["aif*", "wav", "AIF*", "WAV"];
		var myDir = (mainDir ? q.mainSampDir) +/+ dir;
		var mySFs = formaz.collect{|format|
			(myDir +/+ "*." ++ format).pathMatch.postcln
		}.flatten(1).sort;
		postf("\n\n>>>>> about to load the following % files: \n\n", mySFs.size);
		mySFs.collect{|f|f.basename}.printAll;
		mySFs.postln.collect { |path, i|
			Buffer.read(s, path);
		};
	};

	0.1.wait;
	// use like this!
	q.beatz = q.loadSamples("BEATS");
	q.loopz = q.loadSamples("scratch-this");
	s.sync;
	1.wait;

	q.beatz.[0].play;
	q.loopz.[9].play;
	1.wait;
	"SAMPLES - LOADED".postString;
}.fork;



/*
Ndef(\playBuf, { | amp=1, buf=0, dur=1, rate=1, start=1, trig=0, ggate=0, loop=1, freq, atk =1, sustain=1, rel=1, pitRat=1, pitDis=0, timeDis=0.1, janela = 0.2, scratch=0.1, djay=0.2, finger=0.1 |
	var sig, env;
	rate={LFNoise0.kr(djay+(finger*2),scratch)};
	rate = LFNoise0.kr(djay, rate, 1).lag2(finger);
	env = EnvGen.kr(Env([0,1,1,0],[atk,sustain,rel],[\sin,0,-4],2,1),ggate, doneAction:2);
	rate = rate*env;
	start = {Rand(1, BufFrames.kr(buf))};
	sig = PlayBuf.ar( 2, buf, BufRateScale.kr(buf)*rate, trig, start, loop);
	sig = PitchShift.ar(sig, janela, pitRat.lag2(0.2), pitDis, timeDis);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
});
*/
