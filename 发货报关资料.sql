use T1025
--������ͼV_CN_DELIVERYNOTICE
if (exists (select * from sys.objects where name = 'V_CN_DELIVERYNOTICE'))
    drop view V_CN_DELIVERYNOTICE
go
create view V_CN_DELIVERYNOTICE 
as
select FID,FBILLNO,FSALEORGID,FDOCUMENTSTATUS,FCANCELSTATUS from T_SAL_DELIVERYNOTICE
go

--������ͼV_CN_DELIVERYNOTICE_L
if (exists (select * from sys.objects where name = 'V_CN_DELIVERYNOTICE_L'))
    drop view V_CN_DELIVERYNOTICE_L
go
create view V_CN_DELIVERYNOTICE_L
as
select FID as fpkid, FID,L.FNAME,2052 as FLOCALEID  from T_SAL_DELIVERYNOTICE m
left join T_BAS_BILLTYPE_L L on m.FBILLTYPEID=L.FBILLTYPEID
where L.FLOCALEID=2052


--������ͼV_CN_DELIVERYDETAIL
if (exists (select * from sys.objects where name = 'V_CN_DELIVERYDETAIL'))
    drop view V_CN_DELIVERYDETAIL
go
create view V_CN_DELIVERYDETAIL 
as
select e.FENTRYID,e.FSEQ FSEQ_FHTZ,m.FBILLNO FNOTICENO,FORDERNO,orderEntry.FSEQ FSEQ_order,mat.FNUMBER,mat_L.FNAME,u1.FNAME unit1,e.FQTY,saler.FSALERNUMBER,saler.FSALENAME,
customer.FCUSTNUMBER,customer.F_BHL_TEXT FCUSTNNumber, customer.FCUSTNAME,currency.FNAME currency,u2.fname unit2,entry_f.FPRICE,entry_f.FTAXPRICE,
--outstock.FOutBILLNO,outstock.FREALQTY,
m.FDOCUMENTSTATUS,m.FCANCELSTATUS from T_SAL_DELIVERYNOTICEENTRY e
left join T_SAL_DELIVERYNOTICE m on e.fid=m.fid
left join T_SAL_ORDERENTRY orderEntry on orderEntry.FENTRYID=e.FORDERSEQ
left join T_BD_UNIT_L u1 on u1.FUNITID=e.FUNITID
left join T_BD_MATERIAL mat on mat.FMASTERID=e.FMATERIALID
left join T_BD_MATERIAL_L mat_L on mat_L.FMATERIALID=e.FMATERIALID
left join T_SAL_ORDER sale_order on orderEntry.FID=sale_order.FID
left join --����Ա
(select e.FENTRYID FSALERID,m.FNUMBER FSALERNUMBER,staff.FNAME as FSALENAME from T_BD_OPERATORENTRY e
left join  T_BD_STAFF_L staff on staff.FSTAFFID=e.FSTAFFID
left join T_BD_STAFF m on m.FSTAFFID=staff.FSTAFFID
where staff.FLOCALEID=2052 and e.FOPERATORTYPE='XSY') saler on saler.FSALERID=sale_order.FSALERID
left join
--�ͻ����룬�ͻ���ţ��¿ͻ���ţ��ͻ�ȫ��
(select cust.FCUSTID,cust.FNUMBER FCUSTNUMBER,cust.F_BHL_TEXT,L.FNAME FCUSTNAME from T_BD_CUSTOMER cust
left join T_BD_CUSTOMER_L L on cust.FCUSTID=L.FCUSTID where L.FLOCALEID=2052
) customer on customer.FCUSTID=sale_order.FCUSTID
left join T_SAL_ORDERFIN fin on fin.FID=sale_order.FID
left join
--�ұ�
(select currency.FCURRENCYID,FNUMBER,L.FNAME from T_BD_CURRENCY currency
left join T_BD_CURRENCY_L L on currency.FCURRENCYID=L.FCURRENCYID
where L.FLOCALEID=2052) currency on fin.FSETTLECURRID=currency.FCURRENCYID
--���۵���
left join T_SAL_ORDERENTRY_F entry_f on orderEntry.FENTRYID=entry_f.FENTRYID
left join T_BD_UNIT_L u2 on u2.FUNITID=entry_f.FPRICEUNITID
--���۳��ⵥ
--left join(select sum(t.FRealQty)as FRealQty,t.FSID,t.FOutBILLNO from(
--select entry_o.FREALQTY,lk.FSID,outstock.FBILLNO FOutBILLNO  from T_SAL_OUTSTOCKENTRY_LK lk
--left join T_SAL_OUTSTOCKENTRY entry_o on entry_o.FENTRYID=lk.FENTRYID
--left join T_SAL_OUTSTOCK outstock on outstock.FID=entry_o.FID
--Դ��Ϊ����֪ͨ��
--where FSTABLEID=0) t group by t.FOutBILLNO,t.FSID) outstock on outstock.FSID=e.FENTRYID


where u1.FLOCALEID=2052 and mat_L.FLOCALEID=2052 and u2.FLOCALEID=2052
go

select * from V_CN_DELIVERYDETAIL

--������ͼV_CN_DELIVERYNOTICE_L
if (exists (select * from sys.objects where name = 'V_CN_DELIVERYDETAIL_L'))
    drop view V_CN_DELIVERYDETAIL_L
go
create view V_CN_DELIVERYDETAIL_L
as
select FENTRYID as fpkid, FENTRYID,L.FNAME,2052 as FLOCALEID  from T_SAL_DELIVERYNOTICEENTRY e
left join T_SAL_DELIVERYNOTICE m on m.FID=e.FID
left join T_BAS_BILLTYPE_L L on m.FBILLTYPEID=L.FBILLTYPEID
where L.FLOCALEID=2052 and FENTRYID not in(
select FENTRYID from V_CN_DELIVERYDETAIL)
select * from T_SAL_DELIVERYNOTICEENTRY where FENTRYID=100181

select * from V_CN_DELIVERYDETAIL
