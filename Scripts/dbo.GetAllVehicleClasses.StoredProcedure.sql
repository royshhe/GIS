USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllVehicleClasses]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetAllVehicleClasses    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehicleClasses    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of vehicle classes.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllVehicleClasses]
AS
Set Rowcount 2000
SELECT
	Vehicle_Class_Name,
	Vehicle_Class_Code,
	Vehicle_Type_ID
FROM
	Vehicle_Class
ORDER BY
	DisplayOrder
--	Vehicle_Class_Name
RETURN 1














GO
