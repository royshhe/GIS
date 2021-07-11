USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllVehClassMinAge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllVehClassMinAge    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehClassMinAge    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehClassMinAge    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehClassMinAge    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of the minimum age for vehicle classes.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllVehClassMinAge]
AS
SELECT
	Vehicle_Class_Name,
	Minimum_Age,
	Vehicle_Class_Code
FROM
	Vehicle_Class
ORDER BY
	-- Vehicle_Class_Code, Minimum_Age
	Vehicle_Class_Name, Minimum_Age
Return 1













GO
