(defrule factorial
=>
    (printout t "n = ")
    (bind ?n (read))
    (bind ?prod 1)
    (loop-for-count (?i 2 ?n)
        do
        (bind ?prod (* ?prod ?i))
    )
    (printout t "fact = " ?prod crlf)
)