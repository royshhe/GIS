USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Uploading_Purchase_Eligibility]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[FA_Uploading_Purchase_Eligibility]  -- '2008-07-21','2009-03-31'
		
As

Insert into FA_Repurchase_Eligibility Select * from FA_Repurchase_Eligibility_Input PEI where  PEI.Vin not in (select Vin from FA_Repurchase_Eligibility)

Update FA_Repurchase_Eligibility
Set
Repurchase_Year = PEI.Repurchase_Year,
Sold_FIN = PEI.Sold_FIN,
Vehicle_Line_Name = PEI.Vehicle_Line_Name,
ISD = PEI.ISD,
Contract_End_Min_Date = PEI.Contract_End_Min_Date,
Mileage_Penalty = PEI.Mileage_Penalty,
Capitalized = PEI.Capitalized,
Rep_Payment = PEI.Rep_Payment,
Repurchase_Payment_Date = PEI.Repurchase_Payment_Date,
Avg_Days_In_Service = PEI.Avg_Days_In_Service,
Contract_End_Max_Date = PEI.Contract_End_Max_Date

FROM         dbo.FA_Repurchase_Eligibility AS PE INNER JOIN
                      dbo.FA_Repurchase_Eligibility_Input AS PEI ON PE.Vin = PEI.Vin

Delete FA_Repurchase_Eligibility_Input
GO
