USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AM_GET_EFT_Detail_By_FileNumber]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Procedure NAME: AM_GET_EFT_Detail_By_FileNumber
PURPOSE: 
AUTHOR: Roy He
DATE CREATED: Dec 5, 2006
CALLED BY: AM
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[AM_GET_EFT_Detail_By_FileNumber] --'2006-12-01','2006-12-19'
	@fileCreationNumber int
AS



-- convert strings to datetime
/*DECLARE 	@startDate datetime,
		@endDate datetime,
		@i int	


SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

*/

DECLARE  		@SponsorCode varchar(4)

SELECT    @SponsorCode=    dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AMRPEFT') AND (dbo.SystemSettingValues.ValueName = 'SponsorNumber')


-- Base Offer
SELECT  
	'TD'+ 
	SPACE(15)+
	CONVERT(VARCHAR(11),Card_Number)+
    '0000000000000'+Invoice_Number+ 
   @SponsorCode+
    --'000000'+Base_Offer_Code+	
    Base_Offer_Code+SPACE(8-Len(Base_Offer_Code))	+
	Store_Number+ 
    SPACE(9)+
	SUBSTRING(CONVERT(varchar(10),(ABS(Standard_Mile_Points) +1000000000)),2,8)+
    (Case When Standard_Mile_Points>0 Then
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(10),(ABS(Standard_Mile_Points) +1000000000)),1) And Field_Value_Sign='+')
             Else
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(10),(ABS(Standard_Mile_Points) +1000000000)),1) And Field_Value_Sign='-')
    End)	+
	SPACE(18)+	
	RIGHT(CONVERT(varchar(5), YEAR(RBR_Date)), 4)+
	RIGHT(CONVERT(varchar(3), MONTH(RBR_Date)+100),2) +
	RIGHT(CONVERT(varchar(3), DAY(RBR_Date)+100),2)+
    '001'+         -- Offer Occurrence
    '0000000'+   -- Record Sequence
    (Case When Payment_Type='1' Then 'CASH'
			  When Payment_Type='2' Then 'DEBT'
			  When Payment_Type='3' Then 'CRED'
              ELSE 'MIXD'
    END)+SPACE(4)+
	Entry_Mode+ 
   	SUBSTRING(CONVERT(Varchar(6), CONVERT(INT, ABS(Sales_Amount) +100000)) ,2,4)+
	(Case When Sales_Amount>0 Then
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(Varchar(6), CONVERT(INT, ABS(Sales_Amount) +100000)),1) And Field_Value_Sign='+')
             Else
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(Varchar(6), CONVERT(INT, ABS(Sales_Amount) +100000)),1)  And Field_Value_Sign='-')
    End)+
	 SPACE(118)  as Detail_Record
	 
FROM         dbo.Air_Miles_EFT_Detail
WHERE File_Creation_number=@fileCreationNumber

Union
-- Bonus Offer
SELECT  
	'TD'+ 
	SPACE(15)+
	CONVERT(VARCHAR(11),Card_Number)+
    '0000000000000'+Invoice_Number+ 
   @SponsorCode+
    Bonus_Offer_Code+SPACE(8-Len(Bonus_Offer_Code))	+
	Store_Number+ 
    SPACE(9)+
	SUBSTRING(CONVERT(varchar(10),(ABS(Bonus_Miles) +1000000000)),2,8)+
    (Case When Bonus_Miles>0 Then
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(10),(ABS(Bonus_Miles) +1000000000)),1) And Field_Value_Sign='+')
             Else
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(varchar(10),(ABS(Bonus_Miles) +1000000000)),1) And Field_Value_Sign='-')
    End)	+
	SPACE(18)+	
	RIGHT(CONVERT(varchar(5), YEAR(RBR_Date)), 4)+
	RIGHT(CONVERT(varchar(3), MONTH(RBR_Date)+100),2) +
	RIGHT(CONVERT(varchar(3), DAY(RBR_Date)+100),2)+
    '001'+         -- Offer Occurrence
    '0000000'+   -- Record Sequence
    (Case When Payment_Type='1' Then 'CASH'
			  When Payment_Type='2' Then 'DEBT'
			  When Payment_Type='3' Then 'CRED'
              ELSE 'MIXD'
    END)+SPACE(4)+
	Entry_Mode+ 
   	SUBSTRING(CONVERT(Varchar(6), CONVERT(INT, ABS(Sales_Amount) +100000)) ,2,4)+
	(Case When Sales_Amount>0 Then
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(Varchar(6), CONVERT(INT, ABS(Sales_Amount) +100000)),1) And Field_Value_Sign='+')
             Else
             (Select Terminal_Value from Signed_Value_Conversion where Unit_Value =RIGHT(CONVERT(Varchar(6), CONVERT(INT, ABS(Sales_Amount) +100000)),1)  And Field_Value_Sign='-')
    End)+
	 SPACE(118)  as Detail_Record
	 
FROM         dbo.Air_Miles_EFT_Detail
GO
