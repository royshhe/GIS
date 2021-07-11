USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AM_Create_EFT_File_tmp]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[AM_Create_EFT_File_tmp]  --'08 jan 2007', '11 Apr 2007'
	@paramStartDate datetime = '15 April 1999',
	@paramEndDate datetime = '15 April 1999'
AS




	--Generate Air Miles EFT Files



Declare @dtToday datetime
Declare @File_Name varchar(13)
Declare @Transaction_Type_Header varchar(2)
Declare @Originator_ID varchar(10)
Declare @File_Creation_Number int

--Transaciton Detail
Declare @Transaction_Type_Detail varchar(2)
Declare @SponsorNumber varchar(2)
Declare @CustomerNumber varchar(4)
Declare @CompanyID varchar(25)




--Header
Select @dtToday=getdate()
Select @Transaction_Type_Header='00'

SELECT    @File_Name= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AirMilesEFT') AND (dbo.SystemSettingValues.ValueName = 'FileName')
SELECT    @Originator_ID= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AirMilesEFT') AND (dbo.SystemSettingValues.ValueName = 'OriginatorID')

 

Select @File_Creation_Number=100


--Detail
Select @Transaction_Type_Detail='65'

SELECT    @SponsorNumber= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AirMilesEFT') AND (dbo.SystemSettingValues.ValueName = 'SponsorNumber')
SELECT    @CustomerNumber= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AirMilesEFT') AND (dbo.SystemSettingValues.ValueName = 'CustomerNumber')
SELECT @CompanyID=Code from dbo.Lookup_Table
WHERE (dbo.Lookup_Table.Category = 'BudgetBC Company ') 


--Delete Air_Miles_EFT_Detail Where (RBR_Date >= @paramStartDate) and (RBR_Date < @paramEndDate+1) 
	
Insert into Air_Miles_EFT_Detail_tmp

SELECT 100 as File_Creation_Number,
	Right(convert(varchar(15),(dbo.Contract.Contract_Number +10000000)),7) AS Invoice_Number, 
        dbo.AM_Contract_TnM_vw.Business_Transaction_ID, 
	dbo.AM_Contract_TnM_vw.RBR_Date,
	@CustomerNumber as Customer_Number,  
	dbo.Location.StationNumber AS Store_Number, 
	'0001' as Terminla_Number,
	@Transaction_Type_Detail as Transaction_Type,
	dbo.Contract.FF_Member_Number as Card_Number, 
	(Case When dbo.AM_Contract_TnM_vw.TnM_Amount>=0 then '00'
	     Else '30'
        End) AS AMTM_Tran_Type, 	
	(Case when dbo.Contract.FF_Swiped=1 then 'S'
	     Else 'M'
	End) AS Entry_Mode,
 
        Right(CONVERT(varchar(3), DATEPART(hh, dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2) + Right(CONVERT(varchar(3), DATEPART(mi, dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2) AS Transaction_Time,				

		Right(CONVERT(varchar(3), DAY(dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2)	+ 
		RIGHT(CONVERT(varchar(3), MONTH(dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2) + 
		RIGHT(CONVERT(varchar(4), YEAR(dbo.AM_Contract_TnM_vw.Transaction_Date)), 2) 
	AS Transaction_Date,
	(Case when Payment_Type='Credit Card' then '3'
	     when Payment_Type='Cash' then '1'
	     Else '1'
	End) as Payment_Type,
	@SponsorNumber as Sponsor_Number,
	'01' AS Base_Offer_Code, 
	dbo.AM_Contract_TnM_vw.TnM_Amount AS Sales_Amount, 
	CONVERT(INT, dbo.AM_Contract_TnM_vw.TnM_Amount / 10) AS Mile_Points, 
        1 AS Multiply_Factor, 
	0 AS Multipler_Miles, 
	
	(Case 
	     When  dbo.Contract.Pick_Up_On<'2007-03-16' then '9813'
	     Else   '0000'
	End) AS BONUS_OFFER_CODE,
	
        (Case 
	     When  dbo.Contract.Pick_Up_On<'2007-03-16' then 1
	     Else   0
	End) AS Offer_Quantity,

	(Case 
	     When  dbo.Contract.Pick_Up_On<'2007-03-16' then CONVERT(INT, dbo.AM_Contract_TnM_vw.TnM_Amount / 10)*2
	     Else   0
	End) AS Bonus_Miles,

	2 AS Offer_Type




FROM         dbo.Contract 
	INNER JOIN dbo.Frequent_Flyer_Plan 
		ON dbo.Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID 
	INNER JOIN dbo.AM_Contract_TnM_vw 
		ON dbo.Contract.Contract_Number = dbo.AM_Contract_TnM_vw.Contract_Number 
	INNER JOIN dbo.Location 
		ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 
	LEFT OUTER JOIN dbo.Contract_Payment_Item 
		ON dbo.Contract.Contract_Number = dbo.Contract_Payment_Item.Contract_Number and Sequence=0

WHERE     (dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Air Miles') AND (dbo.AM_Contract_TnM_vw.Checkin_RBR_Date >= @paramStartDate) and (dbo.AM_Contract_TnM_vw.Checkin_RBR_Date < @paramEndDate+1) 
	   and dbo.Location.Owning_Company_ID=@CompanyID and dbo.Contract.Pick_Up_On>='2007-01-08'  
	   and len(dbo.Contract.FF_Member_Number )=11




GO
