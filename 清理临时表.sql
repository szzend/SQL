SQL Server数据库清理临时表语句（选择具体的数据库之后执行）：
declare @sql as varchar(max)
set @sql=''
select @sql=@sql+'drop table '+name+';' from sys.tables u
join T_BAS_TEMPORARYTABLENAME v on u.name=v.FTABLENAME and 
( v.FPROCESSTYPE=1 or v.FCREATEDATE<GETDATE()-1);
exec(@sql);
delete u from T_BAS_TEMPORARYTABLENAME u where 
not exists(select 1 from sys.tables where u.ftablename=name );



Oracle数据库清理临时表语句：
--v.name='xxx'这里要改为需要删除的Oracle用户名，手工清理方式，每次清理1W行，如果超过1W需要执行多次
spool droptb.sql
select 'drop table '||u.name||' purge;' from sys.obj$  u join  sys.user$ v on u.owner#=v.user# and
 v.name='xxx' where u.name like 'TMP%'  and u.ctime<=sysdate-1 and rownum<=10000
spool off
@droptb.sql

