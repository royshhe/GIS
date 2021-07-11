USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetRepurchaseEligibility]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[FA_GetRepurchaseEligibility]
	@UnitNumber		VarChar(10)
	
AS
	

SELECT     dbo.FA_Repurchase_Eligibility.ISD, dbo.FA_Repurchase_Eligibility.Capitalized, dbo.FA_Repurchase_Eligibility.Mileage_Penalty, 
                      dbo.FA_Repurchase_Eligibility.Rep_Payment, dbo.FA_Repurchase_Eligibility.Repurchase_Payment_Date, 
                      dbo.FA_Repurchase_Eligibility.Avg_Days_In_Service, dbo.FA_Repurchase_Eligibility.Contract_End_Min_Date, 
                      dbo.FA_Repurchase_Eligibility.Contract_End_Max_Date
FROM         dbo.Vehicle INNER JOIN
                      dbo.FA_Repurchase_Eligibility ON dbo.Vehicle.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
where dbo.Vehicle.Unit_number=convert(int, @UnitNumber)
GO
