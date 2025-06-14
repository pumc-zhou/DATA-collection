use "C:\Users\XuQi\Desktop\birthweight.dta", clear

*1对1匹配
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby)
psmatch2 mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, outcome(bweight) logit odds ties ate common

*带卡尺的1对1匹配
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby), caliper(0.02) osample(flag1)
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0, caliper(0.02) osample(flag2)
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0, caliper(0.02) osample(flag3)
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0, caliper(0.02) osample(flag4)
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0, caliper(0.02)

*带卡尺的1对4匹配
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0, caliper(0.02) nneighbor(4) osample(flag5)
teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0 & flag5==0, caliper(0.02) nneighbor(4)

*平衡性检验
qui teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0, caliper(0.02)
tebalance summarize

qui teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0 & flag5==0, caliper(0.02) nneighbor(4)
tebalance summarize

*检查倾向值的共同取值范围
qui teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0, caliper(0.02)
teffects overlap

qui teffects psmatch (bweight) (mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby) if flag1==0 & flag2==0 & flag3==0 & flag4==0 & flag5==0, caliper(0.02) nneighbor(4)
teffects overlap

*半径匹配
psmatch2 mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, outcome(bweight) logit odds ties common ate caliper(0.02) radius

*核匹配
psmatch2 mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, outcome(bweight) logit odds ties common ate kernel

*平衡性检验
qui psmatch2 mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, outcome(bweight) logit odds ties common ate caliper(0.02) radius
pstest, both graph

qui psmatch2 mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, outcome(bweight) logit odds ties common ate kernel
pstest, both graph

*敏感性分析
psmatch2 mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, outcome(bweight) logit odds ties common ate caliper(0.02)

gen diff=bweight-_bweight if _treated==1 & _support==1
rbounds diff, gamma(1 (0.1) 2)
