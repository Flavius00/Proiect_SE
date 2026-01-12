;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  PERCEPT-MANAGER
;;
;;  Current percepts manipulation - REWRITTEN FOR STRICT LHS CONDITIONS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;------- Curatarea perceptiilor vechi ------------
(defrule PERCEPT-MANAGER::hk-ag_percepts
    (declare (salience 100)) ; Prioritate maximă
    (tic) ; GARDA: Se execută doar când MAIN pornește un nou ciclu
    ?fp <- (ag_percept (percept_pname ?pn) (percept_pval ?pv))
=>
    (retract ?fp)
)

;------- Avansare timp in cadrul aceluiasi scenariu ------------
(defrule PERCEPT-MANAGER::advance-time-same-scenario
    (declare (salience -95))
    ?tc <- (tic)
    ?tp <- (timp (valoare ?t))
    (test (< ?t 35)) ; Conditie mutata in LHS
=>
    (bind ?nt (+ 1 ?t))
    (retract ?tp)
    (assert (timp (valoare ?nt)))
    (retract ?tc)

    (bind ?cale (str-cat ?*perceptsDir* ?*scenariu* "/t" ?nt ".clp"))
    (printout t ">>> Incarcare: " ?cale crlf)
    (load-facts ?cale)
)

;------- Trecere de la Scenariul 1 la Scenariul 2 ------------
(defrule PERCEPT-MANAGER::switch-s1-to-s2
    (declare (salience -90))
    ?tc <- (tic)
    ?tp <- (timp (valoare 35))
    (test (eq ?*scenariu* "s1")) ; Decizie bazata pe starea variabilei in LHS
=>
    (retract ?tp)
    (retract ?tc)
    (bind ?*scenariu* "s2") ; Schimbare globala
    (assert (timp (valoare 1)))

    (bind ?cale (str-cat ?*perceptsDir* "s2/t1.clp"))
    (printout t ">>> Schimbare scenariu. Incarcare: " ?cale crlf)
    (load-facts ?cale)
)

;------- Trecere de la Scenariul 2 la Scenariul 3 ------------
(defrule PERCEPT-MANAGER::switch-s2-to-s3
    (declare (salience -90))
    ?tc <- (tic)
    ?tp <- (timp (valoare 35))
    (test (eq ?*scenariu* "s2"))
=>
    (retract ?tp)
    (retract ?tc)
    (bind ?*scenariu* "s3")
    (assert (timp (valoare 1)))

    (bind ?cale (str-cat ?*perceptsDir* "s3/t1.clp"))
    (printout t ">>> Schimbare scenariu. Incarcare: " ?cale crlf)
    (load-facts ?cale)
)

;------- Trecere de la Scenariul 3 la Scenariul 4 ------------
(defrule PERCEPT-MANAGER::switch-s3-to-s4
    (declare (salience -90))
    ?tc <- (tic)
    ?tp <- (timp (valoare 35))
    (test (eq ?*scenariu* "s3"))
=>
    (retract ?tp)
    (retract ?tc)
    (bind ?*scenariu* "s4")
    (assert (timp (valoare 1)))

    (bind ?cale (str-cat ?*perceptsDir* "s4/t1.clp"))
    (printout t ">>> Schimbare scenariu S3 -> S4. Incarcare: " ?cale crlf)
    (load-facts ?cale)
)

;------- Trecere de la Scenariul 4 la Scenariul 5 ------------
(defrule PERCEPT-MANAGER::switch-s4-to-s5
    (declare (salience -90))
    ?tc <- (tic)
    ?tp <- (timp (valoare 35))
    (test (eq ?*scenariu* "s4"))
=>
    (retract ?tp)
    (retract ?tc)
    (bind ?*scenariu* "s5")
    (assert (timp (valoare 1)))

    (bind ?cale (str-cat ?*perceptsDir* "s5/t1.clp"))
    (printout t ">>> Schimbare scenariu S4 -> S5. Incarcare: " ?cale crlf)
    (load-facts ?cale)
)

;------- Trecere de la Scenariul 5 la Scenariul 6 ------------
(defrule PERCEPT-MANAGER::switch-s5-to-s6
    (declare (salience -90))
    ?tc <- (tic)
    ?tp <- (timp (valoare 35))
    (test (eq ?*scenariu* "s5"))
=>
    (retract ?tp)
    (retract ?tc)
    (bind ?*scenariu* "s6")
    (assert (timp (valoare 1)))

    (bind ?cale (str-cat ?*perceptsDir* "s6/t1.clp"))
    (printout t ">>> Schimbare scenariu S5 -> S6. Incarcare: " ?cale crlf)
    (load-facts ?cale)
)

;------- Finalizare simulare la sfarsitul S6 ------------
(defrule PERCEPT-MANAGER::halt-simulation
    (declare (salience -90))
    ?tc <- (tic)
    (timp (valoare 35))
    (test (eq ?*scenariu* "s6"))  ; <-- Modificat din s3 in s6
=>
    (retract ?tc)
    (printout t "--- TOATE CELE 6 SCENARII S-AU FINALIZAT ---" crlf)
    (halt)
)
