.RAMSECTION "Vars" BANK 0 SLOT 0
OAM_hi instanceof OAM_hi_table $80
OAM_lo             ds $20

MouseDS1Check0     db           ; connect_st0
MouseDS1Check1     db           ; connect_st1
MouseTempLo        db           ; reg0l
MouseTempHi        db           ; reg0h
MouseConnected0    db           ; mouse_con0
MouseConnected1    db           ; mouse_con1
MouseSpeed0        db           ; mouse_sp0 (joy 1)
MouseSpeed1        db           ; mouse_sp1 (joy 2)
MouseSpeedSetting0 db           ; mouse_sp_set0 (For speed setting)
MouseSpeedSetting1 db           ; mouse_sp_set1
MouseTurbo0        db           ; mouse_sw0 (actuator status)
MouseTurbo1        db           ; mouse_sw1
MouseClick0        db           ; mouse_swt0
MouseClick1        db           ; mouse_swt1
MouseClickPrev0    db           ; mouse_sb0
MouseClickPrev1    db           ; mouse_sb1
MouseX0            db
MouseX1            db
MouseY0            db
MouseY1            db
.ENDS
