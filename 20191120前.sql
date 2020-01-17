USE [AIS20190719142428]
GO

/****** Object:  StoredProcedure [dbo].[JY_Drs_BHL_Subcode]    Script Date: 2019/11/20 10:56:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[JY_Drs_BHL_Subcode]
	@MaterialGroup nvarchar(255), --���Ϸ���
	@NumberBegin nvarchar(255), --��ʼ���ϱ���
	@NumberEnd nvarchar(255), --�������ϱ���
	@NameBegin nvarchar(255), --��ʼ��������
	@NameEnd nvarchar(255), --������������
	@DateBegin datetime, --��ʼ����
	@DateEnd datetime, --��������
	@NumberM nvarchar(max), --���ϱ���߼�����
	@filterString nvarchar(max), --����
	@ORG nvarchar(max), --��֯����
	@FtableName nvarchar(255), --��ʱ��
	@FCol nvarchar(255) --��ʱ��
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
--չ��BOM
select
	LV = 1, --�㼶
	DealFlg = 0, --�Ƿ�չ��
	T1.CREATEDATE,
	T1.FCREATEDATE, --��������
	T2.FMATERIALID, --�������ϱ���
	T2.FBOMID, --BOM�汾
	sum(isnull(T2.FMUSTQTY,0)) FMUSTQTY --Ӧ������
into #BOM
from (
	select
		T1.FID, --��������
		T2.FEntryID, --��¼����
		T1.FCREATEDATE CREATEDATE,
		left(convert(varchar(23),T1.FCREATEDATE,121),4)+'��'+substring(convert(varchar(23),T1.FCREATEDATE,121),6,2)+'��' FCREATEDATE
	from T_PRD_MO T1 --��������
	left join T_PRD_MOENTRY T2 on T2.FID = T1.FID --��ϸ
	left join T_PRD_MOENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
	where T3.FCLOSETYPE <> 'C' --�᰸���ͣ�<>ǿ�ƽ᰸
	and (left(convert(varchar(23),T1.FCREATEDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --��������
) T1
inner join (
	select
		T1.FID, --��������
		T2.FEntryID, --��¼����
		T1.FMOID, --������������
		T1.FMOENTRYID, --����������¼����
		T2.FMATERIALID, --�������ϱ���
		T2.FBOMID, --BOM�汾
		case
		when T2.FUNITID = T5.FSTOREUNITID then isnull(T2.FMUSTQTY,0)
		when T6.FCONVERTDENOMINATOR is not null and T6.FCONVERTNUMERATOR is not null then isnull(T2.FMUSTQTY,0)*T6.FCONVERTDENOMINATOR/T6.FCONVERTNUMERATOR
		else isnull(T2.FMUSTQTY,0)
		end FMUSTQTY --Ӧ������
	from T_PRD_PPBOM T1 --���������嵥
	left join T_PRD_PPBOMENTRY T2 on T2.FID = T1.FID --������ϸ
	left join T_PRD_PPBOMENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
	left join T_ORG_Organizations T4 on T4.FORGID = T1.FPRDORGID --��֯����
	left join t_BD_MaterialStock T5 on T5.FMATERIALID = T2.FMATERIALID --����_���
	left join (
		select
			FDESTUNITID, --Ŀ�굥λ
			FCURRENTUNITID, --��ǰ��λ
			FCONVERTDENOMINATOR, --�������
			FCONVERTNUMERATOR --�����ĸ
		from T_BD_UNITCONVERTRATE
		union
		select
			FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
			FDESTUNITID FCURRENTUNITID, --��ǰ��λ
			FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
			FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
		from T_BD_UNITCONVERTRATE
	) T6 on T6.FDESTUNITID = T2.FUNITID and T6.FCURRENTUNITID = T5.FSTOREUNITID --������λ_ת���ʣ�Ŀ�굥λ=���λ����ǰ��λ=��浥λ��Ŀ�굥λ*�����ĸ/������� = ��ǰ��λ
	where T4.FNUMBER = @ORG --��֯����
) T2 on T2.FMOID = T1.FID and T2.FMOENTRYID = T1.FEntryID
group by T1.CREATEDATE,T1.FCREATEDATE,T2.FMATERIALID,T2.FBOMID
--�����嵥
select
	T1.FID, --��������
	T2.FEntryID, --��¼����
	T1.FMATERIALID Parentcode, --�������ϱ���
	T2.FMATERIALID, --�������ϱ���
	T2.FBOMID, --����BOM�汾
	T2.FNUMERATOR, --����:����
	T2.FDENOMINATOR --����:��ĸ
into #BOM1
from T_ENG_BOM T1 --�����嵥
left join T_ENG_BOMCHILD T2 on T2.FID = T1.FID --������ϸ
left join t_BD_MaterialBase T3 on T3.FMATERIALID = T1.FMATERIALID --����_����
left join T_ORG_Organizations T4 on T4.FORGID = T1.FUSEORGID --��֯����
where T1.FDOCUMENTSTATUS = 'C' --����״̬�������
and T3.FERPCLSID = 3 --�������ԣ�ί��
and T4.FNUMBER = @ORG --��֯����
select
	T1.PARENTCODE, --�������ϱ���
	T2.FID, --��������
	T2.FMATERIALID, --�������ϱ���
	T2.FBOMID, --����BOM�汾
	T2.FNUMERATOR, --����:����
	T2.FDENOMINATOR, --����:��ĸ
	T2.FEXPIREDATE --ʧЧ����
into #BOM2
from (
	SELECT
		T1.FMATERIALID PARENTCODE, --�������ϱ���
		MAX(T1.FAPPROVEDATE) FAPPROVEDATE --�������
	FROM T_ENG_BOM T1 --�����嵥
	LEFT JOIN T_ENG_BOMCHILD T2 ON T2.FID = T1.FID --������ϸ
	LEFT JOIN T_BD_MATERIALBASE T3 ON T3.FMATERIALID = T1.FMATERIALID --����_����
	left join T_ORG_Organizations T4 on T4.FORGID = T1.FUSEORGID --��֯����
	WHERE T1.FDOCUMENTSTATUS = 'C' --����״̬�������
	AND T1.FFORBIDSTATUS = 'A' --����״̬����
	AND T3.FERPCLSID = 3 --�������ԣ�ί��
	and T4.FNUMBER = @ORG --��֯����
	GROUP BY T1.FMATERIALID
) T1
inner join (
	SELECT
		T1.FID, --��������
		T2.FENTRYID, --��¼����
		T1.FMATERIALID PARENTCODE, --�������ϱ���
		T2.FMATERIALID, --�������ϱ���
		T2.FBOMID, --����BOM�汾
		T2.FNUMERATOR, --����:����
		T2.FDENOMINATOR --����:��ĸ
		,T1.FAPPROVEDATE --�������
		,T2.FEXPIREDATE --ʧЧ����
	FROM T_ENG_BOM T1 --�����嵥
	LEFT JOIN T_ENG_BOMCHILD T2 ON T2.FID = T1.FID --������ϸ
	LEFT JOIN T_BD_MATERIALBASE T3 ON T3.FMATERIALID = T1.FMATERIALID --����_����
	left join T_ORG_Organizations T4 on T4.FORGID = T1.FUSEORGID --��֯����
	WHERE T1.FDOCUMENTSTATUS = 'C' --����״̬�������
	AND T1.FFORBIDSTATUS = 'A' --����״̬����
	AND T3.FERPCLSID = 3 --�������ԣ�ί��
	and T4.FNUMBER = @ORG --��֯����
) T2 on T2.PARENTCODE = T1.PARENTCODE and T2.FAPPROVEDATE = T1.FAPPROVEDATE
--ѭ��
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
--ȡ��
select
	T0.FCREATEDATE, --��������
	T0.FMATERIALID, --��������
	T2.FOLDNUMBER F_BHL_OldNumber, --�����ϱ���
	T2.FMATERIALGROUP, --��������
	T2.GROUPNAME F_BHL_MaterialGroup, --���Ϸ���
	T2.FNUMBER F_BHL_NewNumber, --���ϱ���
	T2.FNAME F_BHL_Name, --��������
	T2.FSPECIFICATION F_BHL_Specification, --����ͺ�
	T0.FMUSTQTY, --Ӧ������
	isnull(T1F1.FNOPICKEDQTY,0)+isnull(T1F2.FNOPICKEDQTY,0) F_BHL_ddywlsl, --δ������
	T3.FBASEQTY F_BHL_yclcjskcsl, --ԭ���ϲּ�ʱ�������
	T4.FBASEQTY F_BHL_gyscjskcsl, --��Ӧ�ּ̲�ʱ�������
	isnull(T5.FREMAINQTY,0)+isnull(T6.FREMAINSTOCKINQTY,0)+isnull(T7.FQTY,0) F_BHL_whsl, --δ������
	isnull(T3.FBASEQTY,0)+isnull(T4.FBASEQTY,0)+isnull(T5.FREMAINQTY,0)+isnull(T6.FREMAINSTOCKINQTY,0)+isnull(T7.FQTY,0)-isnull(T1F1.FNOPICKEDQTY,0)-isnull(T1F2.FNOPICKEDQTY,0) F_BHL_sysl, --ʣ������
	T2.FSAFESTOCK F_BHL_aqkc, --��ȫ���
	T2.FIXLEADTIME F_BHL_cgzq, --�̶���ǰ��+�̶���ǰ�ڵ�λ
	T2.FINCREASEQTY F_BHL_zxbzl, --��С��װ��
	case
	when isnull(T2.FSAFESTOCK,0)-isnull(T3.FBASEQTY,0)>0 then isnull(T2.FSAFESTOCK,0)-isnull(T3.FBASEQTY,0)
	else null
	end F_BHL_yclcthsl --ԭ���ϲ��������
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
		T2.FMATERIALID, --�������ϱ���
		sum(isnull(T2.FNOPICKEDQTY,0)) FNOPICKEDQTY --δ������
	from (
		select
			T1.FID, --��������
			T2.FEntryID, --��¼����
			T1.FCREATEDATE CREATEDATE, --��������
			left(convert(varchar(23),T1.FCREATEDATE,121),4)+'��'+substring(convert(varchar(23),T1.FCREATEDATE,121),6,2)+'��' FCREATEDATE --��������
		from T_SUB_REQORDER T1 --ί�ⶩ��_����ͷ
		left join T_SUB_REQORDERENTRY T2 on T2.FID = T1.FID --ί�ⶩ��_��ϸ
		left join T_SUB_REQORDERENTRY_A T3 on T3.FENTRYID = T2.FENTRYID --ί�ⶩ��_��ϸ_A
		where T2.FSTATUS not in (6,7) --ҵ��״̬��<>�᰸,<>����
		and T3.FCLOSETYPE <> 'C' --�᰸���ͣ�<>ǿ�ƽ᰸
		and (left(convert(varchar(23),T1.FCREATEDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --��������
	) T1
	inner join (
		select
			T1.FID, --��������
			T2.FEntryID, --��¼����
			T1.FSUBREQID, --ί�ⶩ������
			T1.FSUBREQENTRYID, --ί�ⶩ����¼����
			T2.FMATERIALID, --�������ϱ���
			T2.FBOMID, --BOM�汾
			case
			when T2.FUNITID = T5.FSTOREUNITID then isnull(T3.FNOPICKEDQTY,0)
			when T6.FCONVERTDENOMINATOR is not null and T6.FCONVERTNUMERATOR is not null then isnull(T3.FNOPICKEDQTY,0)*T6.FCONVERTDENOMINATOR/T6.FCONVERTNUMERATOR
			else isnull(T3.FNOPICKEDQTY,0)
			end FNOPICKEDQTY --δ������
		from T_SUB_PPBOM T1 --ί�������嵥_����ͷ
		left join T_SUB_PPBOMENTRY T2 on T2.FID = T1.FID --������ϸ
		left join T_SUB_PPBOMENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
		left join T_ORG_Organizations T4 on T4.FORGID = T1.FSUBORGID --��֯����
		left join t_BD_MaterialStock T5 on T5.FMATERIALID = T2.FMATERIALID --����_���
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T6 on T6.FDESTUNITID = T2.FUNITID and T6.FCURRENTUNITID = T5.FSTOREUNITID --������λ_ת���ʣ�Ŀ�굥λ=���λ����ǰ��λ=��浥λ��Ŀ�굥λ*�����ĸ/������� = ��ǰ��λ
		where T4.FNUMBER = @ORG --��֯����
	) T2 on T2.FSUBREQID = T1.FID and T2.FSUBREQENTRYID = T1.FEntryID
	group by T2.FMATERIALID
) T1F1 on T1F1.FMATERIALID = T0.FMATERIALID
left join (
	select
		T2.FMATERIALID, --�������ϱ���
		sum(isnull(T2.FNOPICKEDQTY,0)) FNOPICKEDQTY --δ������
	from (
		select
			T1.FID, --��������
			T2.FEntryID, --��¼����
			T1.FCREATEDATE CREATEDATE,
			left(convert(varchar(23),T1.FCREATEDATE,121),4)+'��'+substring(convert(varchar(23),T1.FCREATEDATE,121),6,2)+'��' FCREATEDATE
		from T_PRD_MO T1 --��������
		left join T_PRD_MOENTRY T2 on T2.FID = T1.FID --��ϸ
		left join T_PRD_MOENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
		left join T_PRD_MOENTRY_A T4 on T4.FENTRYID = T2.FENTRYID
		where T4.FSTATUS not in (6,7) --ҵ��״̬��<>�᰸,<>����
		and T3.FCLOSETYPE <> 'C' --�᰸���ͣ�<>ǿ�ƽ᰸
		and (left(convert(varchar(23),T1.FCREATEDATE,121),10) between left(convert(varchar(23),@DateBegin,121),10) and left(convert(varchar(23),@DateEnd,121),10)) --��������
	) T1
	inner join (
		select
			T1.FID, --��������
			T2.FEntryID, --��¼����
			T1.FMOID, --������������
			T1.FMOENTRYID, --����������¼����
			T2.FMATERIALID, --�������ϱ���
			T2.FBOMID, --BOM�汾
			case
			when T2.FUNITID = T5.FSTOREUNITID then isnull(T3.FNOPICKEDQTY,0)
			when T6.FCONVERTDENOMINATOR is not null and T6.FCONVERTNUMERATOR is not null then isnull(T3.FNOPICKEDQTY,0)*T6.FCONVERTDENOMINATOR/T6.FCONVERTNUMERATOR
			else isnull(T3.FNOPICKEDQTY,0)
			end FNOPICKEDQTY --δ������
		from T_PRD_PPBOM T1 --���������嵥
		left join T_PRD_PPBOMENTRY T2 on T2.FID = T1.FID --������ϸ
		left join T_PRD_PPBOMENTRY_Q T3 on T3.FENTRYID = T2.FENTRYID
		left join T_ORG_Organizations T4 on T4.FORGID = T1.FPRDORGID --��֯����
		left join t_BD_MaterialStock T5 on T5.FMATERIALID = T2.FMATERIALID --����_���
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T6 on T6.FDESTUNITID = T2.FUNITID and T6.FCURRENTUNITID = T5.FSTOREUNITID --������λ_ת���ʣ�Ŀ�굥λ=���λ����ǰ��λ=��浥λ��Ŀ�굥λ*�����ĸ/������� = ��ǰ��λ
		where T4.FNUMBER = @ORG --��֯����
	) T2 on T2.FMOID = T1.FID and T2.FMOENTRYID = T1.FEntryID
	group by T2.FMATERIALID
) T1F2 on T1F2.FMATERIALID = T0.FMATERIALID
left join (
	select
		T1.FMATERIALID, --��������
		T1.FOLDNUMBER, --�����ϱ���
		T1.FMATERIALGROUP, --��������
		T4.FNAME GROUPNAME, --���Ϸ���
		T1.FNUMBER, --���ϱ���
		T2.FNAME, --��������
		T2.FSPECIFICATION, --����ͺ�
		T5.FSAFESTOCK, --��ȫ���
		cast(T6.FFIXLEADTIME as nvarchar(255))+cast(T8.FCAPTION as nvarchar(255)) FIXLEADTIME,--�̶���ǰ��+�̶���ǰ�ڵ�λ
		T6.FINCREASEQTY, --��С��װ��
		T9.FERPCLSID --�������ԣ�3(ί��)
	from T_BD_MATERIAL T1 --����
	left join T_BD_MATERIAL_L T2 on T2.FMATERIALID = T1.FMATERIALID and T2.FLOCALEID = 2052
	left join T_BD_MATERIALGROUP T3 on T3.FID = T1.FMATERIALGROUP --���ݷ���
	left join T_BD_MATERIALGROUP_L T4 on T4.FID = T3.FID and T4.FLOCALEID = 2052
	left join t_BD_MaterialStock T5 on T5.FMATERIALID = T1.FMATERIALID --���
	left join t_BD_MaterialPlan T6 on T6.FMATERIALID = T1.FMATERIALID --�ƻ�
	left join T_META_FORMENUMITEM T7 on T7.FVALUE = T6.FFIXLEADTIMETYPE and T7.FID = '3948b044-f8df-4ff0-927d-295eb4f478fc' --ö��
	left join T_META_FORMENUMITEM_L T8 on T8.FENUMID = T7.FENUMID and T8.FLOCALEID = 2052
	left join t_BD_MaterialBase T9 on T9.FMATERIALID = T1.FMATERIALID --����_����
) T2 on T2.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --���ϱ���
		sum(isnull(FBASEQTY,0)) FBASEQTY --ʣ������
	from (
		select
			T1.FMATERIALID, --���ϱ���
			case
			when T1.FBASEUNITID = T1.FSTOCKUNITID then isnull(T1.FBASEQTY,0)
			when T4.FCONVERTDENOMINATOR is not null and T4.FCONVERTNUMERATOR is not null
			then isnull(T1.FBASEQTY,0)*T4.FCONVERTDENOMINATOR/T4.FCONVERTNUMERATOR --�����(������λ)*�����ĸ/������� = �����(����λ)
			else isnull(T1.FBASEQTY,0)
			end FBASEQTY --ʣ������
		from T_STK_INVENTORY T1 --��ʱ���
		left join t_BD_Stock T2 on T2.FSTOCKID = T1.FSTOCKID
		left join t_BD_Stock_L T3 on T3.FSTOCKID = T2.FSTOCKID and T3.FLOCALEID = 2052
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T4 on T4.FDESTUNITID = T1.FBASEUNITID and T4.FCURRENTUNITID = T1.FSTOCKUNITID --������λ_ת���ʣ�Ŀ�굥λ=������λ����ǰ��λ=�������λ
		where T3.FNAME = 'ԭ���ϲ�' --�ֿ����ƣ�ԭ���ϲ�
	) T
	group by T.FMATERIALID
) T3 on T3.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --���ϱ���
		sum(isnull(FBASEQTY,0)) FBASEQTY --ʣ������
	from (
		select
			T1.FMATERIALID, --���ϱ���
			case
			when T1.FBASEUNITID = T1.FSTOCKUNITID then isnull(T1.FBASEQTY,0)
			when T3.FCONVERTDENOMINATOR is not null and T3.FCONVERTNUMERATOR is not null
			then isnull(T1.FBASEQTY,0)*T3.FCONVERTDENOMINATOR/T3.FCONVERTNUMERATOR --�����(������λ)*�����ĸ/������� = �����(����λ)
			else isnull(T1.FBASEQTY,0)
			end FBASEQTY --ʣ������
		from T_STK_INVENTORY T1 --��ʱ���
		left join t_BD_Stock T2 on T2.FSTOCKID = T1.FSTOCKID
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T3 on T3.FDESTUNITID = T1.FBASEUNITID and T3.FCURRENTUNITID = T1.FSTOCKUNITID --������λ_ת���ʣ�Ŀ�굥λ=������λ����ǰ��λ=�������λ
		where T2.FSTOCKPROPERTY = 3 --�ֿ����ԣ���Ӧ�ֿ̲�
	) T
	group by T.FMATERIALID
) T4 on T4.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --���ϱ���
		sum(isnull(FREMAINQTY,0)) FREMAINQTY --ʣ������
	from (
		select
			T2.FMATERIALID, --���ϱ���
			case
			when T2.FUNITID = T4.FSTOREUNITID then isnull(T3.FREMAINQTY,0)
			when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then isnull(T3.FREMAINQTY,0)*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
			else isnull(T3.FREMAINQTY,0)
			end FREMAINQTY --ʣ������
		from T_PUR_Requisition T1 --�ɹ����뵥
		left join T_PUR_ReqEntry T2 on T2.FID = T1.FID --��ϸ��Ϣ
		left join T_PUR_REQENTRY_R T3 on T3.FENTRYID = T2.FENTRYID
		left join t_BD_MaterialStock T4 on T4.FMATERIALID = T2.FMATERIALID --����_���
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --������λ_ת���ʣ�Ŀ�굥λ=���뵥λ����ǰ��λ=��浥λ��Ŀ�굥λ*�����ĸ/������� = ��ǰ��λ
		where T1.FDOCUMENTSTATUS = 'C' --����״̬�������
		and T1.FCLOSESTATUS = 'A' --�ر�״̬��δ�ر�
		and T2.FMRPCLOSESTATUS = 'A' --ҵ��رգ�����
		and T2.FMRPTERMINATESTATUS = 'A' --ҵ����ֹ������
	) T
	group by T.FMATERIALID
) T5 on T5.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --���ϱ���
		sum(isnull(T.FREMAINSTOCKINQTY,0)) FREMAINSTOCKINQTY --ʣ���������
	from (
		select
			T2.FMATERIALID, --���ϱ���
			case
			when T2.FUNITID = T4.FSTOREUNITID then isnull(T3.FREMAINSTOCKINQTY,0)
			when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then isnull(T3.FREMAINSTOCKINQTY,0)*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
			else isnull(T3.FREMAINSTOCKINQTY,0)
			end FREMAINSTOCKINQTY --ʣ���������
		from t_PUR_POOrder T1 --�ɹ�����
		left join t_PUR_POOrderEntry T2 on T2.FID = T1.FID --��ϸ��Ϣ
		left join T_PUR_POORDERENTRY_R T3 on T3.FENTRYID = T2.FENTRYID
		left join t_BD_MaterialStock T4 on T4.FMATERIALID = T2.FMATERIALID --����_���
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --������λ_ת���ʣ�Ŀ�굥λ=�ɹ���λ����ǰ��λ=��浥λ��Ŀ�굥λ*�����ĸ/������� = ��ǰ��λ
		where T1.FDOCUMENTSTATUS <> 'Z' --����״̬��<>����
		and T1.FCLOSESTATUS = 'A' --�ر�״̬��δ�ر�
		and T1.FCANCELSTATUS = 'A' --����״̬����
		and T2.FMRPCLOSESTATUS = 'A' --ҵ��رգ�����
		and T2.FMRPTERMINATESTATUS = 'A' --ҵ����ֹ������
	) T
	group by T.FMATERIALID
) T6 on T6.FMATERIALID = T0.FMATERIALID
left join (
	select
		T.FMATERIALID, --���ϱ���
		sum(isnull(T.FQTY,0)) FQTY --����-�ɹ�ִ������
	from (
		select
			T2.FMATERIALID, --���ϱ���
			case
			when T2.FUNITID = T4.FSTOREUNITID then isnull(T2.FQTY,0)-isnull(T2.FPURQTY,0)
			when T5.FCONVERTDENOMINATOR is not null and T5.FCONVERTNUMERATOR is not null then (isnull(T2.FQTY,0)-isnull(T2.FPURQTY,0))*T5.FCONVERTDENOMINATOR/T5.FCONVERTNUMERATOR
			else isnull(T2.FQTY,0)-isnull(T2.FPURQTY,0)
			end FQTY --����-�ɹ�ִ������
		from T_SUB_REQORDER T1 --ί�ⶩ��
		left join T_SUB_REQORDERENTRY T2 on T2.FID = T1.FID --��ϸ
		left join T_SUB_REQORDERENTRY_A T3 on T3.FENTRYID = T2.FENTRYID
		left join t_BD_MaterialStock T4 on T4.FMATERIALID = T2.FMATERIALID --����_���
		left join (
			select
				FDESTUNITID, --Ŀ�굥λ
				FCURRENTUNITID, --��ǰ��λ
				FCONVERTDENOMINATOR, --�������
				FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
			union
			select
				FCURRENTUNITID FDESTUNITID, --Ŀ�굥λ
				FDESTUNITID FCURRENTUNITID, --��ǰ��λ
				FCONVERTNUMERATOR FCONVERTDENOMINATOR, --�������
				FCONVERTDENOMINATOR FCONVERTNUMERATOR --�����ĸ
			from T_BD_UNITCONVERTRATE
		) T5 on T5.FDESTUNITID = T2.FUNITID and T5.FCURRENTUNITID = T4.FSTOREUNITID --������λ_ת���ʣ�Ŀ�굥λ=��λ����ǰ��λ=��浥λ��Ŀ�굥λ*�����ĸ/������� = ��ǰ��λ
		where T1.FDOCUMENTSTATUS = 'C' --����״̬�������
		and T1.FCANCELSTATUS = 'A' --����״̬����
		and T2.FSTATUS not in (6,7) --ҵ��״̬��<>�᰸,<>����
		and T3.FCLOSETYPE <> 'C' --�᰸���ͣ�<>ǿ�ƽ᰸
		and isnull(T2.FPURQTY,0) <> isnull(T2.FQTY,0) --�ɹ�ִ������<>����
	) T
	group by T.FMATERIALID
) T7 on T7.FMATERIALID = T0.FMATERIALID
select
	T1.FCREATEDATE, --��������
	T1.FMATERIALID, --��������
	T1.F_BHL_OldNumber, --�����ϱ���
	T1.FMATERIALGROUP, --��������
	T1.F_BHL_MaterialGroup, --���Ϸ���
	T1.F_BHL_NewNumber, --���ϱ���
	T1.F_BHL_Name, --��������
	T1.F_BHL_Specification, --����ͺ�
	T1.FMUSTQTY, --Ӧ������
	T2.F_BHL_Total, --�ܼ�
	case
	when cast(cast(datediff(day,@DateBegin,@DateEnd) as decimal(18,2))/30 as decimal(18,2)) = 0 then cast(isnull(T2.F_BHL_Total,0) as decimal(18,2))
	else cast(isnull(T2.F_BHL_Total,0)/cast(cast(datediff(day,@DateBegin,@DateEnd) as decimal(18,2))/30 as decimal(18,2)) as decimal(18,2))
	end F_BHL_AverageDosage, --ƽ������
	T1.F_BHL_ddywlsl, --δ������
	T1.F_BHL_yclcjskcsl, --ԭ���ϲּ�ʱ�������
	T1.F_BHL_gyscjskcsl, --��Ӧ�ּ̲�ʱ�������
	T1.F_BHL_whsl, --δ������
	T1.F_BHL_sysl, --ʣ������
	T1.F_BHL_aqkc, --��ȫ���
	T1.F_BHL_cgzq, --�̶���ǰ��+�̶���ǰ�ڵ�λ
	T1.F_BHL_zxbzl, --��С��װ��
	T1.F_BHL_yclcthsl --ԭ���ϲ��������
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
--�����ַ���
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
		SET @str = SUBSTRING(@strsql,0,CHARINDEX(',',@strsql)); --��ȡ��һ��
		insert into #ZZZ(FCREATEDATE,FMATERIALID,F_BHL_OldNumber,FMATERIALGROUP,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,FMUSTQTY,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl)
		select FCREATEDATE,FMATERIALID,F_BHL_OldNumber,FMATERIALGROUP,F_BHL_MaterialGroup,F_BHL_NewNumber,F_BHL_Name,F_BHL_Specification,FMUSTQTY,F_BHL_Total,F_BHL_AverageDosage,F_BHL_ddywlsl,F_BHL_yclcjskcsl,F_BHL_gyscjskcsl,F_BHL_whsl,F_BHL_sysl,F_BHL_aqkc,F_BHL_cgzq,F_BHL_zxbzl,F_BHL_yclcthsl from #demo
		where F_BHL_NewNumber = @str
		SET @strsql = SUBSTRING(@strsql,(CHARINDEX(',',@strsql)+1),len(@NumberM)) --��ȡʣ��
	end
end
--����ת������ʱ����ʱ��
set @demo = '';
set @strsql = ltrim(rtrim(@filterString)); --ɾ���ַ����������߿ո�
while len(@strsql) <> ''
begin
	SET @str = SUBSTRING(@strsql,0,CHARINDEX('*',@strsql)); --��ȡ��һ��
	set @demo = @demo + @str + '''';
	SET @strsql = SUBSTRING(@strsql,(CHARINDEX('*',@strsql)+1),len(@filterString)) --��ȡʣ��
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
drop table #BOM1
drop table #BOM2
drop table #zero
drop table #demo
drop table #zzz
end
GO


