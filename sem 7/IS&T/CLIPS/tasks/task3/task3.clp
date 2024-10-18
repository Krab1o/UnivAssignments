(deftemplate sotrudnik
    (slot name)
    (slot otdel (default OT1))
    (slot st))

; (modify 1 (otdel OT4))
; (modify 3 (st 3))
; (duplicate 2 (name Lazarev))
; (save-facts task3-facts.clp)

; (clear)
; (load task3.clp)
; (load-facts task3-facts.clp)
;  (assert (sotrudnik (name Gradusov) (otdel OT6) (st 9))
;          (sotrudnik (name Morozov) (otdel OT6) (st 10)) )

; (retract 2)
; (retract 4)

; (facts)

; (save-facts task3-facts-2.clp)