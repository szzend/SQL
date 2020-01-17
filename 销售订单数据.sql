USE [T1025]
GO

/****** Object:  StoredProcedure [dbo].[z_get_sal_orders]    Script Date: 2019/11/8 10:55:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[z_get_sal_orders]
@start_date date,
@end_date date,
@tableName nvarchar(256)
as 
begin
declare @type nvarchar(8);
declare @name nvarchar(8);
declare @sqlStr nvarchar(max);
set @type=N'XSY'
set @name=N'����'
set @sqlStr=N'
--ȡ���۶������ݣ�������֯id���������ڣ�����״̬�����۲��ű��룬���۲������ƣ�����Ա���룬����Ա���ƣ�
--�ͻ����룬�ͻ���ţ��ͻ����ƣ����ң��������룬��¼���룬�������룬�Ƿ���ѣ�������λ��������λ�ҽ��
--������ţ����ϱ��룬�������ƣ����Ϸ����ţ����Ϸ�������
select ord.FSALEORGID,ord.FDATE,ord.FDOCUMENTSTATUS,dep.FDEPNUMBER,dep.FDEPNAME,saler.FSALERNUMBER,saler.FSALENAME,
ord.FCUSTID,customer.FCUSTNUMBER,customer.FCUSTNAME,customer.FCOUNTRYNAME,detail.FID,detail.FENTRYID, detail.FMATERIALID,f.FISFREE, detail.FBASEUNITQTY,f.FAMOUNT_LC, 
ord.FBILLNO,material.FMNUMBER,material.FMNAME, material.FGROUPNUMBER,material.FGROUPNAME into '+QUOTENAME(@tableName)+N'
from T_SAL_ORDERENTRY detail
left join T_SAL_ORDERENTRY_F f on detail.FENTRYID=f.FENTRYID
left join T_SAL_ORDER ord on ord.FID=detail.FID

left join 
--�������룬���ϱ���,����������룬��������ţ������������
(select m.FMATERIALID,n.FNAME FMNAME, g.FNUMBER FMNUMBER,g.FID  FGROUPID,g.FNUMBER FGROUPNUMBER,L.FNAME FGROUPNAME from t_bd_material m
left join T_BD_MATERIAL_L n on m.FMATERIALID=n.FMATERIALID
left join T_BD_MATERIALGROUP g on m.FMATERIALGROUP=g.FID
left join T_BD_MATERIALGROUP_L L on g.FID=L.FID
where L.FLOCALEID=2052) material on detail.FMATERIALID=material.FMATERIALID

left join
--���۲���
(select d.FDEPTID,d.FNUMBER FDEPNUMBER,L.FNAME FDEPNAME  from t_bd_department d 
left join t_bd_department_l L on d.FDEPTID=L.FDEPTID) dep on ord.FSALEDEPTID=dep.FDEPTID


left join
--����Ա
(select e.FENTRYID FSALERID,m.FNUMBER FSALERNUMBER,staff.FNAME as FSALENAME from T_BD_OPERATORENTRY e
left join  T_BD_STAFF_L staff on staff.FSTAFFID=e.FSTAFFID
left join T_BD_STAFF m on m.FSTAFFID=staff.FSTAFFID
where staff.FLOCALEID=2052 and e.FOPERATORTYPE=@type) saler on saler.FSALERID=ord.FSALERID

left join
--�ӿͻ�������������ȡ�����������ͻ����룬�ͻ���ţ��ͻ�ȫ�����ͻ�����
(select country.FDATAVALUE FCOUNTRYNAME,cust.FCUSTID,cust.FNUMBER FCUSTNUMBER,L.FNAME FCUSTNAME from T_BD_CUSTOMER cust
left join 
--ȡ���Ҹ�������
(select T1.FENTRYID,T1.FMASTERID,T1.FNUMBER,T2.FDATAVALUE,T3.FNAME from T_BAS_ASSISTANTDATAENTRY T1
                    left join T_BAS_ASSISTANTDATAENTRY_L T2 on T2.FENTRYID = T1.FENTRYID  and T2.FLOCALEID = 2052
                    left join T_BAS_ASSISTANTDATA_L T3 on T3.FID = T1.FID and T3.FLOCALEID = 2052
                    where T3.FNAME = @name) country on cust.FCOUNTRY=country.FMASTERID
left join T_BD_CUSTOMER_L L on cust.FCUSTID=L.FCUSTID
) customer on customer.FCUSTID=ord.FCUSTID
where ord.FDATE>=@start_date and ord.FDATE<=@end_date'

exec sp_executesql @stmt=@sqlStr,@params=N'@type nvarchar(8),@name nvarchar(8),@start_date date,@end_date date,@tableName nvarchar(256)',@type=@type,@name=@name,@start_date=@start_date,@end_date=@end_date,@tableName=@tableName
end
GO


