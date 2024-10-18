(assert (student Ivanov C3)
        (student Petrov C4)
        (student Sidorov C1)
        (student Sergeev C2)
)

(facts)

(retract 2)

(facts)

(retract 3)
(assert (student Sidorov C2))

(facts)

(exit)