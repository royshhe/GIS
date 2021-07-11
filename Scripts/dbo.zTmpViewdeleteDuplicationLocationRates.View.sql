USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewdeleteDuplicationLocationRates]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpViewdeleteDuplicationLocationRates]
AS
SELECT Location_Vehicle_Class_ID, Rate_ID, Rate_Level, Location_Vehicle_Rate_Type, 
    Valid_From, Valid_To, Rate_Selection_Type
FROM dbo.Location_Vehicle_Rate_Level
WHERE (Location_Vehicle_Class_ID = 945) AND (Location_Vehicle_Rate_Type = 'same day') 
    AND (Valid_From >= '2003-06-01')

GO
