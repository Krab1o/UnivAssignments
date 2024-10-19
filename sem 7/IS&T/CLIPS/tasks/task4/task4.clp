(deffacts list
    (sotrudnik Ivanov 4 2 50000)   
    (sotrudnik Petrov 1 4 35000)
    (sotrudnik Sidorov 9 3 90000)
    (sotrudnik Gradusov 5 1 78000)
    (sotrudnik Morozov 25 2 100000) )

(defrule premia 
    (sotrudnik ?name ?age ?children ?salary)
    (test (or (>= ?age 5) (>= ?children 2)))
=>
    (assert (prize ?name (* ?salary 0.2)))
    )

(defrule all_sotrudnik_poluchili
    (forall (sotrudnik ?name ?age ?children ?salary)
            (prize ?name ?premia))
=>
    (printout t "Все получили премию!" crlf))

(defrule is_sotrudnik_veteran
    (exists (sotrudnik ?name ?age ?children ?salary)
            (test (> ?age 20)))
=>
    (printout t "В коллективе есть ветеран труда!" crlf))
