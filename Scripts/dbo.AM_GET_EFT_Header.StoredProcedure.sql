USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AM_GET_EFT_Header]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Procedure NAME: AM_GET_EFT_Header
PURPOSE: 
AUTHOR: Roy He
DATE CREATED: Dec 5, 2006
CALLED BY: AM
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[AM_GET_EFT_Header]  -- '2010-08-08','2010-08-09'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime,
		@ProviderCode varchar(4),
        @TotalBaseOffers Int,
        @TotalBonusOffers Int,
        @TotalMilesIssued bigint,
		@SignedDigit Char(1),
		@TotalDetail int



SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
				@endDate	= CONVERT(datetime, @paramEndDate)	

SELECT @TotalBaseOffers=count(*)   FROM dbo.Air_Miles_EFT_Detail
Where Standard_Mile_Points<>0 and RBR_Date BETWEEN @startDate and  @endDate
          	
SELECT @TotalBonusOffers= count(*) from Air_Miles_EFT_Detail 
Where Bonus_Miles<>0		and RBR_Date BETWEEN @startDate and  @endDate

SELECT @TotalDetail=@TotalBaseOffers+@TotalBonusOffers

SELECT @TotalMilesIssued=Sum(Standard_Mile_Points) +Sum(Bonus_Miles)  FROM dbo.Air_Miles_EFT_Detail
Where RBR_Date BETWEEN @startDate and  @endDate




SELECT    @ProviderCode=    dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AMRPEFT') AND (dbo.SystemSettingValues.ValueName = 'ProviderCode')



SELECT File_Creation_Number,@ProviderCode+Right(convert(varchar(5),(File_Creation_Number +10000)),4) + '.T' as File_Name,    
	   'TH'+SPACE(6)+ @ProviderCode+Right(convert(varchar(7),(File_Creation_Number +1000000)),6)+--File_CreatetionDate
		RIGHT(CONVERT(varchar(5), YEAR(File_CreatetionDate)), 4)+
		RIGHT(CONVERT(varchar(3), MONTH(File_CreatetionDate)+100),2) +
		RIGHT(CONVERT(varchar(3), DAY(File_CreatetionDate)+100),2)+
	    RIGHT(CONVERT(varchar(3),  datepart(hh, File_CreatetionDate)+100),2)+
		RIGHT(CONVERT(varchar(3),  datepart(mi, File_CreatetionDate)+100),2)	+
		RIGHT(CONVERT(varchar(3),  datepart(ss, File_CreatetionDate)+100),2)	+
		RIGHT(CONVERT(varchar(9),(@TotalDetail +100000000)),8)+
		SUBSTRING(CONVERT(varchar(14),(ABS(@TotalMilesIssued) +10000000000000)),2,12)+
        (Case When @TotalMilesIssued>0 Then
                 (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(14),(ABS(@TotalMilesIssued) +10000000000000)),1) And Field_Value_Sign='+')
                 Else
                 (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(14),(ABS(@TotalMilesIssued) +10000000000000)),1) And Field_Value_Sign='-')
        End)+SPACE(197)
         
as Header_Record  


FROM         dbo.Air_Miles_EFT_Header
where Starting_RBR_Date=@startDate and  Ending_RBR_Date=@endDate

GO
