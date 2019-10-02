q = q ? ();
/*
SerialPort.devices;
SerialPort.closeAll;
Tdef(\arduRecv).free;
30.do {q.port.read.asAscii.postln};
~inputs.getnSynchronous;
*/
{
	// q.arduIn = 2; // number of inputs
	{ q.port = SerialPort("/dev/ttyACM0", 57600, crtscts: true); CmdPeriod.doOnce({ q.port.close}); s.sync; }.fork;
	0.2.wait;
	(
		Tdef(\arduRecv, {
			// var headers = (248 .. ( 248 - (q.arduIn - 1) ) ).invert; // CHANGE TO 255
			// var next = 0;
			var byteEnc, strEnc, encoder, byteFad, strFad, resFad, fader, byteBtn, strBtn, resBtn, button;
			// headers.do{ |head i|
			//
			// }
			999999.do { |i|

				switch ( q.port.read,
					241, {
						strBtn = "";
						while( { byteBtn = q.port.read; byteBtn !=242 }, {
							strBtn = strBtn ++ byteBtn.asAscii;
						});
						button= strBtn.asInteger;
						// button.postln;
						~inputs.setAt(7, button);
					},
					243, {
						strBtn = "";
						while( { byteBtn = q.port.read; byteBtn !=244 }, {
							strBtn = strBtn ++ byteBtn.asAscii;
						});
						button= strBtn.asInteger;
						// button.postln;
						~inputs.setAt(7, button);
					},
					245, {
						strEnc = "";
						while( { byteEnc = q.port.read; byteEnc !=246 }, {
							strEnc = strEnc ++ byteEnc.asAscii;
						});
						encoder= strEnc.asInteger;
						~inputs.setAt(2, encoder);
					},
					247,
					{
						strFad = "";
						while( { byteFad = q.port.read; byteFad !=248 }, {
							strFad = strFad ++ byteFad.asAscii;
						});
						fader= strFad.asInteger;
						~inputs.setAt(5, fader);
					}
				);
				MFdef(\arduino).value(~inputs.getnSynchronous);
			};
		}).play;
	);

	{ Tdef( \arduRecv ).gui }.defer;
	/*
	Tdef(\arduRecv).stop;
	Tdef(\arduRecv).clear;
	q.port.close;
	MFdef(\arduino).free;
	MFdef(\arduino).clear;
	*/
	0.2.wait;

	MFdef(\arduino).add(\post, { |msg| msg.postln});
	/*
	MFdef(\arduino).remove(\post);
	*/
	"receive inputs from Arduino - connect them to control busses - LOADED".postString;
}.fork


/*
// ~inputs = ~inputs ?? Bus.control(s, q.arduIn.value);

headers[next] , {
str = "";
while( { byte = q.port.read; byte != headers[ next + 1 % headers.size ] }, {
str= str++byte.asAscii;
});
res= str.asInteger;
~inputs.setAt(next, res);
next = next + 1 % headers.size }
*/