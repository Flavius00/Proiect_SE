(ag_percept (percept_pobj ev2) (percept_pname isa) (percept_pval event))
(ag_percept (percept_pobj road1) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj line1) (percept_pname isa) (percept_pval line))
(ag_percept (percept_pobj lane1) (percept_pname isa) (percept_pval lane))
(ag_percept (percept_pobj my_car) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj car1) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj car2) (percept_pname isa) (percept_pval car))

(ag_percept (percept_pobj road1) (percept_pname partof) (percept_pval ev2))

(ag_percept (percept_pobj line1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj line1) (percept_pname type) (percept_pval broken_white_line))

(ag_percept (percept_pobj lane1) (percept_pname partof) (percept_pval road1))

(ag_percept (percept_pobj my_car) (percept_pname partof) (percept_pval lane1))
(ag_percept (percept_pobj car1) (percept_pname partof) (percept_pval lane1))
(ag_percept (percept_pobj car2) (percept_pname partof) (percept_pval lane1))

(ag_percept (percept_pobj car2) (percept_pname distance_to_car1) (percept_pval 20))
(ag_percept (percept_pobj car1) (percept_pname distance_to_my_car) (percept_pval 26))
(ag_percept (percept_pobj car2) (percept_pname speed) (percept_pval 8))
(ag_percept (percept_pobj car1) (percept_pname speed) (percept_pval 7))


