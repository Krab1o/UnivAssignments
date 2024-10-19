(defrule invest
=>
    (printout t "sum = ")
    (bind ?sum (read))
    (printout t "p = ")
    (bind ?p (read))

    (bind ?target (* ?sum 2))
    (bind ?ans 0)
    (while (< ?sum ?target)
        do
        (bind ?sum (* ?sum ?p))
        (bind ?ans (+ ?ans 1))
    )
    (printout t "Число лет для увеличения суммы в два раза " ?ans crlf)
)