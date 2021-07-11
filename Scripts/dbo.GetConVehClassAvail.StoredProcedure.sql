USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConVehClassAvail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetConVehClassAvail    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetConVehClassAvail    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConVehClassAvail    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConVehClassAvail    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of availability vehicle classes for the given parameters.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetConVehClassAvail]  --16, '2011-03-10' 
	@PULocId Varchar(5),
	@CurrDate Varchar(24)
AS
	IF @PULocId = ""	SELECT @PULocId = NULL
	IF @CurrDate = ""	SELECT @CurrDate = NULL
	/* 980810 CY - NOTE: must join with DOP table (when available)
			for displaying DOP message  
		Modified by Roy He 2011-03-10
        This Procedure seems to be obsolete, but modify anyway

*/
	SELECT	V.Vehicle_Class_Name, L.Vehicle_Class_Code, ""
	FROM	Vehicle_Class V 	Left Join	Location_Vehicle_Class L
		  ON V.vehicle_class_code = L.vehicle_class_code
	--WHERE 	V.vehicle_class_code *= L.vehicle_class_code
	AND	Convert(Datetime, @CurrDate) BETWEEN L.Valid_From AND   ISNULL(L.Valid_To, '2078-12-31 23:59')
	AND	L.Location_ID = Convert(SmallInt, @PULocId)
	ORDER BY
		V.Vehicle_Class_Name
	RETURN @@ROWCOUNT

--select *from Location_Vehicle_Class
GO
