USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVehicleRatesPeriod]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewLocationVehicleRatesPeriod]
AS
SELECT     dbo.Location.Location, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type, 
                      MAX(dbo.Location_Vehicle_Rate_Level.Valid_To) AS PeroidEnd
FROM         dbo.Location_Vehicle_Class INNER JOIN
                      dbo.Location_Vehicle_Rate_Level ON 
                      dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Location_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID
			inner join Lookup_Table on location.Owning_Company_ID=Lookup_Table.Code
WHERE   (Lookup_Table.Category = 'BudgetBC Company')  -- (dbo.Location.Owning_Company_ID = 7425)
GROUP BY dbo.Location.Location, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type
GO
