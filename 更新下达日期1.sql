--������������ѡ����Χ�ڵ� �������ϵ� �´�����Ϊ�յ��ⲿ�� �����´�����Ϊ���ڵ�һ��
update T_PRD_MOENTRY_A set FCONVEYDATE='2019-09-01' where FENTRYID in
(select a.FENTRYID from T_PRD_MOENTRY_A a left join T_PRD_MOENTRY_Q q 
on q.FENTRYID=a.FENTRYID
where a.FCONVEYDATE is null
and a.FSTARTDATE between '2019-09-01'and '2019-09-30'
and q.FPICKMTRLSTATUS>1)


--SELECT  DATEADD(mm,  DATEDIFF(mm,0,getdate()),  0) 

