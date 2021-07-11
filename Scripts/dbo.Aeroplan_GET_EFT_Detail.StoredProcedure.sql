USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Aeroplan_GET_EFT_Detail]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Procedure NAME: Aeroplan_GET_EFT_Detail '2008-09-23', '2008-09-23'
PURPOSE: 
AUTHOR: Roy He
DATE CREATED: Feb 22, 2017
CALLED BY: AM
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[Aeroplan_GET_EFT_Detail]     --'2017-02-21','2017-02-21'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS

-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime,
		@SponsorCode varchar(4)


SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	


SELECT  
    Space(2)+
	Partner_code+ 
	'0'+
	Card_Number+
	Alliance_Location_Name+
	Invoice_Number+	 
	RIGHT(CONVERT(varchar(5), YEAR(RBR_Date)), 4)+
	RIGHT(CONVERT(varchar(3), MONTH(RBR_Date)+100),2) +
	RIGHT(CONVERT(varchar(3), DAY(RBR_Date)+100),2)+
	Space(10)+
	MPC+
	SUBSTRING(CONVERT(varchar(8),(ABS(Activity_Amount) +10000000)),2,6)+
    (Case When Activity_Amount>0 Then
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(10),(ABS(Activity_Amount) +1000000000)),1) And Field_Value_Sign='+')
             When Activity_Amount<0 Then
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(10),(ABS(Activity_Amount) +1000000000)),1) And Field_Value_Sign='-')
             Else '0'
    End)	+
    Source_Identifier+
    Space(22)
	 
	 as Detail_Record
	 
FROM         dbo.Aeroplan_EFT_Detail
where RBR_Date BETWEEN @startDate and  @endDate and Activity_Amount<>0

 
GO
