use "C:\Users\XuQi\Desktop\euro.dta", clear

*意大利与中国
twoway (line ddva1 year if reporter==11, xline(1999, lpattern(shortdash) lcolor(black))) || (line ddva1 year if reporter==4, lpattern(dash)), legend(label(1 "Italy") label(2 "China"))

*意大利与各国的均值
bysort year : egen mddva1=mean(ddva1) if reporter!=11
twoway (line ddva1 year if reporter==11, xline(1999, lpattern(shortdash) lcolor(black))) || (line mddva1 year, lpattern(dash)), legend(label(1 "Italy") label(2 "mean of the rest countries"))

*使用synth
xtset reporter year
synth ddva1 ddva1 log_distw sum_rgdpna comlang contig, trunit(11) trperiod(2000) xperiod(1995(1)1999) nested figure

*使用synth2计算干预效应
synth2 ddva1 ddva1 log_distw sum_rgdpna comlang contig, trunit(11) trperiod(2000) xperiod(1995(1)1999) nested

*使用synth2进行安慰剂检验
synth2 ddva1 ddva1 log_distw sum_rgdpna comlang contig, trunit(11) trperiod(2000) xperiod(1995(1)1999) nested placebo(unit cutoff(2)) sigf(6)

*留一法稳健性检验
synth2 ddva1 ddva1 log_distw sum_rgdpna comlang contig, trunit(11) trperiod(2000) xperiod(1995(1)1999) nested loo

*偏差校正
allsynth ddva1 ddva1 log_distw sum_rgdpna comlang contig, trunit(11) trperiod(2000) xperiod(1995(1)1999) nested bcorrect(merge) gapfigure(classic bcorrect) keep(euroresults) nested replace

*偏差校正法的安慰剂检验
allsynth ddva1 ddva1 log_distw sum_rgdpna comlang contig, trunit(11) trperiod(2000) xperiod(1995(1)1999) nested bcorrect(merge) gapfigure(bcorrect placebos) keep(euroresults) nested replace pvalues

