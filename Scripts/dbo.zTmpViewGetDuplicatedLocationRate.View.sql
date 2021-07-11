USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewGetDuplicatedLocationRate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpViewGetDuplicatedLocationRate]
AS
SELECT     dbo.Location_Vehicle_Rate_Level.*
FROM         dbo.Location_Vehicle_Class INNER JOIN
                      dbo.Location_Vehicle_Rate_Level ON 
                      dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Location_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID
WHERE     (dbo.Vehicle_Class.Vehicle_Class_Name = 'Luxury 4X4') AND (dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type = 'future') AND 
                      (dbo.Location_Vehicle_Rate_Level.Valid_From > '2004-03-01') AND (dbo.Location.Location = 'B-01 YVR Airport')

GO
