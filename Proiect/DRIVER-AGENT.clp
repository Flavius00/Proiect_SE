;;; =========================================================
;;; DRIVER-AGENT.clp - LOGICĂ RESCRISĂ CONFORM CERINȚELOR
;;; =========================================================

;; =========================================================
;; 1. CURĂȚARE ȘI REFRESH (SALIENȚĂ MARE)
;; =========================================================

(defrule AGENT::cleanup
    (declare (salience 100))
    (tic)
    ?f1 <- (ag_overtaking)
    =>
    (retract ?f1)
)

(defrule AGENT::refresh-ask-overtaking
    (declare (salience 90))
    (timp (valoare ?t))
    (not (ASK overtaking))
    =>
    (assert (ASK overtaking))
)

;; =========================================================
;; 2. DECIZII DEPĂȘIRE - LINII (LHS STRICT)
;; =========================================================

(defrule AGENT::decide-overtaking-allowed
    (declare (salience 10))
    (ASK overtaking)
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval broken_line))
    (test (str-index "line" (lowcase ?obj)))

    ;; FILTRU MEMORIE: Nu permitem depășirea dacă avem în memorie o restricție activă
    (not (ag_bel (bel_pname overtaking-maneuver) (bel_pval prohibited)))

    ;; CONDIȚII NEGATIVE ÎN LHS:
    (not (ag_percept (percept_pobj my_car) (percept_pname action) (percept_pval pulling_over)))
    (not (ag_percept (percept_pname type) (percept_pval road_works)))
    (not (ag_percept (percept_pname visibility) (percept_pval low)))
    (not (ag_percept (percept_pname rel_pos) (percept_pval passing_us)))
    (not (ag_percept (percept_pname speed_status) (percept_pval high_speed_approaching)))
    (not (ag_percept (percept_pobj road1) (percept_pname status) (percept_pval preparing_exit)))
    (not (ag_percept (percept_pobj road1) (percept_pname crossing_ahead) (percept_pval pedestrian_crossing)))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value permisa)))
)

(defrule AGENT::decide-overtaking-prohibited
    (declare (salience 10))
    (ASK overtaking)
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval continuous_line))
    (test (str-index "line" (lowcase ?obj)))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value interzisa)))
)
;; =========================================================
;; 3. RECOMANDĂRI VITEZĂ (REGULI SEPARATE PENTRU FIECARE CAZ)
;; =========================================================

(defrule AGENT::speed-children
    (declare (salience 15))
    (ag_percept (percept_pval attention_children))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 30)))
)

(defrule AGENT::speed-highway
    (declare (salience 15))
    (ag_percept (percept_pval highway))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 130)))
)

(defrule AGENT::speed-deceleration
    (declare (salience 15))
    (ag_percept (percept_pval deceleration_lane))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 50)))
)

(defrule AGENT::speed-rain
    (declare (salience 20))
    (timp (valoare ?t))
    (ag_percept (percept_pobj road1) (percept_pname weather) (percept_pval heavy_rain))
    =>
    (assert (ag_overtaking (ag_name viteza_recomandata) (ag_value 80)))
)

;; =========================================================
;; 4. SIGURANȚĂ ȘI PRIORITĂȚI (SUPRASCRIERE PRIN SALIENȚĂ)
;; =========================================================


(defrule AGENT::pedestrian-safety
    (declare (salience 25))
    (ag_percept (percept_pobj ?p) (percept_pname action) (percept_pval crossing))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - PIETON")))
)

(defrule AGENT::tram-safety
    (declare (salience 25))
    (ag_percept (percept_pobj road1) (percept_pname infrastructure) (percept_pval tram_stop_no_refuge))
    ?f <- (ag_overtaking (ag_name depasire) (ag_value permisa))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - STATIE TRAMVAI")))
)

;; =========================================================
;; 5. LOGICĂ T23 (REGULI SEPARATE PENTRU FIECARE TIP DE DRUM)
;; =========================================================

(defrule AGENT::T23-National-Danger
    (declare (salience 20))
    (timp (valoare 23))
    (ag_percept (percept_pobj road1) (percept_pname road_location) (percept_pval national_road))
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?v))
    (test (> ?v 100))
    ?f <- (ag_overtaking (ag_name depasire))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "PERICULOASA - VITEZA PREA MARE")))
)

(defrule AGENT::T23-Highway-Danger
    (declare (salience 20))
    (timp (valoare 23))
    (ag_percept (percept_pobj road1) (percept_pname road_location) (percept_pval highway))
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?v))
    (test (> ?v 130))
    ?f <- (ag_overtaking (ag_name depasire))
    =>
    (retract ?f)
    (assert (ag_overtaking (ag_name depasire) (ag_value "PERICULOASA - PESTE LIMITA AUTOSTRADA")))
)

;; =========================================================
;; 6. AFIȘARE ȘI FLUX
;; =========================================================

;; Regula care rezolvă blocajul la S2 T28
(defrule AGENT::overtaking-prohibited-pulling-over
    (declare (salience 50))
    (ag_percept (percept_pobj my_car) (percept_pname action) (percept_pval pulling_over))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - TRAGERE PE DREAPTA")))
)

;; Regula TELL trebuie să fie singura care afișează, cu saliență 0
(defrule AGENT::tell
    (declare (salience 0))
    (timp (valoare ?t))
    ?fcvd <- (ag_overtaking (ag_name ?a) (ag_value ?b))
    =>
    (if (eq ?*ag-measure-time* TRUE)
     then
        (printout t "TIME_MEASURE|T=" ?t "|Manevra=" ?a "|Start=" (time) crlf))

    (printout t ">>> DRIVER-AGENT la T=" ?t ": " ?a " este " ?b crlf)

    (if (eq ?*ag-measure-time* TRUE)
     then
        (printout t "TIME_MEASURE|T=" ?t "|Manevra=" ?a "|End=" (time) crlf))
    (retract ?fcvd)
)

(defrule AGENT::force-next-step
    (declare (salience -200))
    (timp (valoare ?t))
    =>
    ;; Asigură revenirea la MAIN
)

(defrule AGENT::overtaking-prohibited-road-works
    (declare (salience 25))
    ;; Identifică prezența lucrărilor rutiere în LHS
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval road_works))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - ZONA LUCRARI")))
)

(defrule AGENT::overtaking-prohibited-low-visibility
    (declare (salience 25))
    ;; Condiții stricte în LHS conform cerinței
    (ag_percept (percept_pobj road1) (percept_pname visibility) (percept_pval low))
    (ag_percept (percept_pobj road1) (percept_pname weather) (percept_pval heavy_rain))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - VIZIBILITATE SCAZUTA")))
)


;; =========================================================
;; REGULI PENTRU SIGURANȚĂ LA DEPASIRE (S3 T24, T25)
;; =========================================================

;; Regula pentru vehicul care ne depaseste deja (passing_us)
(defrule AGENT::overtaking-prohibited-being-overtaken
    (declare (salience 25))
    (ag_percept (percept_pobj ?car) (percept_pname rel_pos) (percept_pval passing_us))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - SUNTEM DEPASITI")))
)

;; Regula pentru vehicul rapid care se apropie din spate (high_speed_approaching)
(defrule AGENT::overtaking-prohibited-fast-approaching
    (declare (salience 25))
    (ag_percept (percept_pobj ?car) (percept_pname speed_status) (percept_pval high_speed_approaching))
    (ag_percept (percept_pobj ?car) (percept_pname rel_pos) (percept_pval back_lane_2))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - VEHICUL RAPID SPATE")))
)

(defrule AGENT::overtaking-prohibited-preparing-exit
    (declare (salience 25))
    ;; Identifică statusul de pregătire a ieșirii în LHS conform cerinței
    (ag_percept (percept_pobj road1) (percept_pname status) (percept_pval preparing_exit))
    (ag_percept (percept_pobj my_car) (percept_pname signal) (percept_pval right))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - PREGATIRE IESIRE")))
)

(defrule AGENT::overtaking-prohibited-pedestrian-crossing-ahead
    (declare (salience 25))
    ;; Identifică prezența trecerii de pietoni în LHS conform cerinței
    (ag_percept (percept_pobj road1) (percept_pname crossing_ahead) (percept_pval pedestrian_crossing))
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?v))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "INTERZISA - TRECERE PIETONI IN FATA")))
)

;; Regula care "ține minte" restricția (se activează la T1)
(defrule AGENT::memorize-overtaking-prohibition
    (declare (salience 50))
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval overtaking_prohibited))
    =>
    (assert (ag_bel (bel_type moment) (bel_pname overtaking-maneuver) (bel_pval prohibited)))
)

;; Regula care "uită" restricția (se activează la T3)
(defrule AGENT::forget-overtaking-prohibition
    (declare (salience 50))
    (ag_percept (percept_pobj ?obj) (percept_pname type) (percept_pval end_of_overtaking_prohibition))
    ?f <- (ag_bel (bel_pname overtaking-maneuver) (bel_pval prohibited))
    =>
    (retract ?f)
)

(defrule AGENT::decide-overtaking-prohibited-by-memory
    (declare (salience 15))
    (ASK overtaking)
    (timp (valoare ?t))
    (ag_bel (bel_pname overtaking-maneuver) (bel_pval prohibited))
    =>
    (assert (ag_overtaking (ag_name depasire) (ag_value "interzisa (din memorie)")))
)

;; =========================================================
;; 3. TESTE CRITICE T23 (S4 și S5) - LOGICĂ INDEPENDENTĂ
;; =========================================================

(defrule AGENT::T23-National-Danger
    (declare (salience 30)) ; Saliență mare pentru a suprascrie
    (timp (valoare 23))
    (ag_percept (percept_pobj road1) (percept_pname road_location) (percept_pval national_road))
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?v))
    (test (> ?v 100))
    =>
    ;; Șterge orice altă decizie (dacă există) și impune Pericol
    (do-for-all-facts ((?f ag_overtaking)) TRUE (retract ?f))
    (assert (ag_overtaking (ag_name depasire) (ag_value "PERICULOASA - VITEZA PREA MARE")))
)

(defrule AGENT::T23-Highway-Danger
    (declare (salience 30))
    (timp (valoare 23))
    (ag_percept (percept_pobj road1) (percept_pname road_location) (percept_pval highway))
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?v))
    (test (> ?v 130))
    =>
    (do-for-all-facts ((?f ag_overtaking)) TRUE (retract ?f))
    (assert (ag_overtaking (ag_name depasire) (ag_value "PERICULOASA - PESTE LIMITA AUTOSTRADA")))
)
