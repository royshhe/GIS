USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IRACS_GET_EFT_Header]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










/*
Procedure NAME: IRACS_GET_EFT_Header
PURPOSE: 
AUTHOR: Roy He
DATE CREATED: Dec 5, 2006
CALLED BY: AM
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[IRACS_GET_EFT_Header] --'2007-10-01','2007-10-01'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS

-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime,
		@SourcePoolCode varchar(10)	

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

SELECT    @SourcePoolCode=  dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'IRACS') AND (dbo.SystemSettingValues.ValueName = 'SystemID')


SELECT  @SourcePoolCode SRCPOLL,   CounterCode AS HOPLOC, Contract_Number AS HRANUM, Transaction_Date, RBR_Date, 'C' TranType
FROM         dbo.IRACS_EFT_Header_vw
where RBR_Date between @startDate and @endDate --and Contract_Number=1067800
order by RBR_Date

GO
