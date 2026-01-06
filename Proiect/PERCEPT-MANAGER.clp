;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  PERCEPT-MANAGER
;;
;;  Current percepts manipulation
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
;-------Delete prior percepts ------------
;
(defrule PERCEPT-MANAGER::hk-ag_percepts
    (tic) ; to avoid deleting newly added percepts
    ?fp <- (ag_percept (percept_pname ?pn) (percept_pval ?pv))
=> 
    (if (eq ?*sim-in-debug* TRUE) then (printout t "    <D>hk-ag_percepts retract " ?pn " " ?pv crlf))
    (retract ?fp)
)

;
;-------Trecere la ciclul de timp urmator si adaugarea la WM a perceptii din acest ciclu------------
;
(defrule PERCEPT-MANAGER::advance-time-percepts
    (declare (salience -95))
    ?tc <- (tic)
    ?tp <- (timp (valoare ?t))
=>
    (bind ?nt (+ 1 ?t))
    (bind ?run-load TRUE) ; Variabilă de control
    
    (if (> ?nt 35) then 
        (if (eq ?*scenariu* "s1") then (bind ?*scenariu* "s2") (bind ?nt 1)
         else (if (eq ?*scenariu* "s2") then (bind ?*scenariu* "s3") (bind ?nt 1)
         else 
            (printout t "--- SIMULARE FINALIZATA ---" crlf)
            (bind ?run-load FALSE) ; Nu mai încărcăm nimic
            (halt))))

    (retract ?tp)
    (assert (timp (valoare ?nt)))
    (retract ?tc)

    (if (eq ?run-load TRUE) then
        (bind ?cale (str-cat ?*perceptsDir* ?*scenariu* "/t" ?nt ".clp"))
        (printout t ">>> Incarcare: " ?cale crlf)
        (load-facts ?cale))
)