.RAMSECTION "Vars" BANK 0 SLOT 0
OAM_lo instanceof OAM_lo_table $80
OAM_hi             ds $20

MouseDS1Check0     db           ; connect_st0
MouseDS1Check1     db           ; connect_st1
MouseTempLo        db           ; reg0l
MouseTempHi        db           ; reg0h
MouseConnected0    db           ; mouse_con0
MouseConnected1    db           ; mouse_con1
MouseSpeedSetting0 db           ; mouse_sp_set0 (For speed setting)
MouseSpeedSetting1 db           ; mouse_sp_set1
MouseSpeed0        db           ; mouse_sp0 (joy 1)
MouseSpeed1        db           ; mouse_sp1 (joy 2)
MouseY0            db
MouseY1            db
MouseX0            db
MouseX1            db
MouseTurbo0        db           ; mouse_sw0 (mouse continuous)
MouseTurbo1        db           ; mouse_sw1
MouseClick0        db           ; mouse_swt0 (mouse switch trigger)
MouseClick1        db           ; mouse_swt1
MouseClickPrev0    db           ; mouse_sb0
MouseClickPrev1    db           ; mouse_sb1
MouseDeltaX        db
MouseDeltaY        db
.ENDS
