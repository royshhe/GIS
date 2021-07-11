USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehRestrictedLocations]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehRestrictedLocations    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehRestrictedLocations    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehRestrictedLocations    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehRestrictedLocations    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehRestrictedLocations]
	@UnitNumber	VarChar(10)
AS
   	Set Rowcount 2000
	
   	SELECT	Distinct Location_ID
   	FROM   	Vehicle_Location_Restriction
	WHERE	Unit_Number = CONVERT(Int, @UnitNumber)
   	ORDER BY 	
		Location_ID
   	RETURN 1












GO
