;; oam table 1
;; Sprite Table 1 (4-bytes per sprite)
;; Byte 1:    xxxxxxxx    x: X coordinate
;; Byte 2:    yyyyyyyy    y: Y coordinate
;; Byte 3:    cccccccc    c: Starting tile #
;; Byte 4:    vhoopppc    v: vertical flip h: horizontal flip  o: priority bits
;;                        p: palette #

.STRUCT OAM_hi_table
x     db
y     db
tile  db
data  db
.ENDST

.STRUCT star
x db
y db
z db
.ENDST
