USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehicleModelYearRevenue]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVehicleModelYearRevenue]
AS
SELECT     Vehicle_Class_Name, model_name, model_year, SUM(Contract_Rental_Days) AS RentalDays, SUM(KmDriven) AS KmDriven, 
                      COUNT(Contract_number) AS ContractCount, SUM(TimeKmCharge) AS TimeKmCharge, SUM(All_Level_LDW) AS LDW
FROM         dbo.ViewContractRevenueAllSum
WHERE     (RBR_Date BETWEEN '2003-06-01' AND '2003-06-30') AND (model_name LIKE '%Lincoln%' OR
                      model_name LIKE '%MUST%' OR
                      model_name LIKE '%explorer%')
GROUP BY Vehicle_Class_Name, model_name, model_year
GO
