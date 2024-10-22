; working-state:
; 1. stable
; 2. unstable
; 3. disabled
; 
; power-state
; 1. charged
; 2. discharged
;
; sound-state
; 1. playing
; 2. not-playing
;
; screen-state
; 1. ok
; 2. wrong
; 3. dead
;
; music-state
; 1. playing
; 2. wrong
; 3. not-playing
;

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

; Diagnosis 1: working-state
; rule 1
(defrule determine-working-state
   (not (working-state player ?))
   (not (repair ?))
   =>
   (if (yes-or-no-p "Плеер запускается (yes/no)? ") then 
      (if (yes-or-no-p "Плеер работает стабильно (yes/no)? ") then 
         (assert (working-state player stable))
      else
         (assert (working-state player unstable))
      )
   else
      (assert (working-state player disabled)))
)

; Diagnosis 2: power-state
; rule 2
(defrule determine-power-state
   (working-state player disabled)
   (not (power-state player ?))
   (not (repair ?))
=>
   (if (yes-or-no-p "Питание подаётся (yes/no)? ") then
      (assert (repair "Необходимо отнести устройство в сервисный центр"))
   else
      (assert (repair "Необходимо заменить батарейки"))
   )
)

; Diagnosis 3: sound-state
(defrule determine-sound-state
   (declare (salience -1))
   (not (sound-state player ?))
   (not (repair ?))
=>
   (if (yes-or-no-p "Есть ли звук? (yes/no) ") then
      (assert (sound-state player playing))
   else
      (assert (sound-state player not-playing))
   )
)

; Diagnosis 4: screen-state
(defrule determine-screen-state
   (declare (salience -1))
   (not (screen-state player ?))
   (not (repair ?))
=>
   (bind ?response 
      (ask-question "Каково состояние экрана? (ok/wrong/dead) " ok wrong dead))
   (if (eq ?response ok) then
      (assert (screen-state player ok))
   )
   (if (eq ?response wrong) then
      (assert (screen-state player wrong))
   )
   (if (eq ?response dead) then
      (assert (screen-state player dead))
   )
)

; Diagnosis 5: music-state
(defrule determine-music-state
   (declare (salience -1))
   (not (music-state player ?))
   (not (repair ?))
=>
   (if (yes-or-no-p "Музыка проигрывается? (yes/no) ") then
      (if (yes-or-no-p "Проигрывается корректно? (yes/no) ") then 
         (assert (music-state player playing))
      else
         (assert (music-state player wrong))
      )
   else
      (assert (music-state player not-playing))
   )
)

; rule 3
(defrule determine-tracks-state
   (working-state player unstable)
   (music-state player not-playing)
   (not (tracks-state player ?))
   (not (repair ?))
=>
   (if (not (yes-or-no-p "Есть ли в нём треки? (yes/no) ")) then
      (assert (tracks-state player tracks-missing))
      (assert (repair "Необходимо загрузить треки"))
   else
      (assert (tracks-state player tracks-presented))
   )
   
)

; rule 4
(defrule determine-output-state
   (working-state player unstable)
   (music-state player not-playing)
   (tracks-state player tracks-presented)
   (not (output-state player ?))
   (not (repair ?))
=>
   (if (yes-or-no-p "Есть ли повреждения аудиовыхода? (yes/no) ") then
      (assert (output-state player damaged))
      (assert (repair "Необходимо отнести устройство в сервисный центр"))
   else
      (assert (output-state player normal))
   )
)

; rule 5, 6
(defrule determine-software-state
   (working-state player unstable)
   (or 
      (and (music-state player not-playing)
           (tracks-state player tracks-presented)
           (output-state player normal)
      )
      (and (sound-state player playing)
           (screen-state player wrong)
      )
   )
   (not (software-state player ?))
   (not (repair ?))
=>
   (assert (repair "Необходимо подключить плеер к компьютеру, выполнить 
   синхронизацию, и переустановить ПО плеера"))
)

; rule 7
(defrule determine-memory-state
   (working-state player unstable)
   (music-state player wrong)
   (not (repair ?))
=>
   (assert (repair "Необходимо присоединить плеер к компьютеру и 
   проверить память"))

)

; rule 8
(defrule determine-mech-error-state
   (working-state player unstable)
   (screen-state player dead)
   (not (repair ?))
=>
   (assert (repair "Необходимо отнести устройство в сервисный центр"))
)

; rule 9
(defrule no-repairs
  (declare (salience -10))
  (not (repair ?))
=>
  (assert (repair "Не удалось определить неисправность. Обратитесь в службу поддержки")))

(defrule normal-player-state-conclusions
   (declare (salience 10))
   (working-state player stable)
=>
   (assert (repair "Ремонт не требуется"))
)

; Если плеер работает нестабильно, то он как минимум запускается
(defrule unstable-player-state-conclusions
   (declare (salience 10)) 
   (working-state player unstable)
=>
   (assert (power-state player charged))
)

(defrule print-repair
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Рекомендации по ремонту:")
  (printout t crlf crlf)
  (format t "%s%n%n" ?item))

(defrule system-banner
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Экспертная система PlayerExpert")
  (printout t crlf crlf)
)