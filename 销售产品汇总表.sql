--销售产品汇总表
--过滤条件：
--物料分组(选了分组，则只能选该分组内的物料代码、名称；如果不选，则查所有。)
--开始日期、结束日期(取生产订单的创建日期)
--开始功率、结束功率(文本，取物料的功率)
--开始灯珠、结束灯珠(文本，取物料的灯珠)
--取数来源：
--销售订单、物料
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JY_Drs_BHL_Product]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[JY_Drs_BHL_Product]
GO
CREATE PROCEDURE [dbo].[JY_Drs_BHL_Product]
	@MaterialGroup nvarchar(255), --物料分组
	@DateBegin datetime, --开始日期
	@DateEnd datetime, --结束日期
	@SNCGLBegin nvarchar(255), --开始功率
	@SNCGLEnd nvarchar(255), --结束功率
	@SNCDZBegin nvarchar(255), --开始灯珠
	@SNCDZEnd nvarchar(255), --结束灯珠
	@ORG nvarchar(max), --组织机构
	@FtableName nvarchar(255), --临时表
	@FCol nvarchar(255) --临时列
AS
	declare @strsql nvarchar(max);
	if @MaterialGroup is null begin set @MaterialGroup = '' end
	if @DateBegin is null begin set @DateBegin = dateadd(MONTH,-11,getdate()) end
	if @DateEnd is null begin set @DateEnd = getdate() end
	if @SNCGLBegin is null or @SNCGLBegin = ''
	begin
		select @SNCGLBegin = min(F_BHL_Text3) from T_BD_MATERIAL
	end
	if @SNCGLEnd is null or @SNCGLEnd = ''
	begin
		select @SNCGLEnd = max(F_BHL_Text3) from T_BD_MATERIAL
	end
	if @SNCDZBegin is null or @SNCDZBegin = ''
	begin
		select @SNCDZBegin = min(F_BHL_Text2) from T_BD_MATERIAL
	end
	if @SNCDZEnd is null or @SNCDZEnd = ''
	begin
		select @SNCDZEnd = max(F_BHL_Text2) from T_BD_MATERIAL
	end
begin
select
	T.FAPPROVEDATE, --日期
	sum(isnull(T.FQTY,0)) FQTY, --销售数量
	T.F_BHL_SNCGLDZ --功率/灯珠
into #orez
from (
	select
		left(convert(varchar(23),T1.FDATE,121),4)+'年'+substring(convert(varchar(23),T1.FDATE,121),6,2)+'月' FAPPROVEDATE, --日期
		case
		when T2.FUNITID = T4.FSTOREUNITID then isnull(T2.FQTY,0)
		when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then isnull(T2.FQTY,0)*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
		else isnull(T2.FQTY,0)
		end FQTY, --销售数量
		case
		when T3.F_BHL_Text2 = '' then T3.F_BHL_Text3
		when T3.F_BHL_Text3 = '' then T3.F_BHL_Text2
		else cast(T3.F_BHL_Text3 as nvarchar(255))+'/'+cast(T3.F_BHL_Text2 as nvarchar(255))
		end F_BHL_SNCGLDZ --功率/灯珠
	from T_SAL_ORDER T1 --销售订单
	left join T_SAL_ORDERENTRY T2 on T2.FID = T1.FID --订单明细
	left join T_BD_MATERIAL T3 on T3.FMATERIALID = T2.FMATERIALID --物料
	left join t_BD_MaterialStock T4 on T4.FMATERIALID = T3.FMATERIALID --物料_库存
	left join (
		select
			FDESTUNITID, --目标单位
			FCURRENTUNITID, --当前单位
			FCONVERTDENOMINATOR, --换算分子
			FCONVERTNUMERATOR --换算分母
		from T_BD_UNITCONVERTRATE
		union
		select
			FCURRENTUNITID FDESTUNITID, --目标单位
			FDESTUNITID FCURRENTUNITID, --当前单位
			FCONVERTNUMERATOR FCONVERTDENOMINATOR, --换算分子
			FCONVERTDENOMINATOR FCONVERTNUMERATOR --换算分母
		from T_BD_UNITCONVERTRATE
	) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --计量单位_转换率，目标单位=销售单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
	where T1.FDOCUMENTSTATUS = 'C' --单据状态：已审核
	--and T1.FCLOSESTATUS = 'A' --关闭状态：正常
	and T1.FCANCELSTATUS = 'A' --作废状态：未作废
	and T2.FMRPTERMINATESTATUS = 'A' --业务终止：正常
	--and T2.FMRPCLOSESTATUS = 'A' --业务关闭：未关闭
	and T2.FMRPFREEZESTATUS = 'A' --业务冻结：正常
	and T1.FMANUALCLOSE = '0' --是否手工关闭：否
	and (T3.F_BHL_Text3 <> '' or T3.F_BHL_Text2 <> '') --功率/灯珠
	and T3.FMATERIALGROUP like @MaterialGroup+'%' --物料分组
	and (left(convert(varchar(23),T1.FDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --审核日期
	and T3.F_BHL_Text3 between @SNCGLBegin and @SNCGLEnd --功率
	and T3.F_BHL_Text2 between @SNCDZBegin and @SNCDZEnd --灯珠
	and T1.FSALEORGID = @ORG --组织
) T
group by T.FAPPROVEDATE,T.F_BHL_SNCGLDZ
select
	T1.FAPPROVEDATE, --审核日期
	T1.FQTY, --销售数量
	T2.F_BHL_Total, --总计
	case
	when cast(cast(datediff(day,@DateBegin,@DateEnd) as decimal(18,2))/30 as decimal(18,2)) = 0 then cast(isnull(T2.F_BHL_Total,0) as decimal(18,2))
	else cast(isnull(T2.F_BHL_Total,0)/cast(cast(datediff(day,@DateBegin,@DateEnd) as decimal(18,4))/30 as decimal(18,3)) as decimal(18,2))
	end F_BHL_AverageDosage, --平均用量
	T1.F_BHL_SNCGLDZ --功率/灯珠
into #zero
from #orez T1
left join (
	select
		sum(isnull(FQTY,0)) F_BHL_Total, --销售数量
		F_BHL_SNCGLDZ --功率/灯珠
	from #orez
	group by F_BHL_SNCGLDZ
) T2 on T2.F_BHL_SNCGLDZ = T1.F_BHL_SNCGLDZ
--行列转换、临时表、临时列
set @strsql = 'IF EXISTS (SELECT * FROM dbo.SysObjects WHERE ID = object_id(N''[' + @FtableName + ']'') AND OBJECTPROPERTY(ID,''IsTable'') = 1) drop table ' + @FtableName + ';'
exec(@strsql)
set @strsql = 'select F_BHL_SNCGLDZ,F_BHL_Total,F_BHL_AverageDosage'
select @strsql = @strsql + ',sum(case FAPPROVEDATE when ''' + FAPPROVEDATE + ''' then FQTY else 0 end) as [' + FAPPROVEDATE +']'
from (select distinct FAPPROVEDATE from #zero) T
select @strsql = @strsql + ','+@FCol+' into '+@FtableName+' from #zero group by F_BHL_SNCGLDZ,F_BHL_Total,F_BHL_AverageDosage'
exec(@strsql)
drop table #orez
drop table #zero
end
