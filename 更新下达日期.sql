declare @fid int,@fentryid int,@fseq int,@fbillno nvarchar(80);
set @fbillno='MO190902004'
print @fbillno
set @fseq=1
select @fid=FID from T_PRD_MO where FBILLNO=@fbillno
select @fentryid=FENTRYID from T_PRD_MOENTRY where (FID=@fid and FSEQ=@fseq)
print cast(@fentryid as nvarchar(40))

declare @fconveydate datetime
set @fconveydate='2018-01-01'
print @fconveydate