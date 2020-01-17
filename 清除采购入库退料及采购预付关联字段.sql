update T_PUR_POORDERINSTALLMENT set FAPPLYAMOUNT=0 where fentryid in(
(select FENTRYID from T_PUR_POORDERINSTALLMENT t inner join qnwb_id_map m on m.tb='T_PUR_POORDERINSTALLMENT' and t.FENTRYID=m."to"
inner join T_PUR_POORDER o on t.FID=o.FID
where FAPPLYAMOUNT>0)
)
select * into qnwbx_T_PUR_MRBENTRY from T_PUR_MRBENTRY
--T_STK_INSTOCKENTRY

update T_STK_INSTOCKENTRY set FBASEAPJOINQTY=0 where FENTRYID in(
select FENTRYID from T_STK_INSTOCKENTRY t 
inner join T_STK_INSTOCK o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_STK_INSTOCKENTRY' and t.FENTRYID=m."to"
where FBASEAPJOINQTY>0
)

update T_STK_INSTOCKENTRY_F set FAPJOINAMOUNT=0,FAPNOTJOINQTY=FPRICEUNITQTY where FENTRYID in(
select FENTRYID from T_STK_INSTOCKENTRY_F t 
inner join T_STK_INSTOCK o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_STK_INSTOCKENTRY_F' and t.FENTRYID=m."to"
where FAPNOTJOINQTY=0
)

update T_STK_INSTOCKENTRY_I set FSTOCKBASEAPJOINQTY=0,FPAYABLECLOSEDATE=null,FPAYABLECLOSESTATUS='A' where FENTRYID in(
select FENTRYID from T_STK_INSTOCKENTRY_I t 
inner join T_STK_INSTOCK o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_STK_INSTOCKENTRY_I' and t.FENTRYID=m."to"
where FSTOCKBASEAPJOINQTY>0
)

update T_PUR_MRBENTRY set FBASEAPJOINQTY=0 where FENTRYID in(
select  FENTRYID from T_PUR_MRBENTRY t 
inner join T_PUR_MRB o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_PUR_MRBENTRY' and t.FENTRYID=m."to"
where FBASEAPJOINQTY>0
)

update T_PUR_MRBENTRY_F set FAPJOINAMOUNT=0,FAPNOTJOINQTY=FPRICEUNITQTY where FENTRYID in(
select FENTRYID from T_PUR_MRBENTRY_F t 
inner join T_PUR_MRB o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_PUR_MRBENTRY_F' and t.FENTRYID=m."to"
where FAPNOTJOINQTY=0
)

update T_PUR_MRBENTRY_I set FSTOCKBASEAPJOINQTY=0,FPAYABLECLOSEDATE=null,FPAYABLECLOSESTATUS='A' where FENTRYID in(
select FENTRYID from T_PUR_MRBENTRY_I t 
inner join T_PUR_MRB o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_PUR_MRBENTRY_I' and t.FENTRYID=m."to"
where FSTOCKBASEAPJOINQTY>0
)

update T_SUB_EXCONSUMEENTRY set F_QNWB_APQty=0 where FENTRYID in(
select  FENTRYID from T_SUB_EXCONSUMEENTRY t 
inner join T_SUB_EXCONSUME o on t.FID=o.FID
inner join qnwb_id_map m on m.tb='T_SUB_EXCONSUMEENTRY' and t.FENTRYID=m."to"
where F_QNWB_APQty>0
)
