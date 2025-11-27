(ag_percept (percept_pobj ev9) (percept_pname isa) (percept_pval event))
(ag_percept (percept_pobj road1) (percept_pname isa) (percept_pval road))
(ag_percept (percept_pobj road_sign1) (percept_pname isa) (percept_pval road_sign))
(ag_percept (percept_pobj tunnel1) (percept_pname isa) (percept_pval tunnel))

(ag_percept (percept_pobj road1) (percept_pname partof) (percept_pval ev9))

(ag_percept (percept_pobj road_sign1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj road_sign1) (percept_pname type) (percept_pval tunnel))

(ag_percept (percept_pobj tunnel1) (percept_pname partof) (percept_pval road1))
(ag_percept (percept_pobj tunnel1) (percept_pname luminosity) (percept_pval 124))
(ag_percept (percept_pobj tunnel1) (percept_pname luminosity_after_1000ms) (percept_pval 456))