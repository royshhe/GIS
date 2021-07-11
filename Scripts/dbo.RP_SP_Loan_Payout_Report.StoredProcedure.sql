USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Loan_Payout_Report]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  Procedure [dbo].[RP_SP_Loan_Payout_Report]  -- '*', '2009-09-01', '2009-09-30'
	@FinCode Varchar(20),
	@StartPayoutDate Varchar(24),
	@EndPayoutDate Varchar(24)
As


Declare @dStartPayoutDate  Datetime
Declare @dEndPayoutDate Datetime
Select @dStartPayoutDate=Convert(Datetime, NULLIF(@StartPayoutDate,''))
Select @dEndPayoutDate=Convert(Datetime, NULLIF(@EndPayoutDate,''))


Declare @CompanyName Varchar(50)
 
SELECT     @CompanyName=dbo.SystemSettingValues.SettingValue
FROM         dbo.SystemSetting INNER JOIN
                      dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
WHERE     (dbo.SystemSetting.SettingName = 'CompanyInfo') AND (dbo.SystemSettingValues.ValueName = 'CompanyName')
 


SELECT   @CompanyName as CompanyName,  V.Unit_Number, VMY.Model_Name, VMY.Model_Year, VMY.Manufacturer_ID, V.Serial_Number, isnull(V.Sales_PST,0) as Sales_PST,V.ISD, V.Sales_Processed_date, 
                      isnull(V.Selling_Price,0) as Selling_Price, isnull(V.Sales_GST,0) as Sales_GST, LH.Payout_Amount, LH.Payout_Date, LH.Fin_Code, LH.Loan_Amount, LH.Finance_Start_Date, 


					(SELECT   	sum(Interest_Amount) As InterestToDate
							FROM         dbo.FA_Loan_Amortization
							where AMO_Month<=DATEADD(Month, -1, LH.Payout_Date-Day(LH.Payout_Date)+1)
							And Unit_Number=LH.Unit_Number and Fin_Code=LH.Fin_Code  and Finance_Start_Date=LH.Finance_Start_Date							
					) InterestToDate,

					(SELECT    Top 1  Balance
							FROM         dbo.FA_Loan_Amortization
							where AMO_Month<=DATEADD(Month, -1, LH.Payout_Date-Day(LH.Payout_Date)+1)
									And Unit_Number=LH.Unit_Number and Fin_Code=LH.Fin_Code  and Finance_Start_Date=LH.Finance_Start_Date
							Order By AMO_Month Desc

					) Balance, 
					V.Payment_Cheque_No

FROM         dbo.Vehicle V INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
                      dbo.FA_Loan_History LH ON V.Unit_Number = LH.Unit_Number
where (LH.Fin_Code=@FinCode  or @FinCode='*') And LH.Payout_Date between @dStartPayoutDate and @dEndPayoutDate
order by v.unit_number


GO
