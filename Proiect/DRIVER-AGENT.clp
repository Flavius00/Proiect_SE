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
    (declare (salience 50))
    (tic)
    ?f1 <- (ag_bel)
    ?f2 <- (ag_overtaking) ; Adaugă și acest tip de fapt pentru ștergere
    =>
    (retract ?f1)
    (retract ?f2)
)
(defrule AGENT::decide-overtaking
    (declare (salience 10))
    (timp (valoare ?t)) 
    (ASK overtaking)
    ;; Modificăm aici să caute obiecte care sunt marcaje (linii), nu indicatoare
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval ?type))
    (test (str-index "line" (lowcase ?obj))) ; Se asigură că obiectul este o linie
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

(defrule AGENT::decide-overtaking-T23-complex
    (declare (salience 15))
    (timp (valoare 23))
    (ASK overtaking)
    (ag_percept (percept_pobj line1) (percept_pname type) (percept_pval broken_line))
    (ag_percept (percept_pobj road1) (percept_pname road_location) (percept_pval ?loc))
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?v))
    =>
    (bind ?status permisa)
    ;; Ajustăm pragul de viteză în funcție de locație (National Road vs Highway)
    (if (and (eq ?loc national_road) (> ?v 100)) then (bind ?status "PERICULOASA - VITEZA PREA MARE"))
    (if (and (eq ?loc highway) (> ?v 130)) then (bind ?status "PERICULOASA - PESTE LIMITA AUTOSTRADA"))
    
    (assert (ag_overtaking (ag_name depasire) (ag_value ?status)))
)

(defrule AGENT::uneven-road-speed
    (declare (salience 15))
    (ag_percept (percept_pobj road1) (percept_pname surface) (percept_pval uneven))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 60)))
)
(defrule AGENT::emergency-vehicle-priority
    (declare (salience 30))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ?v) (percept_pname isa) (percept_pval emergency_vehicle))
    (ag_percept (percept_pobj ?v) (percept_pname status) (percept_pval approaching_from_back))
    =>
    ; Punem direct interdicția, cleanup va avea grijă să șteargă restul
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - CEDARE TRECERE AMBULANTA")))
)

(defrule AGENT::hazard-pothole-safety
    (declare (salience 20))
    (ag_percept (percept_pobj road1) (percept_pname hazard) (percept_pval pothole_on_lane_1))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 20)))
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - OCOLIRE OBSTACOL")))
)

(defrule AGENT::tram-station-safety
    (declare (salience 25))
    (ag_percept (percept_pobj road1) (percept_pname infrastructure) (percept_pval tram_stop_no_refuge))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - STATIE TRAMVAI")))
)

(defrule AGENT::refresh-ask-overtaking
    (declare (salience 60)) ; Prioritate mai mare decât cleanup
    (timp (valoare ?t))
    (not (ASK overtaking))
    =>
    (assert (ASK overtaking))
)
(defrule AGENT::exit-safety-logic
    (declare (salience 25))
    (timp (valoare ?t))
    ;; Detectăm că suntem în faza de ieșire
    (ag_percept (percept_pobj road1) (percept_pname status) (percept_pval preparing_exit|exit_ramp))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - IESIRE AUTOSTRADA")))
)
(defrule AGENT::being-overtaken-safety
    (declare (salience 25))
    (timp (valoare ?t))
    ;; Detectăm că un alt vehicul ne depășește în acest moment
    (ag_percept (percept_pobj ?v) (percept_pname rel_pos) (percept_pval passing_us))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - SUNTEM DEPASITI")))
)
(defrule AGENT::aquaplaning-safety
    (declare (salience 25))
    (timp (valoare ?t))
    ;; Detectăm riscul de acvaplanare din perceptul road1
    (ag_percept (percept_pobj road1) (percept_pname surface_condition) (percept_pval aquaplaning_risk))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - RISC ACVAPLANARE")))
)

(defrule AGENT::exit-construction-safety
    (declare (salience 25))
    (timp (valoare ?t))
    ;; Detectăm faza de ieșire din zona de lucru
    (ag_percept (percept_pobj road1) (percept_pname status) (percept_pval exit_construction_zone))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - IESIRE ZONA LUCRARI")))
)

(defrule AGENT::low-visibility-safety
    (declare (salience 25))
    (timp (valoare ?t))
    ;; Detectăm vizibilitatea scăzută din perceptul drumului
    (ag_percept (percept_pobj road1) (percept_pname visibility) (percept_pval low))
    ;; Opțional, putem verifica și dacă plouă torențial pentru context suplimentar
    (ag_percept (percept_pobj road1) (percept_pname weather) (percept_pval heavy_rain))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - VIZIBILITATE SCAZUTA")))
)
(defrule AGENT::road-works-safety
    (declare (salience 25))
    (timp (valoare ?t))
    ;; Detectăm indicatorul de lucrări rutiere
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval road_works))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - ZONA LUCRARI")))
)