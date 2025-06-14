use "C:\Users\XuQi\Desktop\cfps2010.dta", clear

*一元线性回归
reg lninc college, vce(cluster provcd)

*有放回的1对1匹配
teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu)

*带卡尺的1对1匹配
teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu), caliper(0.02)

teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu), caliper(0.02) osample(flag)
tab flag

teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02)

*带卡尺的1对4匹配
teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02) nneighbor(4) vce(robust, nn(4))

*平衡性检验
qui teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02)
tebalance summarize

qui teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02) nneighbor(4) vce(robust, nn(4))
tebalance summarize

qui teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02)
tebalance density age

qui teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02)
tebalance box age

*检查共同取值范围
qui teffects psmatch (lninc) (college hukou age gender race sibling i.fmedu) if flag==0, caliper(0.02)
teffects overlap

*psmatch2命令的使用
psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) caliper(0.02) common ate logit ties odds    //带卡尺的1对1匹配
psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) caliper(0.02) neighbor(4) common ate logit ties odds quietly    //带卡尺的1对4匹配
psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) caliper(0.02) radius common ate logit quietly   //半径匹配
psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) kernel common ate logit quietly   //核匹配

*平衡性检验
qui psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) kernel common ate logit quietly 
pstest, both graph

*检查共同取值范围
qui psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) kernel common ate logit quietly 
psgraph, bin(5)

*敏感性分析
psmatch2 college hukou age gender race sibling i.fmedu if flag==0, outcome(lninc) caliper(0.02) common logit ties odds quietly    //带卡尺的1对1匹配

gen diff=lninc-_lninc if _treated==1 & _support==1 & flag==0
rbounds diff, gamma(1 (1) 5)
rbounds diff, gamma(4 (0.1) 5)
