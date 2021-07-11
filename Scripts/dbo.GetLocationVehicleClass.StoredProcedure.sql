USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationVehicleClass]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetLocationVehicleClass    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleClass    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleClass    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleClass    Script Date: 11/23/98 3:55:33 PM ******/
/* 29-Nov-99 - return another valid from in the last column*/
CREATE PROCEDURE [dbo].[GetLocationVehicleClass]
	@LocationID	VarChar(10),
	@AsOfDate	VarChar(24)
AS
	Declare @TempDate SmallDateTime
	Select @TempDate = CONVERT(DateTime, @AsOfDate)
	Set Rowcount 2000
	SELECT	VC.Vehicle_Class_Name,
		LVC.Vehicle_Class_Code,
		LVC.Location_Vehicle_Class_ID,
		CONVERT(VarChar, LVC.Valid_From, 111) Valid_From,
		CONVERT(VarChar, LVC.Valid_To, 111) Valid_To,
		CONVERT(VarChar, LVC.Valid_From, 111) Valid_From1,
		CONVERT(VarChar, LVC.Valid_To, 111) Valid_To1
	FROM	Location_Vehicle_Class LVC,
		Vehicle_Class VC
	WHERE	LVC.Vehicle_Class_Code = VC.Vehicle_Class_Code
	AND	LVC.Location_ID = CONVERT(SmallInt, @LocationID)
	AND	(LVC.Valid_To >= @TempDate OR LVC.Valid_To IS Null)
	ORDER BY
		VC.Vehicle_Class_Name,
		Valid_From DESC
RETURN 1
GO
