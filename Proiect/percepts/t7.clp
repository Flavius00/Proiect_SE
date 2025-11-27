(ag_percept (percept_pobj ev7) (percept_pname isa) (percept_pval event))
(ag_percept (percept_pobj road1) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj lane1) (percept_pname isa) (percept_pval lane))
(ag_percept (percept_pobj lane2) (percept_pname isa) (percept_pval lane))
(ag_percept (percept_pobj my_car) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj tram1) (percept_pname isa) (percept_pval tram))

(ag_percept (percept_pobj road1) (percept_pname partof) (percept_pval ev7))

(ag_percept (percept_pobj lane1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj lane1) (percept_pname type) (percept_pval basic_lane))

(ag_percept (percept_pobj lane2) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj lane2) (percept_pname type) (percept_pval basic_lane))
(ag_percept (percept_pobj lane2) (percept_pname leftof) (percept_pval lane1))

(ag_percept (percept_pobj my_car) (percept_pname partof) (percept_pval lane1))
(ag_percept (percept_pobj tram1) (percept_pname partof) (percept_pval lane2))


