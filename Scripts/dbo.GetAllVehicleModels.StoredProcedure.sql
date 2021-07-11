USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllVehicleModels]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetAllVehicleModels    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehicleModels    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehicleModels    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To retrieve a list of vehicle model for the most recent year.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllVehicleModels]
AS
Set Rowcount 2000
-- NP - Jan 20, 1999 - Modified to return 5 more columns at the end
SELECT	
	Distinct
	Model_Name,
	Model_Name as ModelName,
	Km_Per_Litre,
	Fuel_Tank_Size,
	PST_Rate,
	Diesel
FROM
	Vehicle_Model_Year VMY1
WHERE	Model_Year = (	SELECT	MAX(Model_Year)
			FROM	Vehicle_Model_Year VMY2
			WHERE	VMY2.Model_Name = VMY1.Model_Name)
	OR Model_Year IS NULL
ORDER BY
	Model_Name
RETURN 1
GO
