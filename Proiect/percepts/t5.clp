(ag_percept (percept_pobj ev5) (percept_pname isa) (percept_pval event))
(ag_percept (percept_pobj intersection1) (percept_pname isa) (percept_pval intersection))
(ag_percept (percept_pobj road1) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj road2) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj my_car) (percept_pname isa) (percept_pval car))
(ag_percept (percept_pobj road_sign1) (percept_pname isa) (percept_pval road_sign))
(ag_percept (percept_pobj traffic_light1) (percept_pname isa) (percept_pval traffic_light))
(ag_percept (percept_pobj officer1) (percept_pname isa) (percept_pval officer))

(ag_percept (percept_pobj intersection1) (percept_pname partof) (percept_pval ev5))

(ag_percept (percept_pobj road1) (percept_pname partof) (percept_pval intersection1))
(ag_percept (percept_pobj road2) (percept_pname partof) (percept_pval intersection1))

(ag_percept (percept_pobj my_car) (percept_pname partof) (percept_pval road1))

(ag_percept (percept_pobj road_sign1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj road_sign1) (percept_pname exists) (percept_pval false))

(ag_percept (percept_pobj traffic_light1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj traffic_light1) (percept_pname intermittent) (percept_pval true))

(ag_percept (percept_pobj officer1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj officer1) (percept_pname exists) (percept_pval false))
