------------------------------------------------------------------------------------------------------------------

select * from T_SAL_DELIVERYNOTICEENTRY t 
--update t set t.FORDERSEQ=m2."to" from  T_SAL_DELIVERYNOTICEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SAL_DELIVERYNOTICEENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FORDERSEQ and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select * from T_SAL_DELIVERYNOTICEENTRY_E t
--update  t set t.FSOENTRYID= from T_SAL_DELIVERYNOTICEENTRY_E t 
inner join T_SAL_DELIVERYNOTICEENTRY e on t.FENTRYID=e.FENTRYID and t.FSOENTRYID<>e.FORDERSEQ;

select * from T_SAL_OUTSTOCKENTRY_R t
--update t set t.FSOENTRYID=m2."to" from T_SAL_OUTSTOCKENTRY_R t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SAL_OUTSTOCKENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSOENTRYID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select * from T_SAL_ORDERCHANGE t
--update t set t.FSOURCEBILLID=m2."to" from T_SAL_ORDERCHANGE t 
inner join qnwb_id_map_all m1 on t.FID=m1."to" and  tb='T_SAL_ORDERCHANGE'
inner join qnwb_id_map_all m2 on m2.source=t.FSOURCEBILLID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select 	* from T_SAL_RETURNSTOCKENTRY t
--update t set t.FSOENTRYID=m2."to" from T_SAL_RETURNSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_SAL_RETURNSTOCKENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSOENTRYID and m2.tb='T_SAL_ORDERENTRY'
where m2.source<>m2."to";

select * from T_PUR_RECEIVEENTRY t
--update t set t.FSRCID=m2."to" from T_PUR_RECEIVEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PUR_RECEIVEENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSRCID and m2.tb='T_PUR_POORDER'
where m2.source<>m2."to";

select * from T_PUR_RECEIVEENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PUR_RECEIVEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PUR_RECEIVEENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PUR_POORDERENTRY'
where m2.source<>m2."to";

select * from T_PRD_CVAENTRY t
--update t set t.FFMOID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'  
where m2.source<>m2."to";

select * from T_PRD_CVAENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select * from T_PRD_CVAENTRY t
--update t set t.FPPBOMID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMID and m2.tb='T_PRD_PPBOM'
where m2.source<>m2."to";

select * from T_PRD_CVAENTRY t
--update t set t.FPPBOMENTRYID=m2."to" from T_PRD_CVAENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_CVAENTRY'
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_PRD_PPBOMENTRY'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCINTERID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_PPBOM' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCENTRYID=m2."to"  from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_PPBOMENTRY' and t.FSRCBILLTYPE='PRD_PPBOM'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCINTERID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_ReturnMtrl' and t.FSRCBILLTYPE='PRD_ReturnMtrl'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_RETURNMTRLENTRY' and t.FSRCBILLTYPE='PRD_ReturnMtrl'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FPPBOMENTRYID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FPPBOMENTRYID and m2.tb='T_PRD_PPBOMENTRY'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FMOID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA t
--update t set t.FMOENTRYID=m2."to" from T_PRD_FEEDMTRLDATA t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FSRCBIZINTERID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZINTERID and m2.tb='T_PRD_CVA' and t.FSRCBIZBILLTYPE='PRD_CVA'
where m2.source<>m2."to";


select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FSRCBIZENTRYID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBIZENTRYID and m2.tb='T_PRD_CVAENTRY' and t.FSRCBIZBILLTYPE='PRD_CVA'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQBILLID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQENTRYID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQBILLID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";

select * from T_PRD_FEEDMTRLDATA_Q t
--update t set t.FREQENTRYID=m2."to" from T_PRD_FEEDMTRLDATA_Q t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_FEEDMTRLDATA_Q' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY t
--update t set t.FMOID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOID and m2.tb='T_PRD_MO'  --T_PRD_MOENTRY
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY t
--update t set t.FMOENTRYID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FMOENTRYID and m2.tb='T_PRD_MOENTRY'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY t
--update t set t.FSRCINTERID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_MORPT' and t.FSRCBILLTYPE='PRD_MORPT'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY t
--update t set t.FSRCENTRYID=m2."to" from T_PRD_INSTOCKENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_MORPTENTRY' and t.FSRCBILLTYPE='PRD_MORPT'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY_A t
--update t set t.FMOMAINENTRYID=e.FMOENTRYID T_PRD_INSTOCKENTRY_A t
inner join T_PRD_INSTOCKENTRY e on t.FENTRYID=e.FENTRYID
where t.FMOMAINENTRYID<>e.FMOENTRYID

select * from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_SAL_ORDER' and t.FREQSRC='1'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FREQSRC='1'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQBILLID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQBILLID and m2.tb='T_PLN_FORECAST' and t.FREQSRC='2'
where m2.source<>m2."to";

select * from T_PRD_INSTOCKENTRY_A t
--update t set t.FREQENTRYID=m2."to" from T_PRD_INSTOCKENTRY_A t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_INSTOCKENTRY_A' 
inner join qnwb_id_map_all m2 on m2.source=t.FREQENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FREQSRC='2'
where m2.source<>m2."to";

select * from T_PRD_MOENTRY t
--update t set t.FSRCBILLID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_PLN_FORECAST' and t.FSRCBILLTYPE='PLN_FORECAST'
where m2.source<>m2."to";

select * from T_PRD_MOENTRY t
--update t set t.FSRCBILLENTRYID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_PLN_FORECASTENTRY' and t.FSRCBILLTYPE='PLN_FORECAST'
where m2.source<>m2."to";

select * from T_PRD_MOENTRY t
--update t set t.FSRCBILLID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_SAL_ORDER' and t.FSRCBILLTYPE='SAL_SaleOrder'
where m2.source<>m2."to";

select * from T_PRD_MOENTRY t
--update t set t.FSRCBILLENTRYID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_SAL_ORDERENTRY' and t.FSRCBILLTYPE='SAL_SaleOrder'
where m2.source<>m2."to";

select * from T_PRD_MOENTRY t
--update t set t.FSRCBILLID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select * from T_PRD_MOENTRY t
--update t set t.FSRCBILLENTRYID=m2."to" from T_PRD_MOENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select * from T_PRD_MOCHANGEENTRY t
--update t set t.FSRCBILLID=m2."to",t.FMOID=m2."to" from T_PRD_MOCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select * from T_PRD_MOCHANGEENTRY t
--update t set t.FSRCBILLENTRYID=m2."to",t.FMOENTRYID=m2."to" from T_PRD_MOCHANGEENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MOCHANGEENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCBILLENTRYID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";


select * from T_PRD_MORPTENTRY t
--update t set t.FSRCINTERID=m2."to",t.FMOID=m2."to" from T_PRD_MORPTENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCINTERID and m2.tb='T_PRD_MO' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";

select * from T_PRD_MORPTENTRY t
--update t set t.FSRCENTRYID=m2."to",t.FMOENTRYID=m2."to" from T_PRD_MORPTENTRY t 
inner join qnwb_id_map_all m1 on t.FENTRYID=m1."to" and  tb='T_PRD_MORPTENTRY' 
inner join qnwb_id_map_all m2 on m2.source=t.FSRCENTRYID and m2.tb='T_PRD_MOENTRY' and t.FSRCBILLTYPE='PRD_MO'
where m2.source<>m2."to";



select * from qnwb_tbnames_bill where FLEVEL=0 and YD is not null
update T_AP_PAYABLEFIN set FMAINBOOKSTDCURRID=1 where FMAINBOOKSTDCURRID=0
------------------------------------------------------------------------------------------------------------------
select FBILLNO,FCREATEDATE,* from T_PUR_POORDERACTUALPAY t inner join qnwb_id_map_12 m on t.FDETAILID=m."to" and m.tb='T_PUR_POORDERACTUALPAY'
inner join T_PUR_POORDERENTRY e on e.FENTRYID=t.FENTRYID
inner join T_PUR_POORDER o on e.FID=o.FID
where 	FPAPPLYAMOUNT>0

select * from T_PUR_POORDER where FBILLNO='POORD19111947'
select * from T_PUR_POORDERENTRY where FID=145400
select FACTUALAMOUNT,	
FPAYADVANCEAMOUNT,FAPPLYAMOUNT,* from T_PUR_POORDERINSTALLMENT where FID=145400  --992.8800000000

--update T_PUR_POORDERINSTALLMENT set FAPPLYAMOUNT=0 where FID=145400




select FEXPIRYDATE,* from T_PUR_RECEIVEENTRY where FEXPIRYDATE is not null

--update T_SUB_RETURNMTRLENTRY set FEXPIRYDATE=null ,FPRODUCEDATE=null where FEXPIRYDATE is not null

select t.FBILLNO, e.FREALPAYAMOUNTFOR,e.FWRITTENOFFAMOUNTFOR,e.FPAYTOTALAMOUNTFOR,e.FWRITTENOFFSTATUS,FASSAMOUNTFOR,FPAYAMOUNTFOR_E,* from T_AP_PAYBILLENTRY e
inner join T_AP_PAYBILL t on e.FID=t.FID
select * from T_AP_PAYBILLSRCENTRY
select count(*) from qnwb_id_map_11
select count(*) from qnwb_id_map_12
select count(*) from qnwb_id_map_all
select count(*) from qnwb_id_map


select * from T_PUR_POORDERENTRY where FID=145089 and FMATERIALID=176873

select * from T_PRD_MOENTRY e
join T_PRD_MO t on e.FID=t.FID
where FBILLNO='MO191116001' and FMATERIALID=135143

select * from T_PRD_MOENTRY e
inner join T_PRD_MO m on e.FID=m.FID
where FBILLNO='MO181108089'
select * from T_STK_INVENTORY where FMATERIALID=474142
delete from T_STK_INVENTORYLOG where FINVENTORYID='15bc3920-3e9e-4a79-8149-b4e722c3d0d5' or FINVENTORYID='e00bf1d7-2aa7-488a-9bb2-286b6654ac09'
or FINVENTORYID='39c801d6-5884-4e4a-88b9-66904f7abb20' or FINVENTORYID='2414f8ce-d30d-41f0-9ebd-1aca73eb9949'
select * from T_BD_LOTMASTER where FLOTID in(483665,1153)
select * from T_BD_LOTMASTER where FMATERIALID=474142

select flot,* from T_PRD_PICKMTRLDATA where FMATERIALID=474142
update  T_STK_STKTRANSFERINENTRY set FDESTLOT=1153 where FMATERIALID=474142

update T_STK_STKTRANSFERINENTRY set FDESTLOT=FLOT where FLOT<>FDESTLOT
select * from T_BF_INSTANCE where FINSTANCEID='5d1da25dfe63a2'
select * from T_BF_INSTANCEENTRY where FINSTANCEID='5d1da25dfe639d'

select * from T_BF_INSTANCEA

select * from T_AR_RECEIVABLE where FBILLNO='AR191213001'
select * from t_AR_receivableFIN where FID=118732

select * from T_SAL_RETURNSTOCK where FBILLNO='SNC1910001-P'

select distinct tb from qnwb_id_map where tb like 'T_SAL_RETURNSTOCK%'


select * from T_SUB_PPBOMENTRY e
inner join T_SUB_PPBOM t on e.FID=t.FID
where FBILLNO='SUBBOM191023125'and FSEQ=1

update T_SUB_REQORDERENTRY_LK set FSBILLID=114163,FSID=149064 where FLINKID=106308

select * from qnwb_id_map_all where tb='T_SUB_PPBOM' and source='145819'