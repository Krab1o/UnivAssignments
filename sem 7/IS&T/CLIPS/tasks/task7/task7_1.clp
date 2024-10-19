(deffunction symbol_replace (?str ?symbol ?replacement)
    (bind ?len (str-length ?str))
    (bind ?newStr ?str)
    (bind ?k (str-index ?symbol ?str))

    (while (not (eq ?k FALSE))
        (bind ?str1 (sub-string 1 (- ?k 1) ?newStr))
        (bind ?str2 (sub-string (+ ?k 1) ?len ?newStr))
        (bind ?newStr (str-cat ?str1 ?replacement ?str2))
        (bind ?k (str-index ?symbol ?newStr))
    )
    ?newStr
)

(defrule main
=>
    (printout t "Str = ")
    (bind ?str (read))
    (printout t "Symbol to replace = ")
    (bind ?symbol (read))
    (printout t "Relpacement = ")
    (bind ?replacement (read))
    ; (printout t (str-index ?symbol ?str))
    (bind ?str (symbol_replace ?str ?symbol ?replacement))
    (printout t ?str crlf)
)