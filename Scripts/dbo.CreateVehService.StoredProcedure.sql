USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehService]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehService    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Service table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehService]
	@UnitNum Varchar(10),
	@ServiceDate Varchar(24),
	@CondStatus Varchar(1),
	@CurrKm Varchar(10),
	@FuelDollars Varchar(8),
	@FuelLitres Varchar(10),
	@FuelTankLevel Varchar(6),
	@LitresRemaining Varchar(10),
	@SmokingFlag Varchar(1)
AS
DECLARE @iUnitNum Integer
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,""))
	INSERT INTO Vehicle_Service
		(Unit_Number,
		 Service_Performed_On,
		 Condition_Status, Km_Reading,
		 Fuel_Added_Dollars, Fuel_Added_Litres,
		 Fuel_Tank_Level, Litres_Remaining, Smoking)
	VALUES	(@iUnitNum,
		 Convert(Datetime, NULLIF(@ServiceDate,"")),
		 NULLIF(@CondStatus,""),
		 Convert(Int, NULLIF(@CurrKm,"")),
		 Convert(Decimal(7, 2), NULLIF(@FuelDollars,"")),
		 Convert(Int, NULLIF(@FuelLitres,"")),
		 NULLIF(@FuelTankLevel,""),
		 Convert(Int, NULLIF(@LitresRemaining,"")),
		 Convert(Bit, @SmokingFlag))
	RETURN @iUnitNum













GO
