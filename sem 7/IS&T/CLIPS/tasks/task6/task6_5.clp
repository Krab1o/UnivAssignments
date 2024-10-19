(deffunction ask-question (?question $?allowed-values)
    (printout t ?question)
    (bind ?answer (read))
    (if (lexemep ?answer)
        then (bind ?answer (lowcase ?answer)))

    (while (not (member$ ?answer ?allowed-values)) do
        (printout t ?question)
        (bind ?answer (read))
        (if (lexemep ?answer) 
            then (bind ?answer (lowcase ?answer))))
    ?answer
)


; правило, задающее вопрос пользователю и в случае утвердительного ответа добавляющее факт в базу данных 
(defrule yes-no 
=>
    (bind ?response (ask-question "are you a programmer?" yes no y n))
    (if (or (eq ?response yes) (eq ?response y)) ; если ответ y  или yes
        then (printout t "TRUE" crlf)
    else (printout t "FALSE" crlf)
    )
)