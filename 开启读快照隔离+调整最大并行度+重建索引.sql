Cloud��˵������Ժ��������WISE/Cloud�����ȵ��������⣬���ȳ������·�����

      ������KSM���ţ�**���������⣬�뱸���������ĺ󣬽���ָ���Ϊ�����������ģ��ٳ������·�����

1��SQL���ݿ��п��������ո��뼶��ע��ڶ����͵���������Ҫѡ���Ӧ�Ĳ������ݿ�ʵ��������
��һ����
use master 
SELECT name,snapshot_isolation_state,snapshot_isolation_state_desc,is_read_committed_snapshot_on FROM sys.databases

�ڶ�����
ALTER DATABASE ��Ӧ���ݿ�ʵ���� SET READ_COMMITTED_SNAPSHOT ON  WITH ROLLBACK IMMEDIATE
���������ظ�ִ�е�һ����ȷ��״ֵ̬�Ƿ����˱仯��


2��--��������жȣ������޸�Ϊ1���������ݿ�ֱ��ִ�У��޸ķ������£�
sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'max degree of parallelism', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
RECONFIGURE

3�������Ӧ�Ĳ������ݿ�ʵ�壬�ؽ���ǰ���ݿ����б���������
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
  PRINT '�ؽ���' + @TableName +'������........OK!'
  FETCH NEXT FROM Cur_Index INTO @TableName
END
CLOSE Cur_Index
DEALLOCATE Cur_Index
PRINT '������ɣ�'

4������ͳ����Ϣ
--����ͳ����Ϣ
declare @SqlStr1 nvarchar(max)
set @SqlStr1=''
select  @SqlStr1= @SqlStr1+ + 'UPDATE STATISTICS '+name+ ';'  from sysobjects where xtype='U' and (name like 'T_%') and (name not like 'TMP%') 
exec (@SqlStr1)
