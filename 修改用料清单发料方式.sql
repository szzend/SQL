--���Ϸ�ʽ  FISSUETYPE 
--char(1) 1.ֱ������;2.ֱ�ӵ���;3.ת������;4.ת�ֵ���;5.���Ϸ���;7.������ 
--FSRCTRANSSTOCKID �����ֿ�
--FSTOCKID  ���ϲֿ�
--����ʱ�� FBACKFLUSHTYPE  1.��������;2.�㱨����;3.��⵹��

--T_PRD_PPBOMENTRY_Q(���������嵥������ϸ����)  �������� FPICKEDQTY
select c.FBACKFLUSHTYPE,c.FSTOCKID,c.FSRCTRANSSTOCKID,c.FISSUETYPE,prd.FSTATUS,bom.FBILLNO,q.FPICKEDQTY, m.FNUMBER, * from T_PRD_PPBOMENTRY_C c
left join T_PRD_PPBOMENTRY_Q q on c.FID=q.FID and c.FENTRYID=q.FENTRYID
left join T_PRD_PPBOMENTRY d on d.FID=c.FID and d.FENTRYID=c.FENTRYID
left join T_BD_MATERIAL m on m.FMATERIALID=d.FMATERIALID
left join T_PRD_PPBOM bom on c.FID=bom.FID
left join T_PRD_MOENTRY_A prd on prd.FENTRYID=bom.FMOENTRYID
where c.FISSUETYPE in ('2','4') and  prd.FSTATUS<'4' --����״̬Ϊ����֮ǰ

--T_PRD_PPBOMENTRY_C(���������嵥������ϸ���Ͽ���) FID  FENTRYID 

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
 select * from t_BD_Stock_L   --384600  ���������丨�ϲ�  ���ϲֿ� FPICKSTOCKID
								--����ʱ��  FBKFLTIME =null

update t_bd_materialproduce set FISSUETYPE='3',FBKFLTIME=null,FPICKSTOCKID=384600
where (FISSUETYPE='2' or FISSUETYPE='4')
