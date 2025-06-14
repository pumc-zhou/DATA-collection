use "C:\Users\XuQi\Desktop\cfps2010.dta", clear

*不控制任何变量
reg lninc college, vce(cluster provcd)

*对hukou实施精确匹配
teffects nnmatch (lninc) (college), ematch(hukou)

*同时对hukou、age、gender、race、sibling和fmedu实施精确匹配
teffects nnmatch (lninc) (college), ematch(hukou age gender race sibling fmedu)
teffects nnmatch (lninc) (college), ematch(hukou age gender race sibling fmedu) osample(overlap) 
tab overlap

*马氏匹配
teffects nnmatch (lninc age race sibling) (college), ematch(hukou gender fmedu)
teffects nnmatch (lninc age race sibling) (college), ematch(hukou gender fmedu) nneighbor(4) vce(robust, nn(4))
teffects nnmatch (lninc age race sibling) (college), ematch(hukou gender fmedu) nneighbor(4) vce(robust, nn(4)) ///
         biasadj(age race sibling)
teffects nnmatch (lninc age race sibling) (college), ematch(hukou gender fmedu) nneighbor(4) vce(robust, nn(4)) ///
         biasadj(age race sibling) atet

*粗化精确匹配
imb hukou age gender race sibling fmedu, treatment(college)

cem hukou age (30 35 40 45 50) gender race sibling fmedu(#0), treatment(college)
cem hukou age (#6) gender race sibling fmedu (#0), treatment(college)
cem hukou age gender race sibling fmedu (#0), treatment(college)

reg lninc college [iw=cem_weights]
reg lninc college hukou age gender race sibling i.fmedu [iw=cem_weights]
