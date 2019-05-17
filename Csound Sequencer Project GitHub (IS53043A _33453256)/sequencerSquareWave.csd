<CsoundSynthesizer>
<Cabbage>
form size(640, 400), caption("Sequencer"), pluginID("plu1") ;Setup UI Parameters

;Parameters 1 
rslider bounds(32, 20, 68, 70), channel("PW1"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 132, 0, 255), ;Pulse Width parameter of Square wave oscilator
rslider bounds(32, 100, 68, 70), channel("Phase1"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 132, 0, 255), ;Phase parameter of Square wave oscilator
rslider bounds(32, 180, 68, 70), channel("Divide1"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 132, 0, 255), ;Frequency division parameter of Square wave oscilator
rslider bounds(32, 260, 68, 70), channel("Mult1"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 132, 0, 255), ;Multiplication of the frequency division parameter of Square wave oscilator

;Parameters 2
rslider bounds(102, 20, 68, 70), channel("PW2"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 132, 0, 255), 
rslider bounds(102, 100, 68, 70), channel("Phase2"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 132, 0, 255),
rslider bounds(102, 180, 68, 70), channel("Divide2"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 132, 0, 255),
rslider bounds(102, 260, 68, 70), channel("Mult2"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 132, 0, 255), 

;Parameters 3
rslider bounds(172, 20, 68, 70), channel("PW3"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 0, 132, 255), 
rslider bounds(172, 100, 68, 70), channel("Phase3"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 0, 132, 255), 
rslider bounds(172, 180, 68, 70), channel("Divide3"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 0, 132, 255), 
rslider bounds(172, 260, 68, 70), channel("Mult3"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 0, 132, 255), 

;Parameters 4
rslider bounds(242, 20, 68, 70), channel("PW4"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 0, 132, 255), 
rslider bounds(242, 100, 68, 70), channel("Phase4"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 0, 132, 255), 
rslider bounds(242, 180, 68, 70), channel("Divide4"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 0, 132, 255), 
rslider bounds(242, 260, 68, 70), channel("Mult4"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 0, 132, 255), 

;Parameters 5
rslider bounds(312, 20, 68, 70), channel("PW5"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 132, 0, 255), 
rslider bounds(312, 100, 68, 70), channel("Phase5"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 132, 0, 255), 
rslider bounds(312, 180, 68, 70), channel("Divide5"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 132, 0, 255), 
rslider bounds(312, 260, 68, 70), channel("Mult5"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 132, 0, 255), 

;Parameters 6
rslider bounds(382, 20, 68, 70), channel("PW6"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 132, 0, 255), 
rslider bounds(382, 100, 68, 70), channel("Phase6"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 132, 0, 255),
rslider bounds(382, 180, 68, 70), channel("Divide6"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 132, 0, 255),
rslider bounds(382, 260, 68, 70), channel("Mult6"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 132, 0, 255), 

;Parameters 7
rslider bounds(452, 20, 68, 70), channel("PW7"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 0, 132, 255), 
rslider bounds(452, 100, 68, 70), channel("Phase7"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 0, 132, 255), 
rslider bounds(452, 180, 68, 70), channel("Divide7"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 0, 132, 255), 
rslider bounds(452, 260, 68, 70), channel("Mult7"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 0, 132, 255), 

;Parameters 8
rslider bounds(522, 20, 68, 70), channel("PW8"), range(1, 8, 4, 1, 1), text("Pulse Width"), colour(2, 0, 132, 255), 
rslider bounds(522, 100, 68, 70), channel("Phase8"), range(0, 1, 0, 1, 0.125), text("Phase"), colour(2, 0, 132, 255), 
rslider bounds(522, 180, 68, 70), channel("Divide8"), range(1, 8, 1, 1, 1), text("Divide"), colour(2, 0, 132, 255), 
rslider bounds(522, 260, 68, 70), channel("Mult8"), range(1, 8, 1, 1, 1), text("Mult"), colour(2, 0, 132, 255), 

;Sequencer Settings
rslider bounds(312, 325, 68, 70), channel("Quantise"), range(1, 64, 1, 1, 1), text("Quantise"), colour(2, 132, 132, 255), ;Controls time resolution of sequencer
rslider bounds(382, 325, 68, 70), channel("Speed"), range(1, 64, 1, 1, 1), text("Speed"), colour(2, 132, 132, 255), ;How fast the sequencer plays
</Cabbage>
<CsOptions>
-d -n -+rtmidi=null -m0d -Q0 --midi-key=4 ;Csound Settings
</CsOptions>

<CsInstruments>

ksmps = 32 ;Sets buffer size. No audio so sample rate and number of channels are irrelevant
instr 1	

;UI paramters passed through to variables																																														
kfpch1      chnget "PW1"	
kphase1     chnget "Phase1"
kdivide1    chnget "Divide1"
kmult1      chnget "Mult1"
	
kfpch2      chnget "PW2"	
kphase2     chnget "Phase2"
kdivide2    chnget "Divide2"
kmult2      chnget "Mult2"

kfpch3      chnget "PW3"	
kphase3     chnget "Phase3"
kdivide3    chnget "Divide3"
kmult3      chnget "Mult3"

kfpch4      chnget "PW4"	
kphase4     chnget "Phase4"
kdivide4    chnget "Divide4"
kmult4      chnget "Mult4"

kfpch5      chnget "PW5"	
kphase5     chnget "Phase5"
kdivide5    chnget "Divide5"
kmult5      chnget "Mult5"

kfpch6      chnget "PW6"	
kphase6     chnget "Phase6"
kdivide6    chnget "Divide6"
kmult6      chnget "Mult6"

kfpch7      chnget "PW7"	
kphase7     chnget "Phase7"
kdivide7    chnget "Divide7"
kmult7      chnget "Mult7"
	
kfpch8      chnget "PW8"	
kphase8     chnget "Phase8"
kdivide8    chnget "Divide8"
kmult8      chnget "Mult8"

kquantise  chnget "Quantise"
kspeed      chnget "Speed"


anosync init 0 ;A dummy variable, does nothing but is required for some opcode
amasterclock, asyncout syncphasor 1/4, anosync ;The master clock. Take 4 seconds to complete a cycle
kmasterclock	       downsamp amasterclock ;Convert audio rate to control rate for compatibility


kseqtick	tablekt	kmasterclock * kquantise, 4, 1, 0, 1 ;Quantise rate based on master clock rate
ktick       trigger kseqtick, 0.5, 2 ;Convert audio rate to control rate for compatibility

;Opcode for tablekt:
;ares tablekt xndx, kfn [, ixmode] [, ixoff] [, iwrap]
;Which my use roughly translates to:
;output opcode frequency, pulsewidth, table index ranges from 0 to 1, no offset, wrap index to 0 when it is greater than 1
kseq1	tablekt	(((kmasterclock * kspeed) - kphase1) / kdivide1) * kmult1, kfpch1, 1, 0, 1 ;Square wave 1
ktrig1  trigger kseq1, 0.5, 2 ;Square wave is converted into a trigger that is actived whenever the signal passes 0.5 in either direction

kseq2	tablekt	(((kmasterclock * kspeed) - kphase2) / kdivide2) * kmult2, kfpch2, 1, 0, 1 ;Square wave 2
ktrig2  trigger kseq2, 0.5, 2

kout1   trigger (ktrig1 + ktrig2), 0.5, 2 ;Combine triggers from square waves 1 and 2
kbeat1  trigger (kout1 * ktick), 0.5, 1 ;Output A   Trigger only ocurs when quantisation and kout1 are each equal to 1


kseq3	tablekt	(((kmasterclock * kspeed) - kphase3) / kdivide3) * kmult3, kfpch3, 1, 0, 1 ;Square wave 3
ktrig3  trigger kseq3, 0.5, 2

kseq4	tablekt	(((kmasterclock * kspeed) - kphase4) / kdivide4) * kmult4, kfpch4, 1, 0, 1 ;Square wave 4
ktrig4  trigger kseq4, 0.5, 2

kout2   trigger (ktrig3 + ktrig4), 0.5, 2
kbeat2  trigger (kout2 * ktick), 0.5, 1 ;Output B


kseq5	tablekt	(((kmasterclock * kspeed) - kphase5) / kdivide5) * kmult5, kfpch5, 1, 0, 1 ;Square wave 5
ktrig5  trigger kseq5, 0.5, 2

kseq6	tablekt	(((kmasterclock * kspeed) - kphase6) / kdivide6) * kmult6, kfpch6, 1, 0, 1 ;Square wave 6
ktrig6  trigger kseq6, 0.5, 2

kout3   trigger (ktrig5 + ktrig6), 0.5, 2
kbeat3  trigger (kout3 * ktick), 0.5, 1 ;Output C


kseq7	tablekt	(((kmasterclock * kspeed) - kphase7) / kdivide7) * kmult7, kfpch7, 1, 0, 1 ;Square wave 7
ktrig7  trigger kseq7, 0.5, 2

kseq8	tablekt	(((kmasterclock * kspeed) - kphase8) / kdivide8) * kmult8, kfpch8, 1, 0, 1 ;Square wave 8
ktrig8  trigger kseq8, 0.5, 2

kout4   trigger (ktrig7 + ktrig8), 0.5, 2
kbeat4  trigger (kout4 * ktick), 0.5, 1 ;Output D


;Midi notes for Outputs A to D
midion2  1, int(64), int(127), int(kbeat1)
midion2  2, int(65), int(127), int(kbeat2)
midion2  3, int(66), int(127), int(kbeat3)
midion2  4, int(67), int(127), int(kbeat4)

endin
</CsInstruments>

<CsScore>
;Tables representing square waves with different pulse widths
f1	 0 16 -2 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
f2	 0 16 -2 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0
f3	 0 16 -2 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
f4	 0 16 -2 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
f5	 0 16 -2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0
f6	 0 16 -2 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0
f7	 0 16 -2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0
f8	 0 16 -2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0

; Trigger instrument 1 script infinietly
i 1 0 z 1
f 0 z
</CsScore>
</CsoundSynthesizer>