SQL Server���ݿ�������ʱ����䣨ѡ���������ݿ�֮��ִ�У���
declare @sql as varchar(max)
set @sql=''
select @sql=@sql+'drop table '+name+';' from sys.tables u
join T_BAS_TEMPORARYTABLENAME v on u.name=v.FTABLENAME and 
( v.FPROCESSTYPE=1 or v.FCREATEDATE<GETDATE()-1);
exec(@sql);
delete u from T_BAS_TEMPORARYTABLENAME u where 
not exists(select 1 from sys.tables where u.ftablename=name );



Oracle���ݿ�������ʱ����䣺
--v.name='xxx'����Ҫ��Ϊ��Ҫɾ����Oracle�û������ֹ�����ʽ��ÿ������1W�У��������1W��Ҫִ�ж��
spool droptb.sql
select 'drop table '||u.name||' purge;' from sys.obj$  u join  sys.user$ v on u.owner#=v.user# and
 v.name='xxx' where u.name like 'TMP%'  and u.ctime<=sysdate-1 and rownum<=10000
spool off
@droptb.sql

