*命令安装
ssc install synth, replace
ssc install synth2, all replace
ssc install allsynth, all replace

*打开数据
use "C:\Users\XuQi\Desktop\smoking.dta", clear

*绘图
twoway (line cigsale year if state==3, xline(1988, lpattern(shortdash) lcolor(black))) || (line cigsale year if state==1, lpattern(dash)), legend(label(1 "California") label(2 "Alabama"))

bysort year : egen mcigsale=mean(cigsale) if state!=3
twoway (line cigsale year if state==3, xline(1988, lpattern(shortdash) lcolor(black))) || (line mcigsale year, lpattern(dash)), legend(label(1 "California") label(2 "mean of the rest states"))

*设置为追踪数据
xtset state year

*使用synth
synth cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) nested figure

*使用synth2
synth2 cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) nested

*安慰剂检验
synth2 cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) nested placebo(unit cutoff(2)) sigf(6)

*伪干预时间检验
synth2 cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) nested placebo(period(1985))

*去除一个有影响的控制组个案
synth2 cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) nested loo

*偏差校正
allsynth cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) bcorrect(merge) gapfigure(classic bcorrect) keep(smokingresults) nested replace
allsynth cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, trunit(3) trperiod(1989) xperiod(1980(1)1988) bcorrect(merge) gapfigure(bcorrect placebos) pvalues keep(smokingresults) nested replace sigf(6)

*多名干预对象
gen treat=1 if state==3 | state==7
replace treat=0 if treat==.

gen treatyear=1989 if state==3 | state==7

*计算平均干预效应
allsynth cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, xperiod(1980(1)1988) bcorrect(merge) keep(smokingresults) nested replace stacked(trunits(treat) trperiods(treatyear), clear figure(classic bcorrect))

*执行安慰剂检验
allsynth cigsale cigsale(1975) cigsale(1980) cigsale(1988) beer(1984(1)1988) lnincome retprice age15to24, xperiod(1980(1)1988) bcorrect(merge) keep(smokingresults) nested replace sigf(6) pvalues stacked(trunits(treat) trperiods(treatyear), clear figure(bcorrect placebos))
