(defrule determine-rotation-state
   (working-state engine does-not-start)
   (not (rotation-state engine ?))
   (not (repair ?))   
   =>
   (if (yes-or-no-p "Двигатель вращается (yes/no)? ")
       then	(assert (rotation-state engine rotates))             ; двигатель вращается	
	          (assert (spark-state engine irregular-spark))   ; плохая искра
       
       else (assert (rotation-state engine does-not-rotate))    ; двигатель не вращается
              (assert (spark-state engine does-not-spark)))      ; нет искры
)

(defrule determine-gas-level
   (working-state engine does-not-start)
   (rotation-state engine rotates)
   (not (repair ?))
   =>
   (if (not (yes-or-no-p "В баке имеется топливо (yes/no)? "))
       then  (assert (repair "Добавить топливо."))))

(defrule determine-battery-state
   (rotation-state engine does-not-rotate)
   (not (charge-state battery ?))    ; состояние аккумулятора еще не определено
   (not (repair ?))
   =>
   (if (yes-or-no-p "Аккумулятор заряжен (yes/no)? ")
       then	  
        (assert (charge-state battery charged)) ; аккумулятор заряжен
       else
	    (assert (repair "Зарядите аккумулятор."))  ; рекомендация
	     (assert (charge-state battery dead))))  ; аккумулятор разряжен

(defrule determine-low-output
   (working-state engine unsatisfactory)
    ;	мощность работы двигателя еще не определена
   (not (symptom engine low-output | not-low-output))
   (not (repair ?))
   =>
   (if (yes-or-no-p "Выходная мощность двигателя низкая(yes/no)? ")
       then
	(assert (symptom engine low-output))  ; низкая выходная мощность двигателя
       else
	(assert (symptom engine not-low-output)))) ; нормальная мощность двигателя

 (defrule determine-point-surface-state
   (or (and (working-state engine does-not-start) ; не заводится      
            (spark-state engine irregular-spark))   ; и плохая искра
       (symptom engine low-output))               ; или низкая мощность 
   (not (repair ?))
   =>
   (bind ?response 
(ask-question "Каково состояние контактов (norm/opal/zagr)? "
             norm opal zagr))
   (if (eq ?response opal) 
       then 
	(assert (repair "Замените контакты."))  ; рекомендация
       else (if (eq ?response zagr)
                then
		 (assert (repair "Почистите контакты."))))) ; рекомендация

(defrule determine-conductivity-test
   (working-state engine does-not-start)      
   (spark-state engine does-not-spark)              ; нет искры
   (charge-state battery charged)		  ; аккумулятор заряжен
   (not (repair ?))
   =>
   (if (yes-or-no-p "Катушка зажигания пропускает ток (yes/no)? ")
       then
	(assert (repair "Замените распределительные провода.")) ; рекомендация
       else
	(assert (repair "Замените катушку зажигания.")))) ; рекомендация

(defrule determine-sluggishness
   (working-state engine unsatisfactory)
   (not (repair ?))
   =>
   (if (yes-or-no-p "Машина ведет себя инертно (yes/no)? ")
       then
	(assert (repair "Прочистите систему подачи топлива.")))) ; рекомендация

(defrule determine-misfiring
   (working-state engine unsatisfactory)
   (not (repair ?))
   =>
   (if (yes-or-no-p "Перебои с зажиганием есть(yes/no)? ")
       then
	(assert (repair "Отрегулируйте зазоры между контактами.")) ; рекомендация      
	(assert (spark-state engine irregular-spark)))) ; Плохая искра

(defrule determine-knocking
   (working-state engine unsatisfactory)
   (not (repair ?))
   =>
   (if (yes-or-no-p "Двигатель стучит (yes/no)? ")
       then
	 (assert (repair "Отрегулируйте зажигание.")))) ; рекомендация

(defrule normal-engine-state-conclusions
   (declare (salience 10))
   (working-state engine normal)    ; Если двигатель работает нормально
   =>
   (assert (repair "Ремонт не нужен."))     ; ремонт не нужен
   (assert (spark-state engine normal))      ; зажигание в норме
   (assert (charge-state battery charged))   ; аккумулятор заряжен
   (assert (rotation-state engine rotates))) ; двигатель вращается

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