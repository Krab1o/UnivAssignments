(deffunction substringReplace (?str ?substring ?replacement)
    (bind ?lenStr (str-length ?str))
    (bind ?lenSubstr (str-length ?substring))
    (bind ?newStr ?str)
    (bind ?k (str-index ?substring ?str))

    (while (not (eq ?k FALSE))
        (bind ?str1 (sub-string 1 (- ?k 1) ?newStr))
        (bind ?str2 (sub-string (+ ?k ?lenSubstr) ?lenStr ?newStr))
        (bind ?newStr (str-cat ?str1 ?replacement ?str2))
        (bind ?k (str-index ?substring ?newStr))
    )
    ?newStr
)

(defrule main
=>
    (printout t "Str = ")
    (bind ?str (read))
    (printout t "Substring to replace = ")
    (bind ?substring (read))
    (printout t "Relpacement = ")
    (bind ?replacement (read))
    ; (printout t (str-index ?symbol ?str))
    (bind ?str (substringReplace ?str ?substring ?replacement))
    (printout t ?str crlf)
)