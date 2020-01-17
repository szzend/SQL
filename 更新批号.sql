drop table qnwb_tmp_011




select max(flotid) from T_BD_LOTMASTER where FLOTID<100000

select * into qnwb_tmp_011  from T_STK_INSTOCKENTRY


select * from T_QM_INSPECTBILLENTRY t left join T_BD_LOTMASTER m
on t.FLOT=m.FLOTID
inner join T_QM_INSPECTBILLENTRY_A a on t.FENTRYID=a.FENTRYID
where a.FMATERIALID<>m.FMATERIALID


---------------------------------------------------------------------------------------
update t set t.FLOT=lot.lot200 from T_SUB_RETURNMTRLENTRY t 
select * from T_PRD_PICKMTRLDATA t
inner join T_BD_LOTMASTER m on t.FLOT=m.FLOTID and m.FMATERIALID<>t.FMATERIALID
inner join qnwb_lot2lot lot on lot.lot100=t.FLOT
------------------------------------------------

update t set t.FLOT=lot.lot200 from T_QM_INSPECTBILLENTRY t
inner join qnwb_lot2lot lot on lot.lot100=t.FLOT
inner join T_QM_INSPECTBILLENTRY_A a on a.FENTRYID=t.FENTRYID
where t.FENTRYID in (
select t.FENTRYID from T_QM_INSPECTBILLENTRY t left join T_BD_LOTMASTER m
on t.FLOT=m.FLOTID
left join T_QM_INSPECTBILLENTRY_A a on t.FENTRYID=a.FENTRYID
where a.FMATERIALID<>m.FMATERIALID

)
select * from qnwb_lot2lot

select * from T_BD_LOTMASTER where FLOTID<>FMASTERID
update T_BD_LOTMASTER set FMASTERID=FLOTID  where FLOTID<>FMASTERID
-------------------------
"""
select * from T_BD_LOTMASTER_qnwb_from0105 where flotid in(
select FLOT from T_QM_INSPECTBILLENTRY e 
left join T_QM_INSPECTBILLENTRY_A a on e.fentryid=a.fentryid
left join T_BD_LOTMASTER t on e.FLOT=t.FLOTID
where a.FMATERIALID<>t.FMATERIALID 
) and flotid not in(
select lot100 from qnwb_lot2lot
)
"""
select e.FLOTID lot200,t.flotid lot100 from T_BD_LOTMASTER e
inner join T_BD_LOTMASTER_qnwb_from0105 t on e.FMATERIALID=t.FMATERIALID and e.FNUMBER=t.FNUMBER and e.FBIZTYPE=t.FBIZTYPE and e.FLOTID<>t.flotid

"""
select * from T_BD_LOTMASTER
insert into T_BD_LOTMASTER
"""
select * from T_BD_LOTMASTER_qnwb_from0105 where flotid not in(
select t.flotid from T_BD_LOTMASTER_qnwb_from0105 t 
inner join T_BD_LOTMASTER e on e.FMATERIALID=t.FMATERIALID and e.FNUMBER=t.FNUMBER and e.FBIZTYPE=t.FBIZTYPE
) and flotid  in (select flotid from T_BD_LOTMASTER)
"""

select * from qnwb_lot2lot