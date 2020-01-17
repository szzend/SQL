USE [AIS20190719142428]
GO

/****** Object:  StoredProcedure [dbo].[z_get_demand]    Script Date: 2020/1/17 14:20:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[z_get_demand]
@tb nvarchar(256),--�����
@tbStock nvarchar(256),--����
@tbPO nvarchar(256),--�ɹ�������
@filterSO nvarchar(3300)		--and FSALEORDERNO in()
as 
begin
declare @sqlStr nvarchar(max);
declare @sqlStock nvarchar(max);
declare @sqlPO nvarchar(max);
set @sqlStr=N'
select ROW_NUMBER() over (order by t.FPLANSTARTDATE,t.FSALEORDERNO)as FIDENTITYID,t.* into '+ QUOTENAME(@tb)+N'
from	--�Լƻ�������Ϊ��������
(select --��������
mo.FSALEORDERNO,mo.FBILLNO,mo.FSEQ,m2.FNUMBER FITEM,m2.FNAME FITEMNAME,mo.FNUMBER FBOMVER,mo.FBASEUNITID FITEMUNIT,mo.FNAME FITEMUNITNAME,
mo.FBASEUNITQTY,mo.FBASENOSTOCKINQTY,mo.FPLANSTARTDATE,mo.FPLANFINISHDATE,mo.FCONVEYDATE,
mo.FSALEORDERENTRYID,--������Ϣ
pb.FMATERIALID,m1.FNUMBER FCHILDMATNO,m1.FNAME FCHILDMATNAME,m1.FSPECIFICATION,m1.FGROUPNAME,pb.FBASEUNITID,pb.FNAME FUNITNAME,
pb.FBASENEEDQTY,pb.FBASEPICKEDQTY,(FBASENEEDQTY-FBASEPICKEDQTY) FDEMANDQTY
from V_QNWB_PRDPPBOM pb
left join V_QNWB_PRDMO mo on pb.FMOENTRYID=mo.FENTRYID
left join V_QNWB_BDMATERIAL m1 on m1.FMATERIALID=pb.FMATERIALID
left join V_QNWB_BDMATERIAL m2 on m2.FMATERIALID=mo.FMATERIALID
where (m1.FERPCLSID in (''1'',''2'',''3'')) --�⹺��ί�⣬����������
and pb.FMATERIALTYPE=''1'' ' --����Ϊ��"������"
+@filterSO+N'
union
select --ί�ⶩ��
mo.FSALEORDERNO,mo.FBILLNO,mo.FSEQ,m2.FNUMBER FITEM,m2.FNAME FITEMNAME,mo.FNUMBER FBOMVER,mo.FBASEUNITID FITEMUNIT,mo.FNAME FITEMUNITNAME,
mo.FBASEUNITQTY,mo.FBASENOSTOCKINQTY,mo.FPLANSTARTDATE,mo.FPLANFINISHDATE,mo.FCONVEYDATE,
mo.FSALEORDERENTRYID,--������Ϣ
pb.FMATERIALID,m1.FNUMBER FCHILDMATNO,m1.FNAME FCHILDMATNAME,m1.FSPECIFICATION,m1.FGROUPNAME,pb.FBASEUNITID,pb.FNAME FUNITNAME,
pb.FBASENEEDQTY,pb.FBASEPICKEDQTY,(FBASENEEDQTY-FBASEPICKEDQTY) FDEMANDQTY
from V_QNWB_SUBPPBOM pb
left join V_QNWB_SUBREQORDER mo on pb.FSUBREQENTRYID=mo.FENTRYID
left join V_QNWB_BDMATERIAL m1 on m1.FMATERIALID=pb.FMATERIALID
left join V_QNWB_BDMATERIAL m2 on m2.FMATERIALID=mo.FMATERIALID
where (m1.FERPCLSID in (''1'',''2'',''3'')) --�⹺��ί�⣬����������
and pb.FMATERIALTYPE=''1'' ' --����Ϊ��"������"
+@filterSO+N'
) t'
exec sp_executesql @stmt=@sqlStr,@params=N'@tb nvarchar(256),@filterSO nvarchar(800)',@tb=@tb,@filterSO=@filterSO

set @sqlStock=N'
select FMATERIALID,sum(FBaseQty) FSTOCKQTY into '+ QUOTENAME(@tbStock)+N'
from T_STK_INVENTORY
where FSTOCKSTATUSID=10000--���״̬Ϊ�����á�
and FSTOCKID in(100109,100110,272976,275942,319541)	--ָ���ֿ�
group by FMATERIALID;'
exec sp_executesql @stmt=@sqlStock,@params=N'@tbStock nvarchar(256)',@tbStock=@tbStock

set @sqlPO=N'
select e.FMATERIALID,sum(FBASEUNITQTY)-sum(FBASESTOCKINQTY)+sum(FBASEMRBQTY) as FOPENPOQTY into '+ QUOTENAME(@tbPO)+N'
from T_PUR_POORDERENTRY e 
left join T_PUR_POORDER m on e.FID=m.FID
left join T_PUR_POORDERENTRY_R r on r.FENTRYID=e.FENTRYID
where e.FMRPFREEZESTATUS=''A'' and e.FMRPTERMINATESTATUS=''A''
and e.FMRPCLOSESTATUS=''A'' and m.FCLOSESTATUS=''A'' and m.FCANCELSTATUS=''A''--������
and m.FDOCUMENTSTATUS<>''Z''--����״̬Ϊ�ǻ���
group by FMATERIALID'
exec sp_executesql @stmt=@sqlPO,@params=N'@sqlPO nvarchar(256)',@sqlPO=@sqlPO
end
--FSTOCKID	FLOCALEID	FNAME
--100109	2052	ԭ���ϲ�
--100110	2052	��Ʒ��
--272976	2052	�����Ʒ��
--275942	2052	����Ʒ��
--319541	2052	��Ƭ���Ʒ��
GO


