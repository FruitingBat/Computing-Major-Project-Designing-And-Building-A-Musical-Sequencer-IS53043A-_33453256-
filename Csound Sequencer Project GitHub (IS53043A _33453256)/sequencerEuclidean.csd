<CsoundSynthesizer> bounds(0, 0, 0, 0)
<Cabbage>
form size(380, 490), caption("Sequencer"), pluginID("plu1") ;Setup UI Parameters

;Cabbage Ui elements for Note Selection
rslider bounds(310, 5, 60, 60) range(0, 127, 35, 1, 1) channel("noteNum1") increment(1) value(35) text("Note") colour(255, 255, 255, 255)
rslider bounds(310, 65, 60, 60) range(0, 127, 38, 1, 1) channel("noteNum2") increment(1) value(38) text("Note") colour(255, 0, 0, 255)
rslider bounds(310, 125, 60, 60) range(0, 127, 41, 1, 1) channel("noteNum3") increment(1) value(41) text("Note") colour(0, 255, 0, 255)
rslider bounds(310, 185, 60, 60) range(0, 127, 43, 1, 1) channel("noteNum4") increment(1) value(43) text("Note") colour(0, 0, 255, 255)
rslider bounds(310, 245, 60, 60) range(0, 127, 42, 1, 1) channel("noteNum5") increment(1) value(42) text("Note") colour(255, 255, 0, 255)
rslider bounds(310, 305, 60, 60) range(0, 127, 46, 1, 1) channel("noteNum6") increment(1) value(46) text("Note") colour(255, 0, 255, 255)
rslider bounds(310, 365, 60, 60) range(0, 127, 49, 1, 1) channel("noteNum7") increment(1) value(49) text("Note") colour(0, 255, 255, 255)
rslider bounds(310, 425, 60, 60) range(0, 127, 0, 1, 1) channel("noteNum8") increment(1) value(0) text("Note") colour(125, 125, 125, 255)
</Cabbage>
<CsOptions>
-d -n -+rtmidi=null -M0 -m0d  -Q0 ;Csound settings
</CsOptions>

<CsInstruments>
ksmps	=	32 ;Sets buffer size. No audio so sample rate and number of channels are irrelevant

gicount init 0 ;Global count
gktrackSelect init 0 ;Track selection

;Global slider variables
gkslider1 init 0
gkslider2 init 0
gkslider3 init 0
gkslider4 init 0
gkslider5 init 0
gkslider6 init 0
gkslider7 init 0
gkslider8 init 0
gkslider9 init 0

;Track 1 parameters
gkhits1 init 112 ;Hits
gksteps1 init 113 ;Steps
gkoffsetAmount1 init 114 ;Offset
gkrotateAmount1 init 115 ;Rotation
gklocalReset1 init 116 ;Local reset

;Track 2 parameters
gkhits2 init 112
gksteps2 init 113
gkoffsetAmount2 init 114
gkrotateAmount2 init 115
gklocalReset2 init 116

;Track 3 parameters
gkhits3 init 112
gksteps3 init 113
gkoffsetAmount3 init 114
gkrotateAmount3 init 115
gklocalReset3 init 116

;Track 4 parameters
gkhits4 init 112
gksteps4 init 113
gkoffsetAmount4 init 114
gkrotateAmount4 init 115
gklocalReset4 init 116

;Track 5 parameters
gkhits5 init 112
gksteps5 init 113
gkoffsetAmount5 init 114
gkrotateAmount5 init 115
gklocalReset5 init 116

;Track 6 parameters
gkhits6 init 112
gksteps6 init 113
gkoffsetAmount6 init 114
gkrotateAmount6 init 115
gklocalReset6 init 116

;Track 7 parameters
gkhits7 init 112
gksteps7 init 113
gkoffsetAmount7 init 114
gkrotateAmount7 init 115
gklocalReset7 init 116

;Track 8 parameters
gkhits8 init 112
gksteps8 init 113
gkoffsetAmount8 init 114
gkrotateAmount8 init 115
gklocalReset8 init 116

massign 0, 100 ;Assign MIDI input messages to instrument 100
;---------------------------------------------
;The Opcode below takes the parameters of ‘hits’ and ‘steps’ and passes out a string of 1s and 0s representing on/off triggers of the sequence. 
;This Opcode distributes an equal number of hits across steps with additional logic for handling remainders.
opcode euclid_str, S, ii ;Opcode taken from Steven Yi, ‘csound-live-code’, https://github.com/kunstmusik/csound-live-code/blob/1b351d893c5865809ca4ac1d95c17488717c3452/livecode.orc#L419
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
;itick is used to select an index of the generated string to be passed to the output.
opcode euclid, i, iio ;Opcode taken from Steven Yi,‘csound-live-code’, https://github.com/kunstmusik/csound-live-code/blob/1b351d893c5865809ca4ac1d95c17488717c3452/livecode.orc#L460
  ihits, isteps, itick  xin

  Sval = euclid_str(ihits, isteps)
  indx = itick % strlen(Sval)
  xout strtol(strsub(Sval, indx, indx + 1))
endop
;---------------------------------------------
;This opcode applies addition manipulate to the generated Euclid pattern
opcode theSeq, i, iiiiii
    itick, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset xin

    ihits = ((isteps / 8) * ihits) ;Scales range of possible hits by the number of steps
    ihits = int(ihits)

    ilocalCount = gicount % ilocalReset
    if ilocalCount == 0 then 
       irotateCount = 0 ;rotation resets when the sequence resets
    endif

    ioffset = ioffsetAmount + (irotateCount * irotateAmount) ;Combine offset and rotation to calculate the sequences total offset

    ibeat euclid ihits, isteps, (ilocalCount + ioffset) ;Generate Eulcid Rhythm 

    if (ilocalCount % isteps) == (isteps - 1) then 
        irotateCount += 1 ;Rotates the Euclid equence every completed cycle of the sequence
    endif

    xout ibeat
endop
;---------------------------------------------
;Pass MIDI infomation to correct global slider
;Draw slider LEDs
opcode midiGetSlider, 0, k
    kdata1 xin
    
    ;Slider 1
    if kdata1 % 16 == 0 then ;Work out slider number
       gkslider1 = kdata1  ;Pass MIDI information to correct global slider
        
       kindex = 0      
       while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127) ;Draw LED slider
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od
    
    ;Slider 2      
    elseif kdata1 % 16 == 1 then
        gkslider2 = kdata1 
        
        kindex = 1       
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od
    
    ;Slider 3
    elseif kdata1 % 16 == 2 then
        gkslider3 = kdata1
        
        kindex = 2
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od
        
    ;Slider 4
    elseif kdata1 % 16 == 3 then
        gkslider4 = kdata1
   
        kindex = 3
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od  
    
    ;Slider 5
    elseif kdata1 % 16 == 4 then
        gkslider5 = kdata1
            
        kindex = 4
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od
    
    ;Slider 6
    elseif kdata1 % 16 == 5 then
        gkslider6 = kdata1
            
        kindex = 5
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od

    ;Slider 7
    elseif kdata1 % 16 == 6 then
        gkslider7 = kdata1
            
        kindex = 6
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od
        
    ;Slider 8   
    elseif kdata1 % 16 == 7 then
        gkslider8 = kdata1
            
        kindex = 7
        while kindex <= 120 do
          if kindex >= kdata1 then 
            midiout 144, 1, int(kindex), int(127)
          else
            midiout 128, 1, int(kindex), int(127)
          endif
          kindex += 16
        od
    endif     
endop
;---------------------------------------------
;Instrument 1 handles sequencer logic
instr 1

    ; Track 1 sequencer
    ; Scale global parameters values to correct range and apply to local variables
    ihits = (8 - int(i(gkhits1) / 16))
    isteps = ((7 - int(i(gksteps1) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount1) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount1) / 16))
    ilocalReset = ((8 - int(i(gklocalReset1) / 16)) * 8)
    inoteNum chnget "noteNum1" ;Fetch MIDI output note from UI
    
    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset ;Generate sequence

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127) ;Send MIDI note if note on is present at current step
    endif

    ; Track 2 sequence
    ihits = (8 - int(i(gkhits2) / 16))
    isteps = ((7 - int(i(gksteps2) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount2) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount2) / 16))
    ilocalReset = ((8 - int(i(gklocalReset2) / 16)) * 8)
    inoteNum chnget "noteNum2"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif

    ; Track 3 sequence
    ihits = (8 - int(i(gkhits3) / 16))
    isteps = ((7 - int(i(gksteps3) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount3) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount3) / 16))
    ilocalReset = ((8 - int(i(gklocalReset3) / 16)) * 8)
    inoteNum chnget "noteNum3"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif

    ; Track 4 sequence
    ihits = (8 - int(i(gkhits4) / 16))
    isteps = ((7 - int(i(gksteps4) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount4) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount4) / 16))
    ilocalReset = ((8 - int(i(gklocalReset4) / 16)) * 8)
    inoteNum chnget "noteNum4"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif
    
    ; Track 5 sequence
    ihits = (8 - int(i(gkhits5) / 16))
    isteps = ((7 - int(i(gksteps5) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount5) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount5) / 16))
    ilocalReset = ((8 - int(i(gklocalReset5) / 16)) * 8)
    inoteNum chnget "noteNum5"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif

    ; Track 6 sequence
    ihits = (8 - int(i(gkhits6) / 16))
    isteps = ((7 - int(i(gksteps6) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount6) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount6) / 16))
    ilocalReset = ((8 - int(i(gklocalReset6) / 16)) * 8)
    inoteNum chnget "noteNum6"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif

    ; Track 7 sequence
    ihits = (8 - int(i(gkhits7) / 16))
    isteps = ((7 - int(i(gksteps7) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount7) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount7) / 16))
    ilocalReset = ((8 - int(i(gklocalReset7) / 16)) * 8)
    inoteNum chnget "noteNum7"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif

    ; Track 8 sequence
    ihits = (8 - int(i(gkhits8) / 16))
    isteps = ((7 - int(i(gksteps8) / 16)) + 8)
    ioffsetAmount = (7 - int(i(gkoffsetAmount8) / 16))
    irotateAmount = (7 - int(i(gkrotateAmount8) / 16))
    ilocalReset = ((8 - int(i(gklocalReset8) / 16)) * 8)
    inoteNum chnget "noteNum8"

    ibeat theSeq gicount, ihits, isteps, ioffsetAmount, irotateAmount, ilocalReset

    if ibeat != 0 then
       midion  16, int(inoteNum), int(127)
    endif

   gicount += 1 ;Increase global count by one
   
   if gicount >= 64 then
    gicount = 0 ;Reset global count after 64 bars
   endif      
endin
;---------------------------------------------

;This instrument is the global clock
instr 99  
    ares phasor 9 ;Phaser oscilator used as clock, tempo is fixed at this point in time
    kres downsamp ares
    ktrig trigger kres, 0.5, 0 ;Turn clock into trigger

    schedkwhen ktrig, 0, 1, 1, 0, 0.0001 ;Instrument 1 is actived on every trigger 
endin
;---------------------------------------------
; Instrument 100 handles MIDI infomation and global variables
instr 100
    kstatus, kchan, kdata1, kdata2 midiin ;Convert MIDI message into variables

    if kstatus == 144 then ;If note on message received 
        if (kdata1 % 16) == 8 then ;Midi message selects track number
            gktrackSelect = int(kdata1 / 16) ; Change track number
            kindex = 8
            while kindex <= 120 do
              if kindex == kdata1 then ;Draw LED to represent which track is active
                midiout 144, 1, int(kindex), int(127)
              else
                midiout 128, 1, int(kindex), int(127)
              endif
              kindex += 16
            od
            
            ;Track 1
            if gktrackSelect == 0 then
            ;Pass track parameters to global sliders
            gkslider1 = gkhits1
            gkslider2 = gksteps1
            gkslider3 = gkoffsetAmount1
            gkslider4 = gkrotateAmount1
            gkslider5 = gklocalReset1
            
            ;Track 2
            elseif gktrackSelect == 1 then
            gkslider1 = gkhits2
            gkslider2 = gksteps2
            gkslider3 = gkoffsetAmount2
            gkslider4 = gkrotateAmount2
            gkslider5 = gklocalReset2
            
            ;Track 3
            elseif gktrackSelect == 2 then
            gkslider1 = gkhits3
            gkslider2 = gksteps3
            gkslider3 = gkoffsetAmount3
            gkslider4 = gkrotateAmount3
            gkslider5 = gklocalReset3
            
            ;Track 4   
            elseif gktrackSelect == 3 then
            gkslider1 = gkhits4
            gkslider2 = gksteps4
            gkslider3 = gkoffsetAmount4
            gkslider4 = gkrotateAmount4
            gkslider5 = gklocalReset4
            
             
            ;Track 5   
            elseif gktrackSelect == 4 then
            gkslider1 = gkhits5
            gkslider2 = gksteps5
            gkslider3 = gkoffsetAmount5
            gkslider4 = gkrotateAmount5
            gkslider5 = gklocalReset5

            ;Track 6   
            elseif gktrackSelect == 5 then
            gkslider1 = gkhits6
            gkslider2 = gksteps6
            gkslider3 = gkoffsetAmount6
            gkslider4 = gkrotateAmount6
            gkslider5 = gklocalReset6

            ;Track 7    
            elseif gktrackSelect == 6 then
            gkslider1 = gkhits7
            gkslider2 = gksteps7
            gkslider3 = gkoffsetAmount7
            gkslider4 = gkrotateAmount7
            gkslider5 = gklocalReset7

            ;Track 8   
            elseif gktrackSelect == 7 then
            gkslider1 = gkhits8
            gkslider2 = gksteps8
            gkslider3 = gkoffsetAmount8
            gkslider4 = gkrotateAmount8
            gkslider5 = gklocalReset8
          endif  
          
        ;Draw all eight slider LEDS  
        midiGetSlider gkslider1
        midiGetSlider gkslider2
        midiGetSlider gkslider3
        midiGetSlider gkslider4
        midiGetSlider gkslider5
        midiGetSlider gkslider6
        midiGetSlider gkslider7
        midiGetSlider gkslider8
            
        else
            midiGetSlider kdata1 ;Draw only the slider LED coresponding to the MIDI input
        endif   
             
        ;Track 1        
        if gktrackSelect == 0 then ;Pass global sliders to track parmeters
            gkhits1 = gkslider1
            gksteps1 = gkslider2
            gkoffsetAmount1 = gkslider3
            gkrotateAmount1 = gkslider4
            gklocalReset1 = gkslider5
            
        ;Track 2            
        elseif gktrackSelect == 1 then
            gkhits2 = gkslider1
            gksteps2 = gkslider2
            gkoffsetAmount2 = gkslider3
            gkrotateAmount2 = gkslider4
            gklocalReset2 = gkslider5
            
        ;Track 3         
        elseif gktrackSelect == 2 then
            gkhits3 = gkslider1
            gksteps3 = gkslider2
            gkoffsetAmount3 = gkslider3
            gkrotateAmount3 = gkslider4
            gklocalReset3 = gkslider5
        
        ;Track 4         
        elseif gktrackSelect == 3 then
            gkhits4 = gkslider1
            gksteps4 = gkslider2
            gkoffsetAmount4 = gkslider3
            gkrotateAmount4 = gkslider4
            gklocalReset4 = gkslider5
        
        ;Track 5                
        elseif gktrackSelect == 4 then
            gkhits5 = gkslider1
            gksteps5 = gkslider2
            gkoffsetAmount5 = gkslider3
            gkrotateAmount5 = gkslider4
            gklocalReset5 = gkslider5
            
        ;Track 6                
        elseif gktrackSelect == 5 then
            gkhits6 = gkslider1
            gksteps6 = gkslider2
            gkoffsetAmount6 = gkslider3
            gkrotateAmount6 = gkslider4
            gklocalReset6 = gkslider5
      
        ;Track 7                
        elseif gktrackSelect == 6 then
            gkhits7 = gkslider1
            gksteps7 = gkslider2
            gkoffsetAmount7 = gkslider3
            gkrotateAmount7 = gkslider4
            gklocalReset7 = gkslider5

        ;Track 8                
        elseif gktrackSelect == 7 then
            gkhits8 = gkslider1
            gksteps8 = gkslider2
            gkoffsetAmount8 = gkslider3
            gkrotateAmount8 = gkslider4
            gklocalReset8 = gkslider5

        endif
    endif  
endin
;---------------------------------------------
</CsInstruments>

<CsScore> 
;Run instruments 100 and 99 for nearlyall eternity
i100 0 z
i99 0 z
f0    z

</CsScore>
</CsoundSynthesizer>
