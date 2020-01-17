exec sp_executesql N' SET FMTONLY OFF; SET NO_BROWSETABLE ON;SELECT T_BF_InstanceSnap.FCId, T_BF_InstanceSnap.FXmlBody, T_BF_InstanceSnap.FCreateTime, T_BF_InstanceSnap.FModifyTime, T_BF_InstanceSnap.FFVersion FROM T_BF_InstanceSnap WHERE T_BF_InstanceSnap.FCId = @PKValue;
SELECT t_BF_Snap_Row.FRowId, t_BF_Snap_Row.FBillInfoId, t_BF_Snap_Row.FSId, t_BF_Snap_Row.FTId, t_BF_Snap_Row.FAmounts, t_BF_Snap_Row.FCId FROM t_BF_Snap_Row INNER JOIN T_BF_InstanceSnap ON t_BF_Snap_Row.FCId = T_BF_InstanceSnap.FCId WHERE T_BF_InstanceSnap.FCId = @PKValue;
SELECT t_BF_Snap_Rule.FRulePKId, t_BF_Snap_Rule.FRuleInfoId, t_BF_Snap_Rule.FCurOper, t_BF_Snap_Rule.FHisOper, t_BF_Snap_Rule.FRValueInfos, t_BF_Snap_Rule.FRowId FROM t_BF_Snap_Rule INNER JOIN t_BF_Snap_Row ON t_BF_Snap_Rule.FRowId = t_BF_Snap_Row.FRowId INNER JOIN T_BF_InstanceSnap ON t_BF_Snap_Row.FCId = T_BF_InstanceSnap.FCId WHERE T_BF_InstanceSnap.FCId = @PKValue;
SELECT t_BF_Snap_RValue.FSRsId, t_BF_Snap_RValue.FRValue, t_BF_Snap_RValue.FSTableName, t_BF_Snap_RValue.FSId, t_BF_Snap_RValue.FRulePKId FROM t_BF_Snap_RValue INNER JOIN t_BF_Snap_Rule ON t_BF_Snap_RValue.FRulePKId = t_BF_Snap_Rule.FRulePKId INNER JOIN t_BF_Snap_Row ON t_BF_Snap_Rule.FRowId = t_BF_Snap_Row.FRowId INNER JOIN T_BF_InstanceSnap ON t_BF_Snap_Row.FCId = T_BF_InstanceSnap.FCId WHERE T_BF_InstanceSnap.FCId = @PKValue;',N'@PKValue nvarchar(39)',@PKValue=N'AP_PAYBILL,FPAYBILLSRCENTRY_Link,103639'






exec sp_executesql N'DELETE FROM t_BF_SnapBU_Row WHERE FCId = @FCID',N'@FCID varchar(39)',@FCID='AP_PAYBILL,FPAYBILLSRCENTRY_Link,103639'

exec sp_executesql N'INSERT INTO t_BF_InstanceSnap (FCID, FXMLBody, FCreateTime, FModifyTime, FFVersion) SELECT FCID, FXMLBody, FCreateTime, @CurrentTime fmodifytime, FFVersion FROM t_BF_SnapBackUp WHERE FCId = @FCID',N'@CurrentTime datetime,@FCID varchar(39)',@CurrentTime='2019-11-18 17:39:45.663',@FCID='AP_PAYBILL,FPAYBILLSRCENTRY_Link,103639'


SELECT A.FBILLNO FROM T_AP_REFUNDBILL A INNER JOIN T_AP_REFUNDBILLSRCENTRY B ON A.FID = B.FID WHERE ((B.FSOURCETYPE = 'AP_PAYBILL' AND B.FSRCBILLID = 103639) AND A.FCANCELSTATUS = 'A')




declare @p3 xml
set 
@p3=convert(xml,N'<Sheet><Rows><Row><Id><Id><Tbl>T_AP_PAYBILLSRCENTRY</Tbl><EId>104857</EId></Id></Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><FId/><SAmounts><SAmount><SFld>FAPPLYAMOUNTFOR</SFld><TFld>FREALPAYAMOUNT_S</TFld><Val>8941.7000000000</Val></SAmount></SAmounts><WRules><WRule><Id>13e11b10-d290-478e-a07b-ffd803ba9f06</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>CN_PAYAPPLY</SForm><SFld>FWritePclAmount</SFld><Op>Save</Op><TFld/><SRs><WSRow><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId></WSRow></SRs></WRule><WRule><Id>4b8c133f-07ea-4533-aef4-c129f4383274</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>CN_PAYAPPLY</SForm><SFld>FRELATEPAYQTY</SFld><Op>Save</Op><TFld/><SRs><WSRow><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId></WSRow></SRs></WRule><WRule><Id>AP_PayableToPayByApply</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>AP_Payable</SForm><SFld>FPAYREAPPLYAMT</SFld><Op>Save</Op><TFld>FREALPAYAMOUNT_S</TFld><SRs><WSRow><SId><Id><Tbl>T_AP_PAYABLEPLAN</Tbl><EId>107754</EId></Id></SId><Val>8941.7000000000</Val></WSRow></SRs><HOp>Save</HOp></WRule><WRule><Id>AP_PayableToPayWB</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>AP_Payable</SForm><SFld>FRELATEHADPAYAMOUNT_P</SFld><Op>Save</Op><TFld>FREALPAYAMOUNT_S</TFld><SRs><WSRow><SId><Id><Tbl>T_AP_PAYABLEPLAN</Tbl><EId>107754</EId></Id></SId><Val>8941.7000000000</Val></WSRow></SRs><HOp>Save</HOp></WRule><WRule><Id>AP_PAYBILLToCN_PAYAPPLY</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>CN_PAYAPPLY</SForm><SFld>FUnpaidAmount</SFld><Op>Save</Op><WT>1</WT><TFld>FREALPAYAMOUNT_S</TFld><SRs><WSRow><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><Val>8941.7000000000</Val></WSRow></SRs><HOp>Save</HOp></WRule><WRule><Id>c9b69717-0833-464e-9581-b8c1225785c6</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>AP_Payable</SForm><SFld>FRELATEHADPAYQTY</SFld><Op>Save</Op><TFld/><SRs><WSRow><SId><Id><Tbl>T_AP_PAYABLEPLAN</Tbl><EId>107754</EId></Id></SId></WSRow></SRs></WRule><WRule><Id>c43b2384-d965-4903-9744-2ebafc707a52</Id><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><SForm>CN_PAYAPPLY</SForm><SFld>FRELATEPAYAMOUNT</SFld><Op>Save</Op><TFld>FREALPAYAMOUNT_S</TFld><SRs><WSRow><SId><Id><Tbl>T_CN_PAYAPPLYENTRY</Tbl><EId>109535</EId></Id></SId><Val>8941.7000000000</Val></WSRow></SRs><HOp>Save</HOp></WRule></WRules></Row></Rows><Id>AP_PAYBILL,FPAYBILLSRCENTRY_Link,103639</Id></Sheet>')
exec sp_executesql N'UPDATE t_BF_SnapBackUp SET FXmlBody = @FXmlBody, FXmlZip = @FXmlZip, FZipType = @FZipType WHERE FCId = @OID',N'@FXmlBody xml,@FXmlZip nvarchar(1),@FZipType nchar(1),@OID nvarchar(39)',@FXmlBody=@p3,@FXmlZip=N' ',@FZipType=N'0',@OID=N'AP_PAYBILL,FPAYBILLSRCENTRY_Link,103639'




