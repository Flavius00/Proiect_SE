;;----------------------------------
;;
;;    Overtaking
;;
;;----------------------------------

(defrule AGENT::cale_ferat
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev1))
    (ag_percept (percept_pobj railroad1) (percept_pname distance_to_my_car) (percept_pval ?v))
=>
    (if (< ?v 50) then  (printout t "La mai putin de 50 de metri de calea ferata."  crlf)
		        (assert (ag_overtaking (ag_name depasire) (ag_value interzisa)))
			(assert (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes)))
			(printout t "Depasire interzisa!"  crlf)
	          else  (printout t "Nu exista cale ferata la mai putin de 50 de metri."  crlf)
			(assert (ag_overtaking (ag_name depasire) (ag_value permisa)))
		        (printout t "Depasire permisa!"  crlf)
    )
)
(defrule AGENT::final_cale_ferata
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev1))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes))
    (ag_percept (percept_pobj road_sign2) (percept_pname type) (percept_pval railroad))
=>
    (printout t "S-a terminat calea ferata." crlf))
    (retract ?f)
)

(deffunction coloana(?d1 ?d2 ?s1 ?s2)
  (if (and (> 50 (+ ?d1 ?d2)) (> 20 (+ ?s1 ?s2))) then (return true)
  						  else (return false)
  )
)
(defrule AGENT::asteptare_coloana
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev2))
    (ag_percept (percept_pobj car2) (percept_pname distance_to_car1) (percept_pval ?d2))
    (ag_percept (percept_pobj car1) (percept_pname distance_to_my_car) (percept_pval ?d1))
    (ag_percept (percept_pobj car2) (percept_pname speed) (percept_pval ?s2))
    (ag_percept (percept_pobj car1) (percept_pname speed) (percept_pval ?s1))
    (test (eq (coloana ?d1 ?d2 ?s1 ?s2) true))
=>
    (printout t "Coloana."  crlf) 
    (assert (ag_overtaking (ag_name depasire) (ag_value interzisa)))
    (printout t "Depasire interzisa!"  crlf)
)

(deffunction deranjare(?s1 ?s2 ?mys ?d1 ?d2 ?l)
	(bind ?sf1 (- ?mys ?s1))
	(bind ?l2 (* 2 ?l))
	(bind ?d3 (+ ?d1 10))
	(bind ?df (+ ?d3 ?l2))
	(bind ?t1 (/  ?df ?sf1))
	(bind ?sf2 (+ ?mys ?s2))
	(bind ?d4 (+ ?d2 10))
	(bind ?t2 (/ ?d4 ?sf2))
  (if (> ?t1 ?t2) then (return true)
  		  else (return false)
  )
)
(defrule AGENT::deranjare_colegu
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev3))
    (ag_percept (percept_pobj car1) (percept_pname speed) (percept_pval ?s1)) 
    (ag_percept (percept_pobj car2) (percept_pname speed) (percept_pval ?s2)) 
    (ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval ?mys)) 
    (ag_percept (percept_pobj car1) (percept_pname distance_to_my_car) (percept_pval ?d1))
    (ag_percept (percept_pobj car2) (percept_pname distance_to_my_car) (percept_pval ?d2))
    (ag_percept (percept_pobj length_car) (percept_pname value) (percept_pval ?l))
    (test (eq (deranjare ?s1 ?s2 ?mys ?d1 ?d2 ?l) true))
=>
    (printout t "Deranjam colegu!"  crlf)
    (assert (ag_overtaking (ag_name depasire) (ag_value interzisa)))
    (printout t "Depasire interzisa!"  crlf)
)

(defrule AGENT::semn_depasire_interzisa
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev4))
    (ag_percept (percept_pobj road_sign1) (percept_pname type) (percept_pval ?v))
=>
    (if (eq ?v overtaking_prohibited) then (printout t "Semn pentru depasire interzisa."  crlf)
					   (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
                                           (assert (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes)))
					   (printout t "Depasire interzisa!"  crlf)
				      else (printout t "Nu este semn pentru depasire interzisa."  crlf)
					   (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
					   (printout t "Depasire permisa!"  crlf)
    )
)
(defrule AGENT::semn_depasire_permisa
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev1))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes))
    (ag_percept (percept_pobj road_sign2) (percept_pname type) (percept_pval overtaking_permitted))
=>
    (printout t "S-a terminat zona cu depasire interzisa." crlf))
    (retract ?f)
)

(defrule AGENT::intersectie_nesemnalizata
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev5))
    (ag_percept (percept_pobj intersection1) (percept_pname partof) (percept_pval ev5))
    (ag_percept (percept_pobj road_sign1) (percept_pname exists) (percept_pval ?c1))
    (ag_percept (percept_pobj traffic_light1) (percept_pname intermittent) (percept_pval ?c2))
    (ag_percept (percept_pobj officer1) (percept_pname exists) (percept_pval ?c3))
=>
    (if (and (and (eq ?c1 false) (eq ?c2 true)) (eq ?c3 false)) then (printout t "Intersectie nesemnalizata."  crlf) 
								     (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
								     (printout t "Depasire interzisa!"  crlf) 
							        else (printout t "Intersectie semnalizata. "  crlf) 
								     (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
								     (printout t "Depasire permisa! "  crlf) 
    )
)

(defrule AGENT::linie_continua
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev6))
    (ag_percept (percept_pobj line1) (percept_pname type) (percept_pval ?v))
=>
        (if (eq ?v continuous_line) then (printout t "Linie continua."  crlf)
					 (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
				   	 (printout t "Depasire interzisa! "  crlf)
				    else (printout t "Nu este linie continua."  crlf)
				         (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
					 (printout t "Depasire permisa! "  crlf)
        )
)

(defrule AGENT::statie_tramvai_fara_refugiu
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev7))
    (ag_percept (percept_pobj tram1) (percept_pname partof) (percept_pval ?lane2))
    (ag_percept (percept_pobj ?lane2) (percept_pname type) (percept_pval ?v))
=>
        (if (eq ?v basic_lane) then (printout t "Tramvai in statie fara refugiu."  crlf)
				    (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
				    (printout t "Depasire interzisa! "  crlf)
			       else (printout t "Statie cu refugiu."  crlf)
				    (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
				    (printout t "Depasire permisa! "  crlf)
        )
)

(defrule AGENT::trecere_pietoni
	(declare (salience 100))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev8))
    (ag_percept (percept_pobj road_sign1) (percept_pname type) (percept_pval ?v))
=>
    (if (eq ?v pedestrian_crossing) then (printout t "Trecere de pietoni semnalizata."  crlf)
					 (assert (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes)))
					 (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
					 (printout t "Depasire interzisa! "  crlf)
				    else (printout t "Nu este trecere de pietoni."  crlf)
					 (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
					 (printout t "Depasire permisa! "  crlf)
    )
)
(defrule AGENT::final_trecere_pietoni
	(declare (salience -100))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev8))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes))
    (ag_percept (percept_pobj road_sign2) (percept_pname type) (percept_pval pedestrian_crossing))
=>
    (printout t "Ati trecut de trecerea de pietoni." crlf))
    (retract ?f)
)

(defrule AGENT::tunel
	(declare (salience 100))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev9))
    (ag_percept (percept_pobj road_sign1) (percept_pname type) (percept_pval ?v))
=>
    (if (eq ?v tunnel) then (printout t "Esti in tunel."  crlf)
 			    (assert (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes)))
			    (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
			    (printout t "Depasire interzisa! "  crlf)
		       else (printout t "Nu esti in tunel."  crlf)
			    (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
			    (printout t "Depasire permisa! "  crlf)
    )
)
(deffunction iesire_tunel(?l1 ?l2)
  (if (< 300 (- ?l2 ?l1))  then (return true)
  						  else (return false)
  )
)

(defrule AGENT::final_tunel
	(declare (salience -100))
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev9))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-overtaking-zone) (bel_pval yes))
    (ag_percept (percept_pobj tunnel1) (percept_pname luminosity) (percept_pval ?l1))
    (ag_percept (percept_pobj tunnel1) (percept_pname luminosity_after_1000ms) (percept_pval ?l2))
    (test (eq (iesire_tunel ?l1 ?l2) true))
=>
    (printout t "Ati iesit din tunel." crlf))
    (retract ?f)
)

(defrule AGENT::vizibilitate_sub50
    (timp (valoare ?t))
    (ag_percept (percept_pobj ev10))
    (ag_percept (percept_pobj road1) (percept_pname visibility) (percept_pval ?v))
=>
        (if (< ?v 50) then (printout t "Vizibilitate redusa sub 50 de metri."  crlf)
			   (assert (ag_overtaking (ag_name depasire ) (ag_value interzisa)))
			   (printout t "Depasire interzisa! "  crlf)
		      else (printout t "Vizibilitatea este mai mare de 50 de metri."  crlf)
			   (assert (ag_overtaking (ag_name depasire ) (ag_value permisa)))
			   (printout t "Depasire permisa! "  crlf)
        )
)

;
;--------Print decision-----------------------------------
;

(defrule AGENT::tell
    (declare (salience -50))
    (timp (valoare ?)) ;make sure it fires each cycle
    (ASK ?bprop)
    ?fcvd <- (ag_overtaking (ag_name ?a) (ag_value ?b))
=>
    (printout t "AGENT: " ?a " " ?b crlf)
    (retract ?fcvd)
)
