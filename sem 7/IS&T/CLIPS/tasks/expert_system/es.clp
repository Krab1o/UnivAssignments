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
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then TRUE 
       else FALSE))

(defrule determine-player-state
   (not (working-state player ?))
   (not (repair ?))
   =>
   (if (yes-or-no-p "Плеер запускается (yes/no)? ") then 
      (if (yes-or-no-p "Плеер работает стабильно (yes/no)? ") then 
         (assert (repair "Ремонт не требуется"))
         (assert (working-state player stable))
      else
         (assert (working-state player unstable))
      )
   else
      (assert (working-state player disenabled)))
)

(defrule determine-power-state
   (working-state player disenabled)
   (not (power-state player ?))
   (not (repair ?))
=>
   (if (yes-or-no-p "Питание подаётся (yes/no)? ") then 
      (assert repair "Отнесите в сервисный центр")
   else
      (assert repair "Замените батарейки")
   )
)

(defrule determine-player-sound
   (working-state player stable)
   (playing-state player not-playing)
   (not (repair ?))
=>
   (if (not (yes-or-no-p "")))


)

(defrule unsatisfactory-engine-state-conclusions
   (declare (salience 10))
    ; Если двигатель работает неудовлетворительно
   (working-state engine unsatisfactory)
   =>
   (assert (charge-state battery charged))	; аккумулятор заряжен
   (assert (rotation-state engine rotates)))	; двигатель вращается

(defrule no-repairs
  (declare (salience -10))
  (not (repair ?))
  =>
  (assert (repair "Обратитесь в сервисную службу.")))

(defrule print-repair
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Рекомендации по ремонту:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

(defrule system-banner
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "ЭКСПЕРТНАЯ СИСТЕМА AUTOEXPERT")
  (printout t crlf crlf)
)