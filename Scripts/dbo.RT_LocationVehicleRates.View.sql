USE [GISData]
GO
/****** Object:  View [dbo].[RT_LocationVehicleRates]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
VIEW NAME: RT_Contract_BaseRate_Amount
PURPOSE: Get Location Vehicle Rate Listing
	 
AUTHOR:	Roy He
DATE CREATED: 2005/08/01
USED BY: CSR Incentive Report
MOD HISTORY:
Name 		Date		Comments
				is not defined in the lookup table.
*/
CREATE VIEW [dbo].[RT_LocationVehicleRates]
AS
SELECT     dbo.Location_Vehicle_Class.Location_ID, dbo.Location_Vehicle_Class.Vehicle_Class_Code, dbo.Location_Vehicle_Rate_Level.Rate_ID, 
                      dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type, dbo.Location_Vehicle_Rate_Level.Rate_Level, 
                      dbo.Location_Vehicle_Rate_Level.Valid_From, dbo.Location_Vehicle_Rate_Level.Valid_To, 
                      dbo.Location_Vehicle_Rate_Level.Rate_Selection_Type
FROM         dbo.Location_Vehicle_Rate_Level INNER JOIN
                      dbo.Location_Vehicle_Class ON 
                      dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID
where dbo.Location_Vehicle_Class.Valid_to is null or dbo.Location_Vehicle_Class.Valid_to>getdate()








GO
