(deffunction triangle_square (?a ?b ?c)
    (bind ?p (/ (+ ?a ?b ?c) 2))
    (sqrt (* ?p (- ?p ?a) (- ?p ?b) (- ?p ?c)))
)

(defrule main
=>
    (printout t "a1 = ")
    (bind ?a1 (read))
    (printout t "b1 = ")
    (bind ?b1 (read))
    (printout t "c1 = ")
    (bind ?c1 (read))
    (printout t "a2 = ")
    (bind ?a2 (read))
    (printout t "b2 = ")
    (bind ?b2 (read))
    (printout t "c2 = ")
    (bind ?c2 (read))
    (bind ?sq1 (triangle_square ?a1 ?b1 ?c1))
    (bind ?sq2 (triangle_square ?a2 ?b2 ?c2))
    (if (> ?sq1 ?sq2)
        then (printout t "Площадь первого треугольника больше" crlf)
    else 
        (if (< ?sq1 ?sq2)
            then (printout t "Площадь второго треугольника больше" crlf)
        else (printout t "Площади треугольников равны" crlf))
    )
)