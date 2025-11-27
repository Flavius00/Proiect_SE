(ag_percept (percept_pobj ev4) (percept_pname isa) (percept_pval event))
(ag_percept (percept_pobj road1) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj road_sign1) (percept_pname isa) (percept_pval road_sign))
(ag_percept (percept_pobj road_sign2) (percept_pname isa) (percept_pval road_sign))

(ag_percept (percept_pobj road1) (percept_pname partof) (percept_pval ev4))

(ag_percept (percept_pobj road_sign1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj road_sign1) (percept_pname type) (percept_pval overtaking_prohibited))

(ag_percept (percept_pobj road_sign2) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj road_sign2) (percept_pname type) (percept_pval overtaking_permitted))
