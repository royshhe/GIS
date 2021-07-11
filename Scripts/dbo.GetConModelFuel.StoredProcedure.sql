USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConModelFuel]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetConModelFuel    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.GetConModelFuel    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConModelFuel    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConModelFuel    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the vehicle model year information fro the given unit number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetConModelFuel]--	178071
	@UnitNum Varchar(10)
AS
	/* 10/12/99 - do type conversion and nullif outside of SQL statement */
DECLARE	@iUnitNum Int

	SELECT	@iUnitNum = Convert(Int, NULLIF(@UnitNum,""))

	SELECT	VMY.Fuel_Tank_Size, Convert(Char(1), VMY.Diesel),
		VMY.PST_Rate, VMY.KM_Per_Litre, VMY.Passenger_Vehicle
	FROM	Vehicle_Model_Year VMY,
		Vehicle V
	WHERE	V.Unit_Number = @iUnitNum
	AND	V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	RETURN @@ROWCOUNT


 













GO
