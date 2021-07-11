USE [GISData]
GO
/****** Object:  View [dbo].[FA_Vehicle_Price_Auditing_Auditing]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[FA_Vehicle_Price_Auditing_Auditing]
AS
SELECT     dbo.Vehicle.Year_Of_Agreement, dbo.YearOfAgreement.Agreement_Year, dbo.Vehicle.Purchase_Cycle, dbo.YearOfAgreement.Cycle, 
                      dbo.Vehicle.Purchase_Price, dbo.YearOfAgreement.PRICE, dbo.Vehicle.Vehicle_Cost, dbo.YearOfAgreement.COST, dbo.Vehicle.PDI_Amount, 
                      dbo.YearOfAgreement.PDI, dbo.Vehicle.PDI_Included_In_Price, dbo.Vehicle.PDI_Performed_By, dbo.Vehicle.Rebate_Amount, dbo.Vehicle.Rebate_From,
                       dbo.Vehicle.Unit_Number
FROM         dbo.Vehicle INNER JOIN
                      dbo.YearOfAgreement ON dbo.Vehicle.Unit_Number = dbo.YearOfAgreement.UNIT
GO
