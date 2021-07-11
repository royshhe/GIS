USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllVehicleStatusForUpdate2]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetAllVehicleStatusForUpdate2    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehicleStatusForUpdate2    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehicleStatusForUpdate2    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllVehicleStatusForUpdate2    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of vehicle status except sttus od 'Drop Ship' and 'Owned'.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllVehicleStatusForUpdate2]
AS
Set Rowcount 2000
SELECT
	Value,Code
FROM
	Lookup_Table
WHERE
	Category='Vehicle Status'
	And Not Value='Drop Ship'
	And Not Value='Owned'
	and value<>'Held'
Order By Value
RETURN 1














GO
