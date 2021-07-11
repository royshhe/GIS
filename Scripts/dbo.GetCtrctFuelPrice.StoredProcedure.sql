USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctFuelPrice]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctFuelPrice    Script Date: 2/18/99 12:11:53 PM ******/
/*
PURPOSE: 	To retrieve fuel price for the given location.  
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctFuelPrice]
	@LocId Varchar(5),
	@IsDiesel Varchar(1)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iLocId SmallInt
	SELECT @iLocId = Convert(SmallInt, NULLIF(@LocId,''))

	/* get non-fpo fuel price for location */
	/* if IsDiesel, return diesel fuel price */

	SELECT	CASE Convert(Bit, @IsDiesel)
			WHEN 0 THEN Fuel_Price_Per_Liter
			WHEN 1 THEN Fuel_Price_Per_Liter_Diesel
		END

	FROM	Location
	WHERE	Location_ID = @iLocId

	RETURN @@ROWCOUNT












GO
