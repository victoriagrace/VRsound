import("stdfaust.lib");

modulate = hslider("modulate",1,0,1,0.001): si.smoo;
//freq=ba.midikey2hz(note);

process = (pad / 4.4)*moving*amp; 


moving = biscale(1, 1+move, os.oscp(8,0));
move = hslider("move",1,0,.7,0.001): si.smoo;
amp = hslider("amp",1,.2,1,0.001): si.smoo;


fmosc(n, car, mod, idx) = 
	os.osc(freq*car + freq*mod*idx*os.osc(freq*mod))
with {
freq= ba.midikey2hz(n);	
};

scale(mn, mx, in) = mn + in * (mx - mn);

biscale(mn, mx, in) = mn + (0.5 * (1 + in)) * (mx - mn);

halfmod = (modulate < 0.5) * modulate + (modulate > 0.5) : si.smooth(ba.tau2pole(0.2));

detune = scale(1, 1.14159, 1 - halfmod);

index = scale(1, 3, 1 - modulate);

lfo(rate,phs) = biscale(0, 1, os.oscp(rate,phs));

pad = 
fmosc(53,1,detune,index) * lfo(1/11,0) +
fmosc(60,1,detune,index) * lfo(1/13,ma.PI/2) +
fmosc(69,1,detune,index) * lfo(1/15,ma.PI/4) +
fmosc(41,1,detune,index) * lfo(1/9,ma.PI/5)
;
