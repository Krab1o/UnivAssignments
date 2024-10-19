(deffunction iter (?sum ?n)
    (if (= ?n 0) 
        then ?sum
    else 
        (bind ?sum (+ ?sum (/ 1 (** ?n 2)) (iter ?sum (- ?n 1))))
    )
    ?sum
)

(defrule iter_n
=>  
    (printout t "n = ")
    (bind ?n (read))
    (bind ?sum (iter 0 ?n))
    (printout t "sum = " ?sum crlf) 
)