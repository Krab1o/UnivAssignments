(deffacts trains
    (poezd TR1 Saratov 7:35)
    (poezd TR2 Saratov 18:22)
    (poezd TR3 Moscow 21:34)
    (poezd TR4 Moscow 20:07)
)

; enter this in CLIPS REPL
; (reset)
; (facts)
;
; (assert (poezd TR5 Vladivostok 6:04)
;          (poezd TR6 Kazan 9:13)
; )

; (facts)

; (retract 1)
; (retract 4)

; (retract 2)
; (assert (poezd TR2 Saratov 19:22))

; (retract 3)
; (assert (poezd TR3 Moscow 22:34))

; (facts)
