--子项物料汇总表
--过滤条件：
--物料分组(选了分组，则只能选该分组内的物料代码、名称；如果不选，则查所有。)
--开始物料编码、结束物料编码(填了就查开始结束，不选就查全部)
--开始物料名称、结束物料名称(填了就查开始结束，不选就查全部)
--开始日期、结束日期(取生产订单的创建日期)
--取数来源：
--生产订单[结案类型：非强制结案]、生产用料清单(主表)、委外订单、委外用料清单、物料清单、采购申请单、采购订单、即时库存、物料。
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JY_Drs_BHL_Subcode]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[JY_Drs_BHL_Subcode]
GO
CREATE PROCEDURE [dbo].[JY_Drs_BHL_Subcode]
	@MaterialGroup nvarchar(255), --物料分组
	@NumberBegin nvarchar(255), --开始物料编码
	@NumberEnd nvarchar(255), --结束物料编码
	@NameBegin nvarchar(255), --开始物料名称
	@NameEnd nvarchar(255), --结束物料名称
	@DateBegin datetime, --开始日期
	@DateEnd datetime, --结束日期
	@NumberM nvarchar(max), --物料编码高级过滤
	@filterString nvarchar(max), --条件
	@ORG nvarchar(max), --组织机构
	@FtableName nvarchar(255), --临时表
	@FCol nvarchar(255) --临时列
AS
	declare @strsql nvarchar(max);
	if @MaterialGroup is null begin set @MaterialGroup = '' end
	if @NumberBegin is null or @NumberBegin = ''
	begin
		select @NumberBegin = min(FNUMBER) from T_BD_MATERIAL
	end
	if @NumberEnd is null or @NumberEnd = ''
	begin
		select @NumberEnd = max(FNUMBER) from T_BD_MATERIAL
	end
	if @NameBegin is null or @NameBegin = ''
	begin
		select @NameBegin = min(FNAME) from T_BD_MATERIAL_L where FLOCALEID = 2052
	end
	else
	begin
		select @NameBegin = FNAME from T_BD_MATERIAL_L where FLOCALEID = 2052 and FMATERIALID = @NameBegin
	end
	if @NameEnd is null or @NameEnd = ''
	begin
		select @NameEnd = max(FNAME) from T_BD_MATERIAL_L where FLOCALEID = 2052
	end
	else
	begin
		select @NameEnd = FNAME from T_BD_MATERIAL_L where FLOCALEID = 2052 and FMATERIALID = @NameEnd
	end
	if @DateBegin is null begin set @DateBegin = dateadd(MONTH,-11,getdate()) end
	if @DateEnd is null begin set @DateEnd = getdate() end
	if @filterString is null begin set @filterString = '' end
begin
--展开BOM
select
	LV = 1, --层级
	DealFlg = 0, --是否展开
	T1.CREATEDATE,
	T1.FCREATEDATE, --创建日期
	T2.FMATERIALID, --子项物料编码
	T2.FBOMID, --BOM版本
	sum(isnull(T2.FMUSTQTY,0)) FMUSTQTY --应发数量
into #BOM
from (
	select
		T1.FID, --单据主键
		T2.FEntryID, --分录主键
		T1.FCREATEDATE CREATEDATE,
		left(convert(varchar(23),T1.FCREATEDATE,121),4)+'年'+substring(convert(varchar(23),T1.FCREATEDATE,121),6,2)+'月' FCREATEDATE
	from T_PRD_MO T1 --生产订单
	left join T_PRD_MOENTRY T2 on T2.FID = T1.FID --明细
	left join T_PRD_MOENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
	where T3.FCLOSETYPE <> 'C' --结案类型：<>强制结案
	and (left(convert(varchar(23),T1.FCREATEDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --创建日期
) T1
inner join (
	select
		T1.FID, --单据主键
		T2.FEntryID, --分录主键
		T1.FMOID, --生产订单内码
		T1.FMOENTRYID, --生产订单分录内码
		T2.FMATERIALID, --子项物料编码
		T2.FBOMID, --BOM版本
		case
		when T2.FUNITID = T5.FSTOREUNITID then isnull(T2.FMUSTQTY,0)
		when T6.FCONVERTDENOMINATOR is not null and T6.FCONVERTNUMERATOR is not null then isnull(T2.FMUSTQTY,0)*T6.FCONVERTDENOMINATOR/T6.FCONVERTNUMERATOR
		else isnull(T2.FMUSTQTY,0)
		end FMUSTQTY --应发数量
	from T_PRD_PPBOM T1 --生产用料清单
	left join T_PRD_PPBOMENTRY T2 on T2.FID = T1.FID --子项明细
	left join T_PRD_PPBOMENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
	left join T_ORG_Organizations T4 on T4.FORGID = T1.FPRDORGID --组织机构
	left join t_BD_MaterialStock T5 on T5.FMATERIALID = T2.FMATERIALID --物料_库存
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
	) T6 on T6.FDESTUNITID = T2.FUNITID and T6.FCURRENTUNITID = T5.FSTOREUNITID --计量单位_转换率，目标单位=子项单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
	where T4.FNUMBER = @ORG --组织编码
) T2 on T2.FMOID = T1.FID and T2.FMOENTRYID = T1.FEntryID
group by T1.CREATEDATE,T1.FCREATEDATE,T2.FMATERIALID,T2.FBOMID
--物料清单
select
	T1.FID, --单据主键
	T2.FEntryID, --分录主键
	T1.FMATERIALID Parentcode, --父项物料编码
	T2.FMATERIALID, --子项物料编码
	T2.FBOMID, --子项BOM版本
	T2.FNUMERATOR, --用量:分子
	T2.FDENOMINATOR --用量:分母
into #BOM1
from T_ENG_BOM T1 --物料清单
left join T_ENG_BOMCHILD T2 on T2.FID = T1.FID --子项明细
left join t_BD_MaterialBase T3 on T3.FMATERIALID = T1.FMATERIALID --物料_基本
left join T_ORG_Organizations T4 on T4.FORGID = T1.FUSEORGID --组织机构
where T1.FDOCUMENTSTATUS = 'C' --数据状态：已审核
and T3.FERPCLSID = 3 --物料属性：委外
and T4.FNUMBER = @ORG --组织编码
select
	T1.PARENTCODE, --父项物料编码
	T2.FID, --单据主键
	T2.FMATERIALID, --子项物料编码
	T2.FBOMID, --子项BOM版本
	T2.FNUMERATOR, --用量:分子
	T2.FDENOMINATOR, --用量:分母
	T2.FEXPIREDATE --失效日期
into #BOM2
from (
	SELECT
		T1.FMATERIALID PARENTCODE, --父项物料编码
		MAX(T1.FAPPROVEDATE) FAPPROVEDATE --审核日期
	FROM T_ENG_BOM T1 --物料清单
	LEFT JOIN T_ENG_BOMCHILD T2 ON T2.FID = T1.FID --子项明细
	LEFT JOIN T_BD_MATERIALBASE T3 ON T3.FMATERIALID = T1.FMATERIALID --物料_基本
	left join T_ORG_Organizations T4 on T4.FORGID = T1.FUSEORGID --组织机构
	WHERE T1.FDOCUMENTSTATUS = 'C' --数据状态：已审核
	AND T1.FFORBIDSTATUS = 'A' --禁用状态：否
	AND T3.FERPCLSID = 3 --物料属性：委外
	and T4.FNUMBER = @ORG --组织编码
	GROUP BY T1.FMATERIALID
) T1
inner join (
	SELECT
		T1.FID, --单据主键
		T2.FENTRYID, --分录主键
		T1.FMATERIALID PARENTCODE, --父项物料编码
		T2.FMATERIALID, --子项物料编码
		T2.FBOMID, --子项BOM版本
		T2.FNUMERATOR, --用量:分子
		T2.FDENOMINATOR --用量:分母
		,T1.FAPPROVEDATE --审核日期
		,T2.FEXPIREDATE --失效日期
	FROM T_ENG_BOM T1 --物料清单
	LEFT JOIN T_ENG_BOMCHILD T2 ON T2.FID = T1.FID --子项明细
	LEFT JOIN T_BD_MATERIALBASE T3 ON T3.FMATERIALID = T1.FMATERIALID --物料_基本
	left join T_ORG_Organizations T4 on T4.FORGID = T1.FUSEORGID --组织机构
	WHERE T1.FDOCUMENTSTATUS = 'C' --数据状态：已审核
	AND T1.FFORBIDSTATUS = 'A' --禁用状态：否
	AND T3.FERPCLSID = 3 --物料属性：委外
	and T4.FNUMBER = @ORG --组织编码
) T2 on T2.PARENTCODE = T1.PARENTCODE and T2.FAPPROVEDATE = T1.FAPPROVEDATE
--循环
DECLARE @LV INT
SELECT @LV = MIN(LV) FROM #BOM where DealFlg = 0
WHILE @LV IS NOT NULL
BEGIN
	insert into #BOM(LV,DealFlg,CREATEDATE,FCREATEDATE,FMATERIALID,FBOMID,FMUSTQTY)
	select
		@LV+1 LV,
		DealFlg = 0,
		#BOM.CREATEDATE,
		#BOM.FCREATEDATE,
		T.FMATERIALID,
		T.FBOMID,
		isnull(#BOM.FMUSTQTY,0)*isnull(T.FNUMERATOR,0)/isnull(T.FDENOMINATOR,0) FMUSTQTY
	from #BOM
	inner join #BOM1 T on T.Parentcode = #BOM.FMATERIALID and T.FID = #BOM.FBOMID
	where #BOM.DealFlg = 0
	insert into #BOM(LV,DealFlg,CREATEDATE,FCREATEDATE,FMATERIALID,FBOMID,FMUSTQTY)
	select
		@LV+1 LV,
		DealFlg = 0,
		#BOM.CREATEDATE,
		#BOM.FCREATEDATE,
		T.FMATERIALID,
		T.FBOMID,
		isnull(#BOM.FMUSTQTY,0)*isnull(T.FNUMERATOR,0)/isnull(T.FDENOMINATOR,0) FMUSTQTY
	from #BOM
	inner join #BOM2 T on T.Parentcode = #BOM.FMATERIALID
	where #BOM.DealFlg = 0
	and #BOM.FBOMID = 0
	and #BOM.CREATEDATE <= T.FEXPIREDATE
	update #BOM set DealFlg = 1 where LV = @LV
	SELECT @LV = MIN(LV) FROM #BOM where DealFlg = 0
END
--取数
select
	T0.FCREATEDATE, --创建日期
	T0.FMATERIALID, --物料内码
	T2.FOLDNUMBER F_BHL_OldNumber, --旧物料编码
	T2.FMATERIALGROUP, --分组内码
	T2.GROUPNAME F_BHL_MaterialGroup, --物料分组
	T2.FNUMBER F_BHL_NewNumber, --物料编码
	T2.FNAME F_BHL_Name, --物料名称
	T2.FSPECIFICATION F_BHL_Specification, --规格型号
	T0.FMUSTQTY, --应发数量
	isnull(T1F1.FNOPICKEDQTY,0)+isnull(T1F2.FNOPICKEDQTY,0) F_BHL_ddywlsl, --未领数量
	T3.FBASEQTY F_BHL_yclcjskcsl, --原材料仓即时库存数量
	T4.FBASEQTY F_BHL_gyscjskcsl, --供应商仓即时库存数量
	isnull(T5.FREMAINQTY,0)+isnull(T6.FREMAINSTOCKINQTY,0)+isnull(T7.FQTY,0) F_BHL_whsl, --未回数量
	isnull(T3.FBASEQTY,0)+isnull(T4.FBASEQTY,0)+isnull(T5.FREMAINQTY,0)+isnull(T6.FREMAINSTOCKINQTY,0)+isnull(T7.FQTY,0)-isnull(T1F1.FNOPICKEDQTY,0)-isnull(T1F2.FNOPICKEDQTY,0) F_BHL_sysl, --剩余数量
	T2.FSAFESTOCK F_BHL_aqkc, --安全库存
	T2.FIXLEADTIME F_BHL_cgzq, --固定提前期+固定提前期单位
	T2.FINCREASEQTY F_BHL_zxbzl, --最小包装量
	case
	when isnull(T2.FSAFESTOCK,0)-isnull(T3.FBASEQTY,0)>0 then isnull(T2.FSAFESTOCK,0)-isnull(T3.FBASEQTY,0)
	else null
	end F_BHL_yclcthsl --原材料仓提货数量
into #zero
from (
	select
		FCREATEDATE,
		FMATERIALID,
		sum(isnull(FMUSTQTY,0)) FMUSTQTY
	from #BOM
	group by FCREATEDATE,FMATERIALID
) T0
left join(
	select
		T2.FMATERIALID, --子项物料编码
		sum(isnull(T2.FNOPICKEDQTY,0)) FNOPICKEDQTY --未领数量
	from (
		select
			T1.FID, --单据主键
			T2.FEntryID, --分录主键
			T1.FCREATEDATE CREATEDATE, --创建日期
			left(convert(varchar(23),T1.FCREATEDATE,121),4)+'年'+substring(convert(varchar(23),T1.FCREATEDATE,121),6,2)+'月' FCREATEDATE --创建年月
		from T_SUB_REQORDER T1 --委外订单_单据头
		left join T_SUB_REQORDERENTRY T2 on T2.FID = T1.FID --委外订单_明细
		left join T_SUB_REQORDERENTRY_A T3 on T3.FENTRYID = T2.FENTRYID --委外订单_明细_A
		where T2.FSTATUS not in (6,7) --业务状态：<>结案,<>结算
		and T3.FCLOSETYPE <> 'C' --结案类型：<>强制结案
		and (left(convert(varchar(23),T1.FCREATEDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --创建日期
	) T1
	inner join (
		select
			T1.FID, --单据主键
			T2.FEntryID, --分录主键
			T1.FSUBREQID, --委外订单内码
			T1.FSUBREQENTRYID, --委外订单分录内码
			T2.FMATERIALID, --子项物料编码
			T2.FBOMID, --BOM版本
			case
			when T2.FUNITID = T5.FSTOREUNITID then isnull(T3.FNOPICKEDQTY,0)
			when T6.FCONVERTDENOMINATOR is not null and T6.FCONVERTNUMERATOR is not null then isnull(T3.FNOPICKEDQTY,0)*T6.FCONVERTDENOMINATOR/T6.FCONVERTNUMERATOR
			else isnull(T3.FNOPICKEDQTY,0)
			end FNOPICKEDQTY --未领数量
		from T_SUB_PPBOM T1 --委外用料清单_单据头
		left join T_SUB_PPBOMENTRY T2 on T2.FID = T1.FID --子项明细
		left join T_SUB_PPBOMENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
		left join T_ORG_Organizations T4 on T4.FORGID = T1.FSUBORGID --组织机构
		left join t_BD_MaterialStock T5 on T5.FMATERIALID = T2.FMATERIALID --物料_库存
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
		) T6 on T6.FDESTUNITID = T2.FUNITID and T6.FCURRENTUNITID = T5.FSTOREUNITID --计量单位_转换率，目标单位=子项单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
		where T4.FNUMBER = @ORG --组织编码
	) T2 on T2.FSUBREQID = T1.FID and T2.FSUBREQENTRYID = T1.FEntryID
	group by T2.FMATERIALID
) T1F1 on T1F1.FMATERIALID = T0.FMATERIALID
left join (
	select
		T2.FMATERIALID, --子项物料编码
		sum(isnull(T2.FNOPICKEDQTY,0)) FNOPICKEDQTY --未领数量
	from (
		select
			T1.FID, --单据主键
			T2.FEntryID, --分录主键
			T1.FCREATEDATE CREATEDATE,
			left(convert(varchar(23),T1.FCREATEDATE,121),4)+'年'+substring(convert(varchar(23),T1.FCREATEDATE,121),6,2)+'月' FCREATEDATE
		from T_PRD_MO T1 --生产订单
		left join T_PRD_MOENTRY T2 on T2.FID = T1.FID --明细
		left join T_PRD_MOENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
		left join T_PRD_MOENTRY_A T4 on T4.FENTRYID = T2.FENTRYID
		where T4.FSTATUS not in (6,7) --业务状态：<>结案,<>结算
		and T3.FCLOSETYPE <> 'C' --结案类型：<>强制结案
		and (left(convert(varchar(23),T1.FCREATEDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --创建日期
	) T1
	inner join (
		select
			T1.FID, --单据主键
			T2.FEntryID, --分录主键
			T1.FMOID, --生产订单内码
			T1.FMOENTRYID, --生产订单分录内码
			T2.FMATERIALID, --子项物料编码
			T2.FBOMID, --BOM版本
			case
			when T2.FUNITID = T5.FSTOREUNITID then isnull(T3.FNOPICKEDQTY,0)
			when T6.FCONVERTDENOMINATOR is not null and T6.FCONVERTNUMERATOR is not null then isnull(T3.FNOPICKEDQTY,0)*T6.FCONVERTDENOMINATOR/T6.FCONVERTNUMERATOR
			else isnull(T3.FNOPICKEDQTY,0)
			end FNOPICKEDQTY --未领数量
		from T_PRD_PPBOM T1 --生产用料清单
		left join T_PRD_PPBOMENTRY T2 on T2.FID = T1.FID --子项明细
		left join T_PRD_PPBOMENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
		left join T_ORG_Organizations T4 on T4.FORGID = T1.FPRDORGID --组织机构
		left join t_BD_MaterialStock T5 on T5.FMATERIALID = T2.FMATERIALID --物料_库存
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
		) T6 on T6.FDESTUNITID = T2.FUNITID and T6.FCURRENTUNITID = T5.FSTOREUNITID --计量单位_转换率，目标单位=子项单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
		where T4.FNUMBER = @ORG --组织编码
	) T2 on T2.FMOID = T1.FID and T2.FMOENTRYID = T1.FEntryID
	group by T2.FMATERIALID
) T1F2 on T1F2.FMATERIALID = T0.FMATERIALID
left join (
	select
		T1.FMATERIALID, --物料内码
		T1.FOLDNUMBER, --旧物料编码
		T1.FMATERIALGROUP, --分组内码
		T4.FNAME GROUPNAME, --物料分组
		T1.FNUMBER, --物料编码
		T2.FNAME, --物料名称
		T2.FSPECIFICATION, --规格型号
		T5.FSAFESTOCK, --安全库存
		cast(T6.FFIXLEADTIME as nvarchar(255))+cast(T8.FCAPTION as nvarchar(255)) FIXLEADTIME,--固定提前期+固定提前期单位
		T6.FINCREASEQTY, --最小包装量
		T9.FERPCLSID --物料属性：3(委外)
	from T_BD_MATERIAL T1 --物料
	left join T_BD_MATERIAL_L T2 on T2.FMATERIALID = T1.FMATERIALID and T2.FLOCALEID = 2052
	left join T_BD_MATERIALGROUP T3 on T3.FID = T1.FMATERIALGROUP --数据分组
	left join T_BD_MATERIALGROUP_L T4 on T4.FID = T3.FID and T4.FLOCALEID = 2052
	left join t_BD_MaterialStock T5 on T5.FMATERIALID = T1.FMATERIALID --库存
	left join t_BD_MaterialPlan T6 on T6.FMATERIALID = T1.FMATERIALID --计划
	left join T_META_FORMENUMITEM T7 on T7.FVALUE = T6.FFIXLEADTIMETYPE and T7.FID = '3948b044-f8df-4ff0-927d-295eb4f478fc' --枚举
	left join T_META_FORMENUMITEM_L T8 on T8.FENUMID = T7.FENUMID and T8.FLOCALEID = 2052
	left join t_BD_MaterialBase T9 on T9.FMATERIALID = T1.FMATERIALID --物料_基本
) T2 on T2.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --物料编码
		sum(isnull(FBASEQTY,0)) FBASEQTY --剩余数量
	from (
		select
			T1.FMATERIALID, --物料编码
			case
			when T1.FBASEUNITID = T1.FSTOCKUNITID then isnull(T1.FBASEQTY,0)
			when T4.FCONVERTDENOMINATOR is not null and T4.FCONVERTNUMERATOR is not null
			then isnull(T1.FBASEQTY,0)*T4.FCONVERTDENOMINATOR/T4.FCONVERTNUMERATOR --库存量(基本单位)*换算分母/换算分子 = 库存量(主单位)
			else isnull(T1.FBASEQTY,0)
			end FBASEQTY --剩余数量
		from T_STK_INVENTORY T1 --即时库存
		left join t_BD_Stock T2 on T2.FSTOCKID = T1.FSTOCKID
		left join t_BD_Stock_L T3 on T3.FSTOCKID = T2.FSTOCKID and T3.FLOCALEID = 2052
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
		) T4 on T4.FDESTUNITID = T1.FBASEUNITID and T4.FCURRENTUNITID = T1.FSTOCKUNITID --计量单位_转换率，目标单位=基本单位，当前单位=库存主单位
		where T3.FNAME = '原材料仓' --仓库名称：原材料仓
	) T
	group by T.FMATERIALID
) T3 on T3.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --物料编码
		sum(isnull(FBASEQTY,0)) FBASEQTY --剩余数量
	from (
		select
			T1.FMATERIALID, --物料编码
			case
			when T1.FBASEUNITID = T1.FSTOCKUNITID then isnull(T1.FBASEQTY,0)
			when T3.FCONVERTDENOMINATOR is not null and T3.FCONVERTNUMERATOR is not null
			then isnull(T1.FBASEQTY,0)*T3.FCONVERTDENOMINATOR/T3.FCONVERTNUMERATOR --库存量(基本单位)*换算分母/换算分子 = 库存量(主单位)
			else isnull(T1.FBASEQTY,0)
			end FBASEQTY --剩余数量
		from T_STK_INVENTORY T1 --即时库存
		left join t_BD_Stock T2 on T2.FSTOCKID = T1.FSTOCKID
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
		) T3 on T3.FDESTUNITID = T1.FBASEUNITID and T3.FCURRENTUNITID = T1.FSTOCKUNITID --计量单位_转换率，目标单位=基本单位，当前单位=库存主单位
		where T2.FSTOCKPROPERTY = 3 --仓库属性：供应商仓库
	) T
	group by T.FMATERIALID
) T4 on T4.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --物料编码
		sum(isnull(FREMAINQTY,0)) FREMAINQTY --剩余数量
	from (
		select
			T2.FMATERIALID, --物料编码
			case
			when T2.FUNITID = T4.FSTOREUNITID then isnull(T3.FREMAINQTY,0)
			when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then isnull(T3.FREMAINQTY,0)*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
			else isnull(T3.FREMAINQTY,0)
			end FREMAINQTY --剩余数量
		from T_PUR_Requisition T1 --采购申请单
		left join T_PUR_ReqEntry T2 on T2.FID = T1.FID --明细信息
		left join T_PUR_REQENTRY_R T3 on T3.FENTRYID = T2.FENTRYID
		left join t_BD_MaterialStock T4 on T4.FMATERIALID = T2.FMATERIALID --物料_库存
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
		) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --计量单位_转换率，目标单位=申请单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
		where T1.FDOCUMENTSTATUS = 'C' --数据状态：已审核
		and T1.FCLOSESTATUS = 'A' --关闭状态：未关闭
		and T2.FMRPCLOSESTATUS = 'A' --业务关闭：正常
		and T2.FMRPTERMINATESTATUS = 'A' --业务终止：正常
	) T
	group by T.FMATERIALID
) T5 on T5.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --物料编码
		sum(isnull(T.FREMAINSTOCKINQTY,0)) FREMAINSTOCKINQTY --剩余入库数量
	from (
		select
			T2.FMATERIALID, --物料编码
			case
			when T2.FUNITID = T4.FSTOREUNITID then isnull(T3.FREMAINSTOCKINQTY,0)
			when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then isnull(T3.FREMAINSTOCKINQTY,0)*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
			else isnull(T3.FREMAINSTOCKINQTY,0)
			end FREMAINSTOCKINQTY --剩余入库数量
		from t_PUR_POOrder T1 --采购订单
		left join t_PUR_POOrderEntry T2 on T2.FID = T1.FID --明细信息
		left join T_PUR_POORDERENTRY_R T3 on T3.FENTRYID = T2.FENTRYID
		left join t_BD_MaterialStock T4 on T4.FMATERIALID = T2.FMATERIALID --物料_库存
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
		) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --计量单位_转换率，目标单位=采购单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
		where T1.FDOCUMENTSTATUS = 'C' --数据状态：已审核
		and T1.FCLOSESTATUS = 'A' --关闭状态：未关闭
		and T1.FCANCELSTATUS = 'A' --作废状态：否
		and T2.FMRPCLOSESTATUS = 'A' --业务关闭：正常
		and T2.FMRPTERMINATESTATUS = 'A' --业务终止：正常
	) T
	group by T.FMATERIALID
) T6 on T6.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --物料编码
		sum(isnull(T.FQTY,0)) FQTY --数量-采购执行数量
	from (
		select
			T2.FMATERIALID, --物料编码
			case
			when T2.FUNITID = T4.FSTOREUNITID then isnull(T2.FQTY,0)-isnull(T2.FPURQTY,0)
			when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then (isnull(T2.FQTY,0)-isnull(T2.FPURQTY,0))*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
			else isnull(T2.FQTY,0)-isnull(T2.FPURQTY,0)
			end FQTY --数量-采购执行数量
		from T_SUB_REQORDER T1 --委外订单
		left join T_SUB_REQORDERENTRY T2 on T2.FID = T1.FID --明细
		left join T_SUB_REQORDERENTRY_A T3 on T3.FENTRYID = T2.FENTRYID
		left join t_BD_MaterialStock T4 on T4.FMATERIALID = T2.FMATERIALID --物料_库存
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
		) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --计量单位_转换率，目标单位=单位，当前单位=库存单位，目标单位*换算分母/换算分子 = 当前单位
		where T1.FDOCUMENTSTATUS = 'C' --数据状态：已审核
		and T1.FCANCELSTATUS = 'A' --作废状态：否
		and T2.FSTATUS not in (6,7) --业务状态：<>结案,<>结算
		and T3.FCLOSETYPE <> 'C' --结案类型：<>强制结案
		and isnull(T2.FPURQTY,0) <> isnull(T2.FQTY,0) --采购执行数量<>数量
	) T
	group by T.FMATERIALID
) T7 on T7.FMATERIALID = T0.FMATERIALID
select
	T1.FCREATEDATE, --创建日期
	T1.FMATERIALID, --物料内码
	T1.F_BHL_OldNumber, --旧物料编码
	T1.FMATERIALGROUP, --分组内码
	T1.F_BHL_MaterialGroup, --物料分组
	T1.F_BHL_NewNumber, --物料编码
	T1.F_BHL_Name, --物料名称
	T1.F_BHL_Specification, --规格型号
	T1.FMUSTQTY, --应发数量
	T2.F_BHL_Total, --总计
	case
	when cast(cast(datediff(day,@DateBegin,@DateEnd) as decimal(18,2))/30 as decimal(18,2)) = 0 then cast(isnull(T2.F_BHL_Total,0) as decimal(18,2))
	else cast(isnull(T2.F_BHL_Total,0)/cast(cast(datediff(day,@DateBegin,@DateEnd) as decimal(18,2))/30 as decimal(18,2)) as decimal(18,2))
	end F_BHL_AverageDosage, --平均用量
	T1.F_BHL_ddywlsl, --未领数量
	T1.F_BHL_yclcjskcsl, --原材料仓即时库存数量
	T1.F_BHL_gyscjskcsl, --供应商仓即时库存数量
	T1.F_BHL_whsl, --未回数量
	T1.F_BHL_sysl, --剩余数量
	T1.F_BHL_aqkc, --安全库存
	T1.F_BHL_cgzq, --固定提前期+固定提前期单位
	T1.F_BHL_zxbzl, --最小包装量
	T1.F_BHL_yclcthsl --原材料仓提货数量
into #demo
from #zero T1
left join (
	select
		FMATERIALID,
		sum(isnull(FMUSTQTY,0)) F_BHL_Total
	from #zero
	group by FMATERIALID
) T2 on T2.FMATERIALID = T1.FMATERIALID
where T1.FMATERIALGROUP like @MaterialGroup+'%'
and T1.F_BHL_NewNumber between @NumberBegin and @NumberEnd
and T1.F_BHL_Name between @NameBegin and @NameEnd
--处理字符串
declare @str nvarchar(255),@demo nvarchar(max);
select
	*
into #ZZZ
from #demo
delete #ZZZ
if @NumberM is null or @NumberM = ''
begin
	insert into #ZZZ(FCREATEDATE,FMATERIALID,F_BHL_OldNumber,FMATERIALGROUP,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,FMUSTQTY,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl)
	select FCREATEDATE,FMATERIALID,F_BHL_OldNumber,FMATERIALGROUP,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,FMUSTQTY,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl from #demo
end
else
begin
	set @strsql = ltrim(rtrim(@NumberM));
	while len(@strsql) <> ''
	begin
		SET @str = SUBSTRING(@strsql,0,CHARINDEX(',',@strsql)); --截取第一个
		insert into #ZZZ(FCREATEDATE,FMATERIALID,F_BHL_OldNumber,FMATERIALGROUP,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,FMUSTQTY,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl)
		select FCREATEDATE,FMATERIALID,F_BHL_OldNumber,FMATERIALGROUP,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,FMUSTQTY,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl from #demo
		where F_BHL_NewNumber = @str
		SET @strsql = SUBSTRING(@strsql,(CHARINDEX(',',@strsql)+1),len(@NumberM)) --截取剩余
	end
end
--行列转换、临时表、临时列
set @demo = '';
set @strsql = ltrim(rtrim(@filterString)); --删除字符串左右两边空格
while len(@strsql) <> ''
begin
	SET @str = SUBSTRING(@strsql,0,CHARINDEX('*',@strsql)); --截取第一个
	set @demo = @demo + @str + '''';
	SET @strsql = SUBSTRING(@strsql,(CHARINDEX('*',@strsql)+1),len(@filterString)) --截取剩余
end
while len(@filterString) > len(@demo)
begin
	set @filterString = left(@demo,len(ltrim(rtrim(@filterString)))-1)
END
set @strsql = 'IF EXISTS (SELECT * FROM dbo.SysObjects WHERE ID = object_id(N''[' + @FtableName + ']'') AND OBJECTPROPERTY(ID,''IsTable'') = 1) drop table ' + @FtableName + ';'
exec(@strsql)
set @strsql = 'select F_BHL_OldNumber,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl'
select @strsql = @strsql + ',sum(case FCREATEDATE when ''' + FCREATEDATE + ''' then FMUSTQTY else 0 end) as [' + FCREATEDATE +']'
from (select distinct FCREATEDATE from #zzz) T
select @strsql = @strsql + ','+@FCol+' into '+@FtableName+' from #zzz where 0=0 '+@filterString+' group by F_BHL_OldNumber,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl'
exec(@strsql)
drop table #BOM
drop table #zero
drop table #demo
drop table #zzz
end
