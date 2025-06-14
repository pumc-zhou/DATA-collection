use "C:\Users\XuQi\Desktop\birthweight.dta", clear

*以mrace为协变量实施精确匹配
teffects nnmatch (bweight) (mbsmoke), ematch(mrace)
teffects nnmatch (bweight) (mbsmoke), ematch(mrace) atet

*以mage、medu、mrace、nprenatal、mmarried、deadkids、fbaby为协变量实施精确匹配
teffects nnmatch (bweight) (mbsmoke), ematch(mage medu mrace nprenatal mmarried deadkids fbaby) osample(overlap)

*以mage、medu、mrace、nprenatal、mmarried、deadkids、fbaby为协变量实施马氏匹配
teffects nnmatch (bweight mage medu mrace nprenatal mmarried deadkids fbaby) (mbsmoke)
teffects nnmatch (bweight mage medu mrace nprenatal mmarried deadkids fbaby) (mbsmoke), atet

*1对4马氏匹配，偏差矫正
teffects nnmatch (bweight mage medu mrace nprenatal mmarried deadkids fbaby) (mbsmoke), nneighbor(4) vce(robust, nn(4)) biasadj(mage medu mrace nprenatal mmarried deadkids fbaby)
teffects nnmatch (bweight mage medu mrace nprenatal mmarried deadkids fbaby) (mbsmoke), nneighbor(4) vce(robust, nn(4)) biasadj(mage medu mrace nprenatal mmarried deadkids fbaby) atet

*计算不平衡指数L1
imb mage medu mrace nprenatal mmarried deadkids fbaby, treatment(mbsmoke)

*粗化精确匹配
cem mage medu mrace nprenatal mmarried deadkids fbaby, treatment(mbsmoke)
cem mage medu (9 12) mrace nprenatal mmarried deadkids fbaby, treatment(mbsmoke)

*统计分析
reg bweight mbsmoke [iw=cem_weights]
reg bweight mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby [iw=cem_weights]
