/*Econ504_Replication_Cheng-Yu_Ko_14559056*/
cd "D:\Studies\UMich\MAE Program\2022 Winter\ECON 504\08. Replication due Apr 11 by 8PM\02. Datasets"
log using Econ504_Replication_Cheng-Yu_Ko_14559056.log, replace

ssc install asdoc, replace
ssc install outreg2, replace

/***(ii)***/

/**Sample Statistics: Table 1**/
/*For the Households*/
use "ABChousehold.dta", clear

asdoc sum age hhhead assets cellphoneowner usecellphone if year==2009, by(abc) label stat(mean sd) dec(2) title(Table 1, Panel A: Household) replace

ttest age if year==2009, by (abc)
ttest hhhead if year==2009, by (abc)
ttest assets if year==2009, by (abc)
ttest cellphoneowner if year==2009, by (abc)
ttest usecellphone if year==2009, by (abc)
/*asdoc ttest age if year==2009, by(abc) replace*/

/*For the Teachers*/
use "ABCteacher.dta", clear

asdoc sum teacherage femaleteacher local levelno if year==2009, by(abc) label stat(mean sd) dec(2) title(Table 1, Panel B: Teacher) append

ttest levelno if year==2009, by (abc)
ttest teacherage if year==2009, by (abc)
ttest femaleteacher if year==2009, by (abc)
ttest local if year==2009, by (abc)


/*For the Testscore*/
use "ABCtestscore.dta", clear

asdoc sum mathzscore writezscore if year==2009, by(abc) label stat(mean sd) dec(2) title(Table 1, Panel C: Teat scores) append

ttest mathzscore if year==2009, by (abc)
ttest writezscore if year==2009, by (abc)



/***(iii)***/
use "ABCtestscore.dta", clear

keep if round==1|round==2|round==4

/*Model Specification 1*/
gen abcxpost = abc*post

reg mathzscore abc post abcxpost, robust
outreg2 using reg.doc, replace ctitle() dec(3)

reg writezscore abc post abcxpost, robust
outreg2 using reg.doc, append ctitle() dec(3)

/*Model Specification 2*/
reg mathzscore abc post abcxpost age female dosso zarma kanuri, robust
outreg2 using reg.doc, replace ctitle() addtext(contorls, YES) dec(3)

reg writezscore abc post abcxpost age female dosso zarma kanuri, robust
outreg2 using reg.doc, append ctitle() addtext(contorls, YES) dec(3)

/*Model Specification 3*/
gen agesq = age^2
reg mathzscore abc post abcxpost age agesq female dosso zarma kanuri, robust
outreg2 using reg.doc, replace ctitle() addtext(contorls, YES) dec(3)
test age agesq

reg writezscore abc post abcxpost age agesq female dosso zarma kanuri, robust
outreg2 using reg.doc, append ctitle() addtext(contorls, YES) dec(3)
test age agesq

/*Model Specification 4*/
qui tab codevillage, gen(village_dum)

reg mathzscore abc post abcpost age agesq female village_dum*, robust
outreg2 using reg.doc, replace ctitle() addtext(contorls, YES) dec(3)

reg writezscore abc post abcpost age agesq female village_dum*, robust
outreg2 using reg.doc, append ctitle() addtext(contorls, YES) dec(3)


log close
exit, clear