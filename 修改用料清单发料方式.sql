--发料方式  FISSUETYPE 
--char(1) 1.直接领料;2.直接倒冲;3.转仓领料;4.转仓倒冲;5.备料发料;7.不发料 
--FSRCTRANSSTOCKID 拨出仓库
--FSTOCKID  发料仓库
--倒冲时机 FBACKFLUSHTYPE  1.开工倒冲;2.汇报倒冲;3.入库倒冲

--T_PRD_PPBOMENTRY_Q(生产用料清单子项明细数量)  已领数量 FPICKEDQTY
select c.FBACKFLUSHTYPE,c.FSTOCKID,c.FSRCTRANSSTOCKID,c.FISSUETYPE,prd.FSTATUS,bom.FBILLNO,q.FPICKEDQTY, m.FNUMBER, * from T_PRD_PPBOMENTRY_C c
left join T_PRD_PPBOMENTRY_Q q on c.FID=q.FID and c.FENTRYID=q.FENTRYID
left join T_PRD_PPBOMENTRY d on d.FID=c.FID and d.FENTRYID=c.FENTRYID
left join T_BD_MATERIAL m on m.FMATERIALID=d.FMATERIALID
left join T_PRD_PPBOM bom on c.FID=bom.FID
left join T_PRD_MOENTRY_A prd on prd.FENTRYID=bom.FMOENTRYID
where c.FISSUETYPE in ('2','4') and  prd.FSTATUS<'4' --工单状态为开工之前

--T_PRD_PPBOMENTRY_C(生产用料清单子项明细物料控制) FID  FENTRYID 

update T_PRD_PPBOMENTRY_C set FISSUETYPE='3',FSTOCKID=384600,FBACKFLUSHTYPE=null
where FENTRYID in (

select c.FENTRYID from T_PRD_PPBOMENTRY_C c
left join T_PRD_PPBOMENTRY_Q q on c.FID=q.FID and c.FENTRYID=q.FENTRYID
left join T_PRD_PPBOMENTRY d on d.FID=c.FID and d.FENTRYID=c.FENTRYID
left join T_BD_MATERIAL m on m.FMATERIALID=d.FMATERIALID
left join T_PRD_PPBOM bom on c.FID=bom.FID
left join T_PRD_MOENTRY_A prd on prd.FENTRYID=bom.FMOENTRYID
where c.FISSUETYPE in ('2','4') and  prd.FSTATUS<'4' 
)


 select m.FNUMBER FISSUETYPE,FBKFLTIME,FPICKSTOCKID from t_bd_materialproduce p
 left join T_BD_MATERIAL m on m.FMATERIALID=p.FMATERIALID
where FISSUETYPE='2' or FISSUETYPE='4'

								--FISSUETYPE = 3
 select * from t_BD_Stock_L   --384600  生产部车间辅料仓  发料仓库 FPICKSTOCKID
								--倒冲时机  FBKFLTIME =null

update t_bd_materialproduce set FISSUETYPE='3',FBKFLTIME=null,FPICKSTOCKID=384600
where (FISSUETYPE='2' or FISSUETYPE='4')
