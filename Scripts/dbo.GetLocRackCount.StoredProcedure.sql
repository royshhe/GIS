USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocRackCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To count the number of rack rates available for a date range,
	 location vehicle class id, and rate type (eg. Same Day, Future, etc.)
	Should always be exactly 1.
MOD HISTORY:
Name		Date        	Comments
Don Kirkby	May 12 2000	Created
*/
CREATE PROCEDURE [dbo].[GetLocRackCount]
	@LocationVehicleClassID	VarChar(10),
	@RateType		VarChar(20),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)
AS
DECLARE	@iLocationVehicleClassID smallint,
	@dtValidFrom	datetime,
	@dtValidTo	datetime

SELECT	@iLocationVehicleClassID = CONVERT(SmallInt, @LocationVehicleClassID),
	@dtValidFrom = CONVERT(datetime, @ValidFrom),
	@dtValidTo = CASE WHEN @ValidTo = '' THEN 'Dec 31 2078'
			ELSE @ValidTo
			END

	SELECT	Count(*)
	FROM	Location_Vehicle_Rate_Level
	WHERE	Location_Vehicle_Class_ID = @iLocationVehicleClassID
	AND	Location_Vehicle_Rate_Type = @RateType
	AND	Rate_Selection_Type = 'Rack'
	AND	Valid_From <= @dtValidTo
	AND	ISNULL(Valid_To, @dtValidFrom) >= @dtValidFrom
	
RETURN 1

GO
