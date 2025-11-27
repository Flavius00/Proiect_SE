(ag_percept (percept_pobj ev3) (percept_pname isa) (percept_pval event))
(ag_percept (percept_pobj road1) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj lane1) (percept_pname isa) (percept_pval lane))
(ag_percept (percept_pobj my_car) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj car1) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj car2) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj length_car) (percept_pname isa) (percept_pval length))

(ag_percept (percept_pobj road1) (percept_pname partof) (percept_pval ev3))

(ag_percept (percept_pobj lane1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj lane2) (percept_pname partof) (percept_pval road1))

(ag_percept (percept_pobj my_car) (percept_pname partof) (percept_pval lane1))
(ag_percept (percept_pobj my_car) (percept_pname direction) (percept_pval north))
(ag_percept (percept_pobj my_car) (percept_pname speed) (percept_pval 80)) 

(ag_percept (percept_pobj car1) (percept_pname partof) (percept_pval lane1))
(ag_percept (percept_pobj car1) (percept_pname direction) (percept_pval north))
(ag_percept (percept_pobj car1) (percept_pname speed) (percept_pval 50)) 

(ag_percept (percept_pobj car2) (percept_pname partof) (percept_pval lane2))
(ag_percept (percept_pobj car2) (percept_pname direction) (percept_pval south))
(ag_percept (percept_pobj car2) (percept_pname speed) (percept_pval 65)) 

(ag_percept (percept_pobj car1) (percept_pname distance_to_my_car) (percept_pval 23))
(ag_percept (percept_pobj car2) (percept_pname distance_to_my_car) (percept_pval 60))

(ag_percept (percept_pobj length_car) (percept_pname value) (percept_pval 4))

