<CsoundSynthesizer> bounds(0, 0, 0, 0)
<CsOptions>
; amend device number accordingly
-d -n -+rtmidi=null -M0 -m0d  -Q0
</CsOptions>

<CsInstruments>
;sr	= 48000	
ksmps	=	32
;nchnls	=	2
;0dbfs	=	1

massign 0, 100

gicount init 0
gktrackSelect init 0

gkslider[] init 8
kindex = 0
until kindex == lenarray(gkslider) do
  gkslider[kindex] = (112 + kindex)
  kindex += 1
od

gkhits[] init 8
kindex = 0
until kindex == lenarray(gkhits) do
  gkhits[kindex] = 112
  kindex += 1
od

gksteps[] init 8
kindex = 0
until kindex == lenarray(gksteps) do
  gksteps[kindex] = 113
  kindex += 1
od

gkoffsetAmount[] init 8
kindex = 0
until kindex == lenarray(gkoffsetAmount) do
  gkoffsetAmount[kindex] = 114
  kindex += 1
od

gkrotateAmount[] init 8
kindex = 0
until kindex == lenarray(gkrotateAmount) do
  gkrotateAmount[kindex] = 115
  kindex += 1
od

gklocalReset[] init 8
kindex = 0
until kindex == lenarray(gklocalReset) do
  gklocalReset[kindex] = 116
  kindex += 1
od

gknoteNum[] fillarray 35, 38, 41, 43, 42, 46, 49, 10

;massign 0, 100
;---------------------------------------------

opcode euclid_str, S, ii
  ihits, isteps xin

  Sleft = "1"
  Sright = "0"

  ileft = ihits
  iright = isteps - ileft

  while iright > 1 do
    if (iright > ileft) then
      iright = iright - ileft 
      Sleft = strcat(Sleft, Sright)
    else
      itemp = iright
      iright = ileft - iright
      ileft = itemp 
      Stemp = Sleft
      Sleft = strcat(Sleft, Sright)
      Sright = Stemp
    endif
  od

  Sout = ""
  indx = 0 
  while (indx < ileft) do
    Sout = strcat(Sout, Sleft)
    indx += 1
  od
  indx = 0 
  while (indx < iright) do
    Sout = strcat(Sout, Sright)
    indx += 1
  od

  xout Sout
endop
;---------------------------------------------

opcode euclid, i, iio
  ihits, isteps, itick  xin

  Sval = euclid_str(ihits, isteps)
  indx = itick % strlen(Sval)
  xout strtol(strsub(Sval, indx, indx + 1))
endop
;---------------------------------------------

opcode theSeq, i, ikkkkk
    itick, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset xin        

    ihits = ((isteps / 8) * ihits)
    ihits = int(ihits)

    ilocalCount = gicount % ilocalReset
    if ilocalCount == 0 then 
       irotateCount = 0
    endif

    ioffset = ioffsetAmount + (irotateCount * irotateAmount)

    ibeat euclid ihits, isteps, (ilocalCount + ioffset)

    if (ilocalCount % isteps) == (isteps - 1) then 
        irotateCount += 1
    endif

    xout ibeat
endop
;---------------------------------------------

opcode midiGetSlider, 0, k
    kdata1 xin
    kindex = (kdata1 % 16)
    gkslider[kindex] = kdata1  
        
    until kindex > 120 do
      if kindex >= kdata1 then 
        midiout 144, 1, int(kindex), int(127)
      else
        midiout 128, 1, int(kindex), int(127)
      endif
      kindex += 16
    od
endop
;---------------------------------------------

opcode genSeq, 0, k
    kindex xin
    
    khits = gkhits[kindex]
    ksteps = gksteps[kindex]
    koffsetAmount = gkoffsetAmount[kindex]
    krotateAmount = gkrotateAmount[kindex]
    klocalReset = gklocalReset[kindex]
                                             
    ihits = (8 - int(i(khits) / 16))
    isteps = ((7 - int(i(ksteps) / 16)) + 8)
    ioffsetAmount = (7 - int(i(koffsetAmount) / 16))
    irotateAmount = (7 - int(i(krotateAmount) / 16))
    ilocalReset = ((8 - int(i(klocalReset) / 16)) * 8)

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset
   
    if ibeat != 0 then
        midion  16, int(gknoteNum[kindex]), int(127)
    endif 
endop
;---------------------------------------------

instr 1
    genSeq 0
    genSeq 1
    genSeq 2
    genSeq 3
    genSeq 4
    genSeq 5
    genSeq 6
    genSeq 7
    
    gicount += 1
   
    if gicount >= 64 then
        gicount = 0
    endif
endin
;---------------------------------------------

instr 99  
    ares phasor 9
    kres downsamp ares
    ktrig trigger kres, 0.5, 0

    schedkwhen ktrig, 0, 1, 1, 0, 0.0001      
endin
;---------------------------------------------
instr 100
    kstatus, kchan, kdata1, kdata2 midiin

    if (kstatus == 144) && (kdata2 == 127) then
        if (kdata1 % 16) == 8 then
            gktrackSelect = int(kdata1 / 16)
            kindex = 8
            until kindex > 120 do
              if kindex == kdata1 then 
                midiout 144, 1, int(kindex), int(127)
              else
                midiout 128, 1, int(kindex), int(127)
              endif
              kindex += 16
            od
            
            gkslider[0] = gkhits[gktrackSelect]
            gkslider[1] = gksteps[gktrackSelect]
            gkslider[2] = gkoffsetAmount[gktrackSelect]
            gkslider[3] = gkrotateAmount[gktrackSelect]
            gkslider[4] = gklocalReset[gktrackSelect]
            
            midiGetSlider gkslider[0]
            midiGetSlider gkslider[1]
            midiGetSlider gkslider[2]
            midiGetSlider gkslider[3]
            midiGetSlider gkslider[4]
            midiGetSlider gkslider[5]
            midiGetSlider gkslider[6]
            midiGetSlider gkslider[7]            
                        
        else
            midiGetSlider kdata1       
        endif  
        
        gkhits[gktrackSelect] = gkslider[0]
        gksteps[gktrackSelect] = gkslider[1]
        gkoffsetAmount[gktrackSelect] = gkslider[2]
        gkrotateAmount[gktrackSelect] = gkslider[3]
        gklocalReset[gktrackSelect] = gkslider[4]                           
    endif 
    
    ;printk 0.1, kdata1 % 16
    ;printk 0.1, gkhits[0]
    ;printk 0.1, gkslider[0]
    ;printk 0.1, gkhits[1]
    ;printk 0.5, gktrackSelect
    
endin
;---------------------------------------------
</CsInstruments>

<CsScore> 
i100 0 z
i99 0 z
f0    z

</CsScore>
</CsoundSynthesizer>