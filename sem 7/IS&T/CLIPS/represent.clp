(defglobal ?*marks* = 0)
(defglobal ?*rovnoe* = 0)
(defglobal ?*engels* = 0)

(defrule start
(initial-fact)
=>
(printout t crlf "REPRESENTATIVES" crlf)

(defrule marks
(rep ? Marks)
=>
(bind ?*marks* (+ ?*marks* 1)))

(defrule rovnoe
(rep ? Rovnoe)
=>
(bind ?*rovnoe* (+ ?*rovnoe* 1)))

(defrule engels
(rep ? Engels)
=>
(bind ?*engels* (+ ?*engels* 1)))

(defrule result
(declare (salience -1))
(initial-fact)
=>
(printout t "from Marks: " ?*marks* crlf)
(printout t "from Rovnoe: " ?*rovnoe* crlf)
(printout t "from Engels: " ?*engels* crlf))
