~inputs = ~inputs ? Bus.control(s, 8); // number of inputs

~xFader = ~xFader ? Bus.control.set(0.5); // fader
~selectBeat = ~selectBeat ? Bus.control.set(40.rand + 128); // encoder
~selectLoop = ~selectLoop ? Bus.control.set(40.rand + 128); // encoder
// ~button = ~button ? Bus.control.set(1); // button
~ampB = ~ampB ? Bus.control.set(1); // fader
~ampL = ~ampL ? Bus.control.set(1); // fader
~pitchB = ~pitchB ? Bus.control.set(1); // fader
~pitchL = ~pitchL ? Bus.control.set(1); // fader
~scratch = ~scratch ? Bus.control.set(1000); // encoder

q.busses = [ "xFader", "selectBeat", "selectLoop", /*"button", */"ampB", "ampL", "pitchB", "pitchL", "scratch"];

"Busses to carry the inputs:".postln;
q.busses.printAll;
"".postln