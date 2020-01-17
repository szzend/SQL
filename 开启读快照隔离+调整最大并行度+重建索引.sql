Cloud审核单据请稍候进度条、WISE/Cloud死锁等单账套问题，可先尝试以下方案。

      关于您KSM单号：**反馈的问题，请备份数据中心后，将其恢复作为测试数据中心，再尝试以下方案：

1、SQL数据库中开启读快照隔离级别，注意第二步和第三步，需要选择对应的测试数据库实体名——
第一步：
use master 
SELECT name,snapshot_isolation_state,snapshot_isolation_state_desc,is_read_committed_snapshot_on FROM sys.databases

第二步：
ALTER DATABASE 对应数据库实体名 SET READ_COMMITTED_SNAPSHOT ON  WITH ROLLBACK IMMEDIATE
第三步：重复执行第一步，确认状态值是否发生了变化。


2、--调整最大并行度，建议修改为1，可在数据库直接执行，修改方法如下：
sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'max degree of parallelism', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
RECONFIGURE

3、进入对应的测试数据库实体，重建当前数据库所有表索引——
DECLARE @DBCCString NVARCHAR(1000)
DECLARE @TableName VARCHAR(100)
DECLARE Cur_Index CURSOR FOR
  SELECT Name AS TblName FROM sysobjects WHERE xType='U' ORDER BY TblName
FOR READ ONLY
OPEN Cur_Index
FETCH NEXT FROM Cur_Index INTO @TableName
WHILE @@FETCH_STATUS=0
BEGIN
  SET @DBCCString = 'DBCC DBREINDEX(@TblName,'''')WITH NO_INFOMSGS'
  EXEC SP_EXECUTESQL  @DBCCString,N'@TblName VARCHAR(100)',@TableName
  PRINT '重建表' + @TableName +'的索引........OK!'
  FETCH NEXT FROM Cur_Index INTO @TableName
END
CLOSE Cur_Index
DEALLOCATE Cur_Index
PRINT '操作完成！'

4、更新统计信息
--更新统计信息
declare @SqlStr1 nvarchar(max)
set @SqlStr1=''
select  @SqlStr1= @SqlStr1+ + 'UPDATE STATISTICS '+name+ ';'  from sysobjects where xtype='U' and (name like 'T_%') and (name not like 'TMP%') 
exec (@SqlStr1)
