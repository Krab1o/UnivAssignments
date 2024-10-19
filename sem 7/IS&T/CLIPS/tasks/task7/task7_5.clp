(deffunction space_removal (?str)
    (bind ?lenStr (str-length ?str))

    (loop-for-count (?i 1 ?lenStr)
        do
        (bind ?char (sub-string ?i ?i ?str))
        
        (if (eq ?char " ")
            then
            (bind ?k (+ ?i 1))
            (bind ?char (sub-string ?k ?k ?str))

            (while (eq ?char " ")
                (bind ?str1 (sub-string 1 (- ?k 1) ?str))
                (bind ?str2 (sub-string (+ ?k 1) ?lenStr ?str))
                (bind ?str (str-cat ?str1 ?str2))
                (bind ?lenStr (- ?lenStr 1))
                (bind ?char (sub-string ?k ?k ?str))
            )
        )
    )
    ?str
)

(defrule main
=>
    (printout t "Str = ")
    (bind ?str (read))
    (bind ?str (space_removal ?str))
    (printout t ?str crlf)
)