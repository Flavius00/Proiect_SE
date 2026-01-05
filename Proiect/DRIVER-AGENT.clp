;;; =========================================================
;;; DRIVER-AGENT.clp - LOGICĂ PENTRU TOATE SCENARIILE
;;; =========================================================

;; 1. DECIZIE DE DEPĂȘIRE (S1, S2, S3)
;; ---------------------------------------------------------

;; 2. RECOMANDARE VITEZĂ (S2 - Urban, S3 - Autostradă)
;; ---------------------------------------------------------
(defrule AGENT::speed-recommendation
    (declare (salience 15))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ?obj) (percept_pname ?prop) (percept_pval ?val))
    =>
    (if (eq ?val attention_children) then 
        (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 30))))
    
    (if (eq ?val highway) then 
        (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 130))))

    (if (eq ?val deceleration_lane) then 
        (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 50))))
)

;; 3. CORECȚIE PENTRU PIETONI (S2)
;; ---------------------------------------------------------
(defrule AGENT::pedestrian-safety
    (declare (salience 25))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ?p) (percept_pname action) (percept_pval crossing))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - PIETON")))
)

;; 4. AFIȘARE DECIZII (Regula TELL)
;; ---------------------------------------------------------

;; 5. CURĂȚARE (Să nu rămână credințe la schimbarea de cadru)
;; ---------------------------------------------------------
(defrule AGENT::cleanup
    (declare (salience -100))
    (tic)
    ?f <- (ag_bel)
    =>
    (retract ?f)
)
(defrule AGENT::decide-overtaking
    (declare (salience 10))
    ;; ADAUGA ACEASTA LINIE:
    (timp (valoare ?t)) 
    (ASK overtaking)
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval ?type))
    =>
    (bind ?status interzisa)
    (if (eq ?type broken_line) then (bind ?status permisa))
    (assert (ag_overtaking (ag_name depasire) (ag_value ?status)))
)

(defrule AGENT::tell
    (declare (salience 0))
    ;; SI AICI:
    (timp (valoare ?t)) 
    ?fcvd <- (ag_overtaking (ag_name ?a) (ag_value ?b))
    =>
    (printout t ">>> DRIVER-AGENT la T=" ?t ": " ?a " este " ?b crlf)
    (retract ?fcvd)
)

(defrule AGENT::force-next-step
    (declare (salience -200))
    ;; SI AICI:
    (timp (valoare ?t))
    =>
    ;; Aceasta regula se va executa MEREU, chiar daca cele de sus nu au match.
    ;; Ea asigura ca AGENT termina treaba si MAIN poate prelua focusul.
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D> AGENT: Pas terminat la T=" ?t crlf))
)

(defrule AGENT::rain-safety-speed
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_percept (percept_pobj road1) (percept_pname weather) (percept_pval heavy_rain))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 80)))
    (printout t ">>> AGENT T=" ?t ": Vizibilitate redusa (ploaie). Reducem viteza la 80." crlf)
)