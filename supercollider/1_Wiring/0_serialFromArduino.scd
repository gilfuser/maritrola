q = q ? ();
/*
SerialPort.devices;
SerialPort.closeAll;
30.do {q.teensy.read.postln};
~inputs.getnSynchronous;
*/

{
	(
		{
			q.ardu = SerialPort("/dev/ttyACM1", 38400, crtscts: true);
			CmdPeriod.doOnce({ q.ardu.close});
			s.sync;
			1.wait;
		}.fork;
		{
			q.teensy = SerialPort("/dev/ttyACM0", 38400, crtscts: true);
			CmdPeriod.doOnce({ q.teensy.close});
			s.sync;
			// q.teensy.put(110.rand);
		}.fork;
	);
	4.wait;
	(
		{
			var func = { | xFader, selectBeat, selectLoop, ampB, ampL, pitchB, pitchL, data = #[ 1, 1, 1, 1, 1, 1, 1 ] |
				data = [ xFader, selectBeat, selectLoop, ampB, ampL, pitchB, pitchL ];

				// interface the values with busses
				~xFader.set( xFader.linlin( 1, 1022, 0, 2).fold(0, 1).linexp(0, 1, 1, 0.0000000001 ) * (-1) + 1
				);
				~selectBeat.set( selectBeat.wrap(0, (q.beatz.size * 2)).round(2)/2
				);
				~selectLoop.set( selectLoop.wrap(0, (q.loopz.size * 2)).round(2)/2
				);
				~ampB.set( ampB.lincurve(0, 255, 0, 1, 5.5)
				);
				~ampL.set( ampL.lincurve(0, 255, 0, 1, 5.5)
				);
				~pitchB.set( pitchB.lincurve(1, 1022, 0.5, 2, 6.9)
				);
				~pitchL.set( pitchL.lincurve(1, 1022, 0.5, 2, 6.9)
				);
				/*~inputs.setAt;
				~inputs.setAt;
				~inputs.setAt;
				~inputs.setAt;
				~inputs.setAt;
				~inputs.setAt;
				~inputs.setAt;*/
				// MFdef(\teensy).value(~inputs);
			};

			var arr = [ 254, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 255 ];  //protocol
			var arr2 = arr.copy;
			var index = 0;

			var match = { |byte|

				if ( arr[ index ].isNil or: { arr[ index ] == byte },
					{ arr2[ index ] = byte;
						index = index + 1;
						if ( index >= arr.size,
							{
								func.value(
									arr2[1]<<8 + arr2[2],
									arr2[3],
									arr2[4],
									arr2[5],
									arr2[6],
									arr2[7]<<8 + arr2[8],
									arr2[9]<<8 + arr2[10]
								);
								index= 0;
						});
					},
					{
						index= 0;
					};
				);
			};
			var read = Routine.run({
				inf.do{
					match.value(q.teensy.read);
				};
			});
		}.fork;

		q.encoder = Routine({
			var byte, str, res;
			inf.do{|i|
				str = "";
				while( { byte = q.ardu.read; byte !=13 }, {
					str = str++byte.asAscii;
				});
				if(q.ardu.read==10, {
					res = str.asInteger;
					~scratch.set(res);
					// ~inputs[7].set(res);
					MFdef(\arduino).value(res);
				}, {
					"serial read error from Arduino".warn;
				});
			};
		}).play;
	);

	MFdef(\teensy).add(\post, { |msg| msg.postln});
	MFdef(\arduino).add(\post, { |msg| msg.postln});


}.fork;
"receive inputs from Arduino - connect them to control busses - LOADED".postString;
/*
q.teensy.close;
MFdef(\teensy).free;
MFdef(\teensy).clear;


/*
MFdef(\teensy).remove(\post);
MFdef(\arduino).remove(\post);
*/

