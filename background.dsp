import("stdfaust.lib");

modulate = hslider("wellness",1,0,1,0.001): si.smoo;
//freq=ba.midikey2hz(note);

process = ((pad + bass_move) / 6)*amt*amp_mod; 

amt = scale(.1,1, move);

//amp_mod = (1 - move)*1 + move*biscale(0, 1, os.oscp(8,0));

amp_mod = 0.5 + move * 0.5 * os.oscp(8,0);

move = hslider("movement",0,0,1,0.001): si.smoo;



fmosc(n, car, mod, idx) = 
	os.osc(freq*car + freq*mod*idx*os.osc(freq*mod))
with {
freq= ba.midikey2hz(n);	
};

scale(mn, mx, in) = mn + in * (mx - mn);

biscale(mn, mx, in) = mn + (0.5 * (1 + in)) * (mx - mn);

halfmod = (modulate < 0.5) * modulate + (modulate > 0.5) : si.smooth(ba.tau2pole(0.2));

detune = scale(1, 1.14159, 1 - halfmod);

index = scale(1, 3, 1 - modulate); // brightness

lfo(rate,phs) = biscale(0, 1, os.oscp(rate,phs));


crossC = hslider("influence",0,0,1,0.001): si.smooth(ba.tau2pole(0.2));

pad = (1-crossC)*pad1 +(crossC*pad2);

pad1 = 
fmosc(53,1,detune,index) * lfo(1/11,0) +
fmosc(60,1,detune,index) * lfo(1/13,ma.PI/2) +
fmosc(69,1,detune,index) * lfo(1/15,ma.PI/4) +
fmosc(41,1,detune,index) * lfo(1/9,ma.PI/5) +
fmosc(41,1,detune,index) * lfo(1/9,ma.PI/5)
;


pad2 = 
fmosc(53,1,detune,index) * lfo(1/11,0) +
fmosc(58,1,detune,index) * lfo(1/13,ma.PI/2) +
fmosc(70,1,detune,index) * lfo(1/15,ma.PI/4) +
fmosc(43,1,detune,index) * lfo(1/9,ma.PI/5) +
fmosc(43,1,detune,index) * lfo(1/9,ma.PI/5)
;


b = fmosc(36,1,detune,index) *.3; //* scale(.25,1,lfo(1/15,ma.PI/5));
bass = b*move;
fc=scale(200,2000,move);
bp= fi.resonlp(fc,8,1);
bass_move = bass:bp;
