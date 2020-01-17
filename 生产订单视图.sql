create view V_QNWB_PRDMO as 
select e.FENTRYID,FBILLNO,FSEQ,t.FBILLTYPE,bt.FNAME FTYPENAME, e.FMATERIALID,FBOMID,b.FNUMBER,FMTONO,e.FWORKSHOPID,dep.FNAME FSHOPNAME,
e.FBASEUNITID,u.FNAME,FBASEUNITQTY, FBASEYIELDQTY,FBASENOSTOCKINQTY,FBASEPICKMTLQTY,
FPLANSTARTDATE,FPLANFINISHDATE,FCONVEYDATE,FSTARTDATE,FFINISHDATE,FCLOSEDATE,a.FSTATUS,t.FDOCUMENTSTATUS,
FSALEORDERID,FSALEORDERNO ,FSALEORDERENTRYID from T_PRD_MOENTRY e
left join T_PRD_MOENTRY_A a on e.FENTRYID=a.FENTRYID
left join T_PRD_MOENTRY_Q q on q.FENTRYID=e.FENTRYID
left join T_PRD_MO t on e.FID=t.FID
left join T_BD_UNIT_L u on u.FUNITID=e.FBASEUNITID and u.FLOCALEID=2052
left join T_ENG_BOM b on b.FID=e.FBOMID
left join T_BD_DEPARTMENT_L dep on dep.FDEPTID=e.FWORKSHOPID and dep.FLOCALEID=2052
left join T_BAS_BILLTYPE_L bt on bt.FBILLTYPEID=t.FBILLTYPE and bt.FLOCALEID=2052
go

create view V_QNWB_PRDPPBOM as 
select e.FENTRYID,t.FBILLNO,e.FSEQ,e.FMOENTRYID,e.FMATERIALTYPE,e.FMATERIALID,
e.FBASEUNITID,u.FNAME,e.FBASENEEDQTY,e.FBASEMUSTQTY,q.FBASEPICKEDQTY,FBASEREPICKEDQTY,FBASESCRAPQTY,FBASEGOODRETURNQTY,
FBASEINCDEFECTRETURNQTY,FBASEPRCDEFECTRETURNQTY ,FBASECONSUMEQTY,FBASEWIPQTY,FBASENOPICKEDQTY,
t.FDOCUMENTSTATUS
from T_PRD_PPBOMENTRY e
left join T_PRD_PPBOMENTRY_Q q on q.FENTRYID=e.FENTRYID
left join T_PRD_PPBOM t on e.FID=t.FID
left join T_BD_UNIT_L u on u.FUNITID=e.FBASEUNITID and u.FLOCALEID=2052
go

--select *,(select sum(c.fbaseneedqty)from V_QNWB_PRDPPBOM c where c.FENTRYID<=s.FENTRYID and c.FMATERIALID=s.FMATERIALID)agg from V_QNWB_PRDPPBOM s
--select *,sum(fbaseneedqty) over(partition by fmaterialid order by fentryid)agg from V_QNWB_PRDPPBOM

create view V_QNWB_BDMATERIAL as 
select m.FMATERIALID,m.FNUMBER,L.FNAME, FMNEMONICCODE,FMATERIALGROUP,gp.FNUMBER FGROUPNO,gp.FNAME FGROUPNAME,
base.FERPCLSID, case base.FERPCLSID when '1' then '外购' when '2' then'自制' when '3' then '委外' when '4' then '特征' when '5' then '虚拟' when '6' then '服务' 
when '7' then '一次性' when '9' then '配置' when '10' then '资产' when '11' then '费用' when '12' then '模型' when '13' then '产品系列' end as FERPCLS,
category.FNUMBER FCATEGORYNO,category.FNAME FCATEGORYNAME,FTYPEID,FBASEUNITID,FTYPEID
FFORBIDSTATUS,FDOCUMENTSTATUS
from T_BD_MATERIAL m
left join T_BD_MATERIAL_L L on m.FMATERIALID=L.FMATERIALID and L.FLOCALEID=2052
left join T_BD_MATERIALBASE base on base.FMATERIALID=m.FMATERIALID
left join
(select c.FCATEGORYID,c.FNUMBER,L.FNAME  from t_bd_materialcategory c left join T_BD_MATERIALCATEGORY_L L on c.FCATEGORYID=L.FCATEGORYID and L.FLOCALEID=2052)
category on category.FCATEGORYID=base.FCATEGORYID
left join
(select g.FNUMBER,L.FNAME,g.FID from T_BD_MATERIALGROUP g left join T_BD_MATERIALGROUP_L L on g.FID=L.FID and L.FLOCALEID=2052)
gp on gp.FID=m.FMATERIALGROUP
go


create view V_QNWB_SUBPPBOM as 
select e.FENTRYID,t.FBILLNO,e.FSEQ,e.FSUBREQENTRYID,e.FMATERIALTYPE,e.FMATERIALID,
e.FBASEUNITID,u.FNAME,e.FBASENEEDQTY,e.FBASEMUSTQTY,q.FBASEPICKEDQTY,FBASEREPICKEDQTY,FBASESCRAPQTY,FBASEGOODRETURNQTY,
FBASEINCDEFECTRETURNQTY,FBASEPRCDEFECTRETURNQTY ,FBASECONSUMEQTY,FBASEWIPQTY,FBASENOPICKEDQTY,
t.FDOCUMENTSTATUS
from T_SUB_PPBOMENTRY e
left join T_SUB_PPBOMENTRY_Q q on q.FENTRYID=e.FENTRYID
left join T_SUB_PPBOM t on e.FID=t.FID
left join T_BD_UNIT_L u on u.FUNITID=e.FBASEUNITID and u.FLOCALEID=2052
go

alter view V_QNWB_SUBREQORDER as 
select e.FENTRYID,FBILLNO,FSEQ,t.FBILLTYPE,bt.FNAME FTYPENAME, e.FMATERIALID,FBOMID,b.FNUMBER,FMTONO,e.FSUPPLIERID,dep.FSHORTNAME FSHOPNAME,
a.FBASEUNITID,u.FNAME,FBASEUNITQTY, FBASEYIELDQTY,a.FBASENOSTOCKINQTY,a.FBASEPICKMTLQTY,
FPLANSTARTDATE,FPLANFINISHDATE,FCONVEYDATE,FSTARTDATE,FFINISHDATE,FCLOSEDATE,e.FSTATUS,t.FDOCUMENTSTATUS,
FSALEORDERID,FSALEORDERNO ,FSALEORDERENTRYID from T_SUB_REQORDERENTRY e
left join T_SUB_REQORDERENTRY_A a on e.FENTRYID=a.FENTRYID
left join T_SUB_REQORDER t on e.FID=t.FID
left join T_BD_UNIT_L u on u.FUNITID=a.FBASEUNITID and u.FLOCALEID=2052
left join T_ENG_BOM b on b.FID=e.FBOMID
left join T_BD_SUPPLIER_L dep on dep.FSUPPLIERID=e.FSUPPLIERID  and dep.FLOCALEID=2052
left join T_BAS_BILLTYPE_L bt on bt.FBILLTYPEID=t.FBILLTYPE and bt.FLOCALEID=2052
go

create view  V_QNWB_DEMAND as 
select ROW_NUMBER() over (order by t.FPLANSTARTDATE,t.FSALEORDERNO)as FIDENTITY,t.* from	--以计划开工日为分配依据
(select --生产订单
mo.FSALEORDERNO,mo.FBILLNO,mo.FSEQ,m2.FNUMBER FITEM,m2.FNAME FITEMNAME,mo.FNUMBER FBOMVER,mo.FBASEUNITID FITEMUNIT,mo.FNAME FITEMUNITNAME,
mo.FBASEUNITQTY,mo.FBASENOSTOCKINQTY,mo.FPLANSTARTDATE,mo.FPLANFINISHDATE,mo.FCONVEYDATE,
mo.FSALEORDERENTRYID,--订单信息
pb.FMATERIALID,m1.FNUMBER FCHILDMATNO,m1.FNAME FCHILDMATNAME,pb.FBASEUNITID,pb.FNAME FUNITNAME,
pb.FBASENEEDQTY,pb.FBASEPICKEDQTY,(FBASENEEDQTY-FBASEPICKEDQTY) FDEMANDQTY--ISNULL(stock.FSTOCKQTY,0) FSTOCKQTY
from V_QNWB_PRDPPBOM pb
left join V_QNWB_PRDMO mo on pb.FMOENTRYID=mo.FENTRYID
left join V_QNWB_BDMATERIAL m1 on m1.FMATERIALID=pb.FMATERIALID
left join V_QNWB_BDMATERIAL m2 on m2.FMATERIALID=mo.FMATERIALID
where (m1.FERPCLSID in ('1','2','3')) --外购，委外，或自制物料
and mo.FSTATUS<'5' --工单状态为'完工'之前
and pb.FMATERIALTYPE='1' --物料为非'返还件'
and FSALEORDERNO in(
'SNC1811229B','SNC1907095A','SNC1907177H','SNC1904038B','SNC1908008D'
)
union
select --委外订单
mo.FSALEORDERNO,mo.FBILLNO,mo.FSEQ,m2.FNUMBER FITEM,m2.FNAME FITEMNAME,mo.FNUMBER FBOMVER,mo.FBASEUNITID FITEMUNIT,mo.FNAME FITEMUNITNAME,
mo.FBASEUNITQTY,mo.FBASENOSTOCKINQTY,mo.FPLANSTARTDATE,mo.FPLANFINISHDATE,mo.FCONVEYDATE,
--订单信息
pb.FMATERIALID,m1.FNUMBER FCHILDMATNO,m1.FNAME FCHILDMATNAME,pb.FBASEUNITID,pb.FNAME FUNITNAME,
pb.FBASENEEDQTY,pb.FBASEPICKEDQTY,(FBASENEEDQTY-FBASEPICKEDQTY) FDEMANDQTY--ISNULL(stock.FSTOCKQTY,0) FSTOCKQTY
from V_QNWB_SUBPPBOM pb
left join V_QNWB_SUBREQORDER mo on pb.FSUBREQENTRYID=mo.FENTRYID
left join V_QNWB_BDMATERIAL m1 on m1.FMATERIALID=pb.FMATERIALID
left join V_QNWB_BDMATERIAL m2 on m2.FMATERIALID=mo.FMATERIALID
where (m1.FERPCLSID in ('1','2','3')) --外购，委外，或自制物料
and mo.FSTATUS<'5' --工单状态为'完工'之前
and pb.FMATERIALTYPE='1' --物料为非'返还件'
and FSALEORDERNO in(
'SNC1811229B','SNC1907095A','SNC1907177H','SNC1904038B','SNC1908008D'
)
) t
go

select FMATERIALID,sum(FBaseQty) FSTOCKQTY
from T_STK_INVENTORY
where FSTOCKSTATUSID=10000--库存状态为‘可用’
and FSTOCKID>0	--指定仓库
group by FMATERIALID
