
select FORDERSEQ,* from T_SAL_DELIVERYNOTICEENTRY t 
--update t set t.FORDERSEQ=m2."to" from  T_SAL_DELIVERYNOTICEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SAL_DELIVERYNOTICEENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FORDERSEQ and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";


select FSOENTRYID,* from T_SAL_DELIVERYNOTICEENTRY_E t
--update  t set t.FSOENTRYID=e.FORDERSEQ from T_SAL_DELIVERYNOTICEENTRY_E t 
inner join T_SAL_DELIVERYNOTICEENTRY e on t.FENTRYID=e.FENTRYID and t.FSOENTRYID<>e.FORDERSEQ;

select FSOENTRYID,* from T_SAL_OUTSTOCKENTRY_R t
--update t set t.FSOENTRYID=m2."to" from T_SAL_OUTSTOCKENTRY_R t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SAL_OUTSTOCKENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSOENTRYID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select FSOURCEBILLID,* from T_SAL_ORDERCHANGE t
--update t set t.FSOURCEBILLID=m2."to" from T_SAL_ORDERCHANGE t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_SAL_ORDERCHANGE'
inner join qnwb_id_map_all m2 on m2.source=t.FSOURCEBILLID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select FSOENTRYID,* from T_SAL_RETURNSTOCKENTRY t
--update t set t.FSOENTRYID=m2."to" from T_SAL_RETURNSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SAL_RETURNSTOCKENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSOENTRYID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select FSRCID,* from T_PUR_RECEIVEENTRY t
--update t set t.FSRCID=m2."to" from T_PUR_RECEIVEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PUR_RECEIVEENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSRCID and m2.tb='T_PUR_POORDER'
where m2.source<>m2."to";



select FSRCENTRYID,* from T_PUR_RECEIVEENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PUR_RECEIVEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PUR_RECEIVEENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PUR_POORDERENTRY'
where m2.source<>m2."to";


select FMOID,* from T_PRD_CVAENTRY t
--update t set t.FFMOID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'  
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_CVAENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FPPBOMID,* from T_PRD_CVAENTRY t
--update t set t.FPPBOMID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMID and m2.tb='T_PRD_PPBOM'
where m2.source<>m2."to";

select FPPBOMENTRYID,* from T_PRD_CVAENTRY t
--update t set t.FPPBOMENTRYID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_PRD_PPBOMENTRY'
where m2.source<>m2."to";

select FSRCINTERID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCINTERID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_PPBOM' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCENTRYID=m2."to"  from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_PPBOMENTRY' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FSRCINTERID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCINTERID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_ReturnMtrl' and t.FSRCBILLTYPE='PRD_ReturnMtrl'
where m2.source<>m2."to";



select FSRCENTRYID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_RETURNMTRLENTRY' and t.FSRCBILLTYPE='PRD_ReturnMtrl'
where m2.source<>m2."to";



select FPPBOMENTRYID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FPPBOMENTRYID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_PRD_PPBOMENTRY'
where m2.source<>m2."to";

select FMOID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FMOID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_FEEDMTRLDATA t
--update t set t.FMOENTRYID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FSRCBIZINTERID,* from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FSRCBIZINTERID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZINTERID and m2.tb='T_PRD_CVA' and t.FSRCBIZBILLTYPE='PRD_CVA'
where m2.source<>m2."to";


select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FSRCBIZENTRYID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZENTRYID and m2.tb='T_PRD_CVAENTRY' and t.FSRCBIZBILLTYPE='PRD_CVA'
where m2.source<>m2."to";

select FREQBILLID,* from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQBILLID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQENTRYID,* from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQENTRYID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQBILLID,* from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQBILLID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQENTRYID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select FMOID,* from T_PRD_INSTOCKENTRY t
--update t set t.FMOID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'  --T_PRD_MOENTRY
where m2.source<>m2."to";



select FMOENTRYID,* from T_PRD_INSTOCKENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";



select FSRCINTERID,* from T_PRD_INSTOCKENTRY t
--update t set t.FSRCINTERID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_MORPT' and t.FSRCBILLTYPE='PRD_MORPT'
where m2.source<>m2."to";


select FSRCENTRYID, * from T_PRD_INSTOCKENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_MORPTENTRY' and t.FSRCBILLTYPE='PRD_MORPT'
where m2.source<>m2."to";



select FMOMAINENTRYID,* from T_PRD_INSTOCKENTRY_A t
--update t set t.FMOMAINENTRYID=e.FMOENTRYID from T_PRD_INSTOCKENTRY_A t
inner join T_PRD_INSTOCKENTRY e on t.FENTRYID=e.FENTRYID
where t.FMOMAINENTRYID<>e.FMOENTRYID

select FREQBILLID,* from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";



select FREQENTRYID,* from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";



select FREQBILLID,* from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";

select FREQENTRYID,* from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select FSRCBILLID, * from T_PRD_MOENTRY t
--update t set t.FSRCBILLID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_PLN_FORECAST' and t.FSRCBILLTYPE='PLN_FORECAST'
where m2.source<>m2."to";

select FSRCBILLENTRYID,* from T_PRD_MOENTRY t
--update t set t.FSRCBILLENTRYID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FSRCBILLTYPE='PLN_FORECAST'
where m2.source<>m2."to";

select FSRCBILLID,* from T_PRD_MOENTRY t
update t set t.FSRCBILLID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_SAL_ORDER' and t.FSRCBILLTYPE='SAL_SaleOrder'
where m2.source<>m2."to";


select FSRCBILLENTRYID,* from T_PRD_MOENTRY t
--update t set t.FSRCBILLENTRYID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FSRCBILLTYPE='SAL_SaleOrder'
where m2.source<>m2."to";

select FSRCBILLID,* from T_PRD_MOENTRY t
--update t set t.FSRCBILLID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select * into qnwb_b from T_PRD_MOENTRY

select FSRCBILLENTRYID,* from T_PRD_MOENTRY t
--update t set t.FSRCBILLENTRYID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select FSRCBILLID,* from T_PRD_MOCHANGEENTRY t
--update t set t.FSRCBILLID=m2."to",t.FMOID=m2."to" from T_PRD_MOCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select FSRCBILLENTRYID,* from T_PRD_MOCHANGEENTRY t
--update t set t.FSRCBILLENTRYID=m2."to",t.FMOENTRYID=m2."to" from T_PRD_MOCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";


select FSRCINTERID,* from T_PRD_MORPTENTRY t
--update t set t.FSRCINTERID=m2."to",t.FMOID=m2."to" from T_PRD_MORPTENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_PRD_MORPTENTRY t
--update t set t.FSRCENTRYID=m2."to",t.FMOENTRYID=m2."to" from T_PRD_MORPTENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select FREQENTRYID,* from T_PRD_MORPTENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_MORPTENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQBILLID,* from T_PRD_MORPTENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_MORPTENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";


select FREQENTRYID,* from T_PRD_MORPTENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_MORPTENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select FREQBILLID,* from T_PRD_MORPTENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_MORPTENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";


select FMOMAINENTRYID,* from T_PRD_MORPTENTRY_A t
--update t set t.FMOMAINENTRYID=e.FMOENTRYID from T_PRD_MORPTENTRY_A t
inner join T_PRD_MORPTENTRY e on t.FENTRYID=e.FENTRYID
where t.FMOMAINENTRYID<>e.FMOENTRYID

select FSRCINTERID,* from T_PRD_PICKMTRLDATA t
--update t set t.FSRCINTERID=m2."to" from T_PRD_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_PPBOM' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FPPBOMENTRYID,FSRCENTRYID,* from T_PRD_PICKMTRLDATA t
--update t set t.FPPBOMENTRYID=m2."to",t.FSRCENTRYID=m2."to" from T_PRD_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_PPBOMENTRY' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_PICKMTRLDATA t
--update t set t.FMOENTRYID=m2."to" from T_PRD_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FMOID,* from T_PRD_PICKMTRLDATA t
--update t set t.FMOID=m2."to" from T_PRD_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FSRCBIZINTERID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FSRCBIZINTERID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZINTERID and m2.tb='T_PRD_INSTOCK' and t.FSRCBIZBILLTYPE='PRD_INSTOCK'
where m2.source<>m2."to";

select FSRCBIZENTRYID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FSRCBIZENTRYID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZENTRYID and m2.tb='T_PRD_INSTOCKENTRY' and t.FSRCBIZBILLTYPE='PRD_INSTOCK'
where m2.source<>m2."to";

select FSRCBIZINTERID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FSRCBIZINTERID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZINTERID and m2.tb='T_PRD_MORPT' and t.FSRCBIZBILLTYPE='PRD_MORPT'
where m2.source<>m2."to";

select FSRCBIZENTRYID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FSRCBIZENTRYID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZENTRYID and m2.tb='T_PRD_MORPTENTRY' and t.FSRCBIZBILLTYPE='PRD_MORPT'
where m2.source<>m2."to";

select FREQBILLID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";


select FREQENTRYID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQBILLID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";


select FREQENTRYID,* from T_PRD_PICKMTRLDATA_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select FSALEORDERID,* from T_PRD_PPBOM t
--update t set t.FSALEORDERID=m2."to" from T_PRD_PPBOM t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_PRD_PPBOM' 
inner join qnwb_id_map_all m2 on m2.source=t.FSALEORDERID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";

select FSALEORDERENTRYID,* from T_PRD_PPBOM t
--update t set t.FSALEORDERENTRYID=m2."to" from T_PRD_PPBOM t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_PRD_PPBOM' 
inner join qnwb_id_map_all m2 on m2.source=t.FSALEORDERENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select FMOID,* from T_PRD_PPBOM t
--update t set t.FMOID=m2."to" from T_PRD_PPBOM t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_PRD_PPBOM' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_PPBOM t
--update t set t.FMOENTRYID=m2."to" from T_PRD_PPBOM t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_PRD_PPBOM' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FMOID,* from T_PRD_PPBOMENTRY t
--update t set t.FMOID=m2."to" from T_PRD_PPBOMENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PPBOMENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_PPBOMENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_PPBOMENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PPBOMENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FMOID,* from T_PRD_PPBOMCHANGE t
--update t set t.FMOID=m2."to" from T_PRD_PPBOMCHANGE t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_PRD_PPBOMCHANGE' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_PPBOMCHANGE t
--update t set t.FMOENTRYID=m2."to" from T_PRD_PPBOMCHANGE t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_PRD_PPBOMCHANGE' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FMOID,* from T_PRD_PPBOMCHANGEENTRY t
--update t set t.FMOID=m2."to" from T_PRD_PPBOMCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PPBOMCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_PPBOMCHANGEENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_PPBOMCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PPBOMCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FPPBOMID,* from T_PRD_PPBOMCHANGEENTRY_C t
--update t set t.FPPBOMID=m2."to" from T_PRD_PPBOMCHANGEENTRY_C t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PPBOMCHANGEENTRY_C' 
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMID and m2.tb='T_PRD_PPBOM'
where m2.source<>m2."to";

select FPPBOMENTRYID,* from T_PRD_PPBOMCHANGEENTRY_C t
--update t set t.FPPBOMENTRYID=m2."to" from T_PRD_PPBOMCHANGEENTRY_C t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_PPBOMCHANGEENTRY_C' 
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_PRD_PPBOMENTRY'
where m2.source<>m2."to";

select 	FSRCINTERID,* from T_PRD_RESTOCKENTRY_A t
--update t set t.FSRCINTERID=m2."to" from T_PRD_RESTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RESTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_INSTOCK'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_PRD_RESTOCKENTRY_A t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_RESTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RESTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_INSTOCKENTRY'
where m2.source<>m2."to";


select 	FSRCINTERID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FSRCINTERID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_PickMtrl' and t.FSRCBILLTYPE='PRD_PickMtrl'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_PickMtrlDATA' and t.FSRCBILLTYPE='PRD_PickMtrl'
where m2.source<>m2."to";

select 	FSRCINTERID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FSRCINTERID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_FeedMtrl' and t.FSRCBILLTYPE='PRD_FeedMtrl'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_FeedMtrlDATA' and t.FSRCBILLTYPE='PRD_FeedMtrl'
where m2.source<>m2."to";

select 	FSRCINTERID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FSRCINTERID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_PPBOM' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_PPBOMENTRY' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select 	FMOID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FMOID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO' 
where m2.source<>m2."to";

select FMOENTRYID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select FPPBOMENTRYID,* from T_PRD_RETURNMTRLENTRY t
--update t set t.FPPBOMENTRYID=m2."to" from T_PRD_RETURNMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_PRD_PPBOMENTRY'
where m2.source<>m2."to";



select FREQBILLID,* from T_PRD_RETURNMTRLENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";


select FREQENTRYID,* from T_PRD_RETURNMTRLENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select 	FSUBREQID,* from T_SUB_FEEDMTRLENTRY t
--update t set t.FSUBREQID=m2."to" from T_SUB_FEEDMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_FEEDMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER' 
where m2.source<>m2."to";

select FSUBREQENTRYID,* from T_SUB_FEEDMTRLENTRY t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_FEEDMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_FEEDMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";

select FSRCENTRYID,FPPBOMENTRYID,* from T_SUB_FEEDMTRLENTRY t
--update t set t.FSRCENTRYID=m2."to",t.FPPBOMENTRYID=m2."to" from T_SUB_FEEDMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_FEEDMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_SUB_PPBOMENTRY' and t.FSRCBILLTYPE='SUB_PPBOM'
where m2.source<>m2."to";

select FSRCINTERID,* from T_SUB_FEEDMTRLENTRY t
--update t set t.FSRCINTERID=m2."to" from T_SUB_FEEDMTRLENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_FEEDMTRLENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_SUB_PPBOM' and t.FSRCBILLTYPE='SUB_PPBOM'
where m2.source<>m2."to";


select FREQENTRYID,* from T_SUB_FEEDMTRLENTRY_Q t
--update t set t.FREQENTRYID=m2."to" from T_SUB_FEEDMTRLENTRY_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_FEEDMTRLENTRY_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQBILLID,* from T_SUB_FEEDMTRLENTRY_Q t
--update t set t.FREQBILLID=m2."to" from T_SUB_FEEDMTRLENTRY_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_FEEDMTRLENTRY_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";


select FSRCENTRYID,FPPBOMENTRYID,* from T_SUB_PICKMTRLDATA t
--update t set t.FSRCENTRYID=m2."to",t.FPPBOMENTRYID=m2."to" from T_SUB_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_SUB_PPBOMENTRY' and t.FSRCBILLTYPE='SUB_PPBOM'
where m2.source<>m2."to";

select FSRCINTERID,* from T_SUB_PICKMTRLDATA t
--update t set t.FSRCINTERID=m2."to" from T_SUB_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_SUB_PPBOM' and t.FSRCBILLTYPE='SUB_PPBOM'
where m2.source<>m2."to";

select 	FSUBREQID,* from T_SUB_PICKMTRLDATA t
--update t set t.FSUBREQID=m2."to" from T_SUB_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER' 
where m2.source<>m2."to";

select FSUBREQENTRYID,* from T_SUB_PICKMTRLDATA t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_PICKMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";


select FREQENTRYID,* from T_SUB_PICKMTRLDATA_A t
--update t set t.FREQENTRYID=m2."to" from T_SUB_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQBILLID,* from T_SUB_PICKMTRLDATA_A t
--update t set t.FREQBILLID=m2."to" from T_SUB_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQENTRYID,* from T_SUB_PICKMTRLDATA_A t
--update t set t.FREQENTRYID=m2."to" from T_SUB_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select FREQBILLID,* from T_SUB_PICKMTRLDATA_A t
--update t set t.FREQBILLID=m2."to" from T_SUB_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA_A'
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";

select 	FSRCBIZINTERID,* from T_SUB_PICKMTRLDATA_A t
--update t set t.FSRCBIZINTERID=m2."to" from T_SUB_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA_A'  and t.FSRCBIZBILLTYPE='STK_InStock'
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZINTERID and m2.tb='T_STK_INSTOCK'
where m2.source<>m2."to";

select FSRCBIZENTRYID,* from T_SUB_PICKMTRLDATA_A t
--update t set t.FSRCBIZENTRYID=m2."to" from T_SUB_PICKMTRLDATA_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PICKMTRLDATA_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZENTRYID and m2.tb='T_STK_INSTOCKENTRY'and t.FSRCBIZBILLTYPE='STK_InStock'
where m2.source<>m2."to";

select 	FSUBREQID,* from T_SUB_PPBOMENTRY t
--update t set t.FSUBREQID=m2."to" from T_SUB_PPBOMENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PPBOMENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER' 
where m2.source<>m2."to";

select FSUBREQENTRYID,* from T_SUB_PPBOMENTRY t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_PPBOMENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PPBOMENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";

select 	FSUBREQID,* from T_SUB_PPBOM t
--update t set t.FSUBREQID=m2."to" from T_SUB_PPBOM t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_SUB_PPBOM' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER' 
where m2.source<>m2."to";

select FSUBREQENTRYID,* from T_SUB_PPBOM t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_PPBOM t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_SUB_PPBOM' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";


select 	FSUBREQID,* from T_SUB_PPBOMCHANGE t
--update t set t.FSUBREQID=m2."to" from T_SUB_PPBOMCHANGE t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_SUB_PPBOMCHANGE' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER' 
where m2.source<>m2."to";

select FSUBREQENTRYID,* from T_SUB_PPBOMCHANGE t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_PPBOMCHANGE t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_SUB_PPBOMCHANGE' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";


select 	FSUBREQID,* from T_SUB_PPBOMCHANGEENTRY t
--update t set t.FSUBREQID=m2."to" from T_SUB_PPBOMCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PPBOMCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER' 
where m2.source<>m2."to";

select FSUBREQENTRYID,* from T_SUB_PPBOMCHANGEENTRY t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_PPBOMCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PPBOMCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";

select FSUBPPBOMID,* from T_SUB_PPBOMCHANGEENTRY_C t
--update t set t.FSUBPPBOMID=m2."to" from T_SUB_PPBOMCHANGEENTRY_C t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PPBOMCHANGEENTRY_C' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBPPBOMID and m2.tb='T_SUB_PPBOM'
where m2.source<>m2."to";

select FSUBPPBOMENTRYID,* from T_SUB_PPBOMCHANGEENTRY_C t
--update t set t.FSUBPPBOMENTRYID=m2."to" from T_SUB_PPBOMCHANGEENTRY_C t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_PPBOMCHANGEENTRY_C' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBPPBOMENTRYID and m2.tb='T_SUB_PPBOMENTRY'
where m2.source<>m2."to";

select FSALEORDERID,* from T_SUB_REQORDERENTRY_A t
--update t set t.FSALEORDERID=m2."to" from T_SUB_REQORDERENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_REQORDERENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSALEORDERID and m2.tb='T_SAL_ORDER'
where m2.source<>m2."to";

select FSALEORDERENTRYID,* from T_SUB_REQORDERENTRY_A t
--update t set t.FSALEORDERENTRYID=m2."to" from T_SUB_REQORDERENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_REQORDERENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSALEORDERENTRYID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select FPURORDERID,* from T_SUB_REQORDERENTRY_A t
--update t set t.FPURORDERID=m2."to" from T_SUB_REQORDERENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_REQORDERENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FPURORDERID and m2.tb='T_PUR_POORDER'
where m2.source<>m2."to";

select FPURORDERENTRYID,* from T_SUB_REQORDERENTRY_A t
--update t set t.FPURORDERENTRYID=m2."to" from T_SUB_REQORDERENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_REQORDERENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FPURORDERENTRYID and m2.tb='T_PUR_POORDERENTRY'
where m2.source<>m2."to";


select FSRCBILLID,FSUBREQID,* from T_SUB_REQCHANGEENTRY t
--update t set t.FSRCBILLID=m2."to",FSUBREQID=m2."to" from T_SUB_REQCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_REQCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_SUB_REQORDER'
where m2.source<>m2."to";

select FSRCBILLENTRYID,FSUBREQENTRYID,* from T_SUB_REQCHANGEENTRY t
--update t set t.FSRCBILLENTRYID=m2."to",FSUBREQENTRYID=m2."to" from T_SUB_REQCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_REQCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";


select FSRCBILLID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSRCBILLID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_SUB_PickMtrl' and t.FSRCBILLTYPE='SUB_PickMtrl'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSRCENTRYID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_SUB_PickMtrlDATA' and t.FSRCBILLTYPE='SUB_PickMtrl'
where m2.source<>m2."to";

select FSRCBILLID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSRCBILLID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_SUB_PPBOM' and t.FSRCBILLTYPE='SUB_PPBOM'
where m2.source<>m2."to";

select FSRCENTRYID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSRCENTRYID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_SUB_PPBOMENTRY' and t.FSRCBILLTYPE='SUB_PPBOM'
where m2.source<>m2."to";

select FSUBREQID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSUBREQID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQID and m2.tb='T_SUB_REQORDER'
where m2.source<>m2."to";


select FSUBREQENTRYID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSUBREQENTRYID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSUBREQENTRYID and m2.tb='T_SUB_REQORDERENTRY'
where m2.source<>m2."to";


select FPPBOMENTRYID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FPPBOMENTRYID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_SUB_PPBOMENTRY'
where m2.source<>m2."to";

select FSRCBIZINTERID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSRCBIZINTERID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZINTERID and m2.tb='T_PUR_MRB' and t.FSRCBIZBILLTYPE='PUR_MRB'
where m2.source<>m2."to";

select FSRCBIZENTRYID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FSRCBIZENTRYID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZENTRYID and m2.tb='T_PUR_MRBENTRY' and t.FSRCBIZBILLTYPE='PUR_MRB'
where m2.source<>m2."to";

select FREQBILLID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";

select FREQENTRYID,* from T_SUB_RETURNMTRLENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_SUB_RETURNMTRLENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SUB_RETURNMTRLENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";








select distinct FSRCBIZBILLTYPE from T_SUB_RETURNMTRLENTRY_A
select * from T_BF_INSTANCEENTRY where FROUTEID='5d6f1b2f89dcc3'

select * from T_BF_INSTANCEENTRY where FINSTANCEID='5d6f1b2f89dcc2'
select * from T_AR_RECEIVABLEENTRY where FID=118972
select * from T_AR_RECEIVABLE_O where FID=118972

--update T_AR_RECEIVABLEENTRY set FBUYIVBASICQTY=0,FIVALLAMOUNTFOR=0,FBUYIVQTY=0  where FID=118971

select * from t_BF_InstanceAmountHis where FROUTEID='5d6f1b2f89dcc3'

--delete from T_IV_SALESIC_O where fid not in(select FID from T_IV_SALESIC)
--delete from T_IV_SALESICENTRY_O where FENTRYID not in (select FENTRYID from T_IV_SALESICENTRY) 
--AR191231037  118972,118971
--delete from T_IV_SALESICENTRY_LK where FENTRYID not in (select FENTRYID from T_IV_SALESICENTRY) 

select * from T_AR_RECEIVABLETOIV_LK

--delete from T_BF_INSTANCEENTRY where FSID in(147401,147402,147403,147404) and FSTABLENAME='T_AR_RECEIVABLEENTRY'
--delete from T_BF_INSTANCEENTRY where FSID in(147405,147406,147407,147408,147409,147410) and FSTABLENAME='T_AR_RECEIVABLEENTRY'