

select * from T_ENG_BOM where fnumber='3.CLW07E.027A2-BA8501-001_V1.0'--429609
select * from T_ENG_BOMCHILD where FID=429609

select * from T_ENG_BOMEXPANDHEAD where fid in (470416)

/*��һ�����鿴�����ĵ�ǰ����ֵ*/
DBCC CHECKIDENT('[Z_ENG_BOMEXPANDHEAD]', NORESEED)

/*�ڶ������鿴�������������ֵ*/
DECLARE @FID bigint
SELECT @FID=ISNULL(MAX(fid),100001)+1 FROM T_ENG_BOMEXPANDHEAD
SELECT @FID

/*����������������ֵ*/
DBCC CHECKIDENT('Z_ENG_BOMEXPANDHEAD', RESEED, @FID)

