; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulul MAIN - Trebuie declarat primul
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule MAIN
    (export deftemplate initial-fact)
    (export deftemplate tic)
)

(deftemplate MAIN::initial-fact)
(deftemplate MAIN::tic)

(defglobal MAIN
    ?*main-in-debug* = FALSE
    ?*ag-tic-in-debug* = FALSE
)

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulul PERCEPT-MANAGER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule PERCEPT-MANAGER
    (import MAIN deftemplate initial-fact)
    (import MAIN deftemplate tic)
    (export deftemplate timp)
    (export deftemplate ag_percept)
)

(deftemplate PERCEPT-MANAGER::timp (slot valoare))

(deftemplate PERCEPT-MANAGER::ag_percept 
    (slot percept_pobj)
    (slot percept_pname) 
    (slot percept_pval)
    (slot percept_pdir)
)

(defglobal PERCEPT-MANAGER
    ?*sim-in-debug* = FALSE
    ?*percepts-in-debug* = FALSE
    ?*perceptsDir* = "./percepts/"
    ?*scenariu* = "s1"
)

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulul AGENT - Declarația modulului trebuie să preceadă defglobal-ul său
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule AGENT
    (import MAIN deftemplate initial-fact)
    (import PERCEPT-MANAGER deftemplate timp)
    (import PERCEPT-MANAGER deftemplate ag_percept)
    (export deftemplate ag_bel)    
    (export deftemplate ag_overtaking) 
)

; Acum variabila globala va fi recunoscuta deoarece modulul AGENT a fost definit mai sus
(defglobal AGENT
    ?*ag-measure-time* = TRUE ; Switch-ul activat pentru masuratori
    ?*ag-in-debug* = FALSE
    ?*ag-percepts-in-debug* = FALSE
)

(deftemplate AGENT::ag_bel
    (slot bel_type) 
    (slot bel_timeslice) 
    (slot bel_pname) 
    (slot bel_pval) 
    (slot bel_pdir)
)

(deftemplate AGENT::ag_overtaking 
    (slot ag_name)
    (slot ag_value)
)