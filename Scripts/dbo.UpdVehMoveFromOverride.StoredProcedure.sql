USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehMoveFromOverride]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To complete a movement in the Vehicle_Movement table; initiated by vehicle movement override.
MOD HISTORY:
Name	Date		Comment
CPY	Jan 6 2000	Created
*/
CREATE PROCEDURE [dbo].[UpdVehMoveFromOverride]
	@UnitNumber 	varchar(30),
	@MovementOutDateTime 	varchar(30),
	@MovementInDateTime 	varchar(30),
	@KmIn 		varchar(30),
	@ReceivingLoc	varchar(30),
	@RemarksIn	varchar(30)
AS
DECLARE @ReceivingLocId Int,
	@iUnitNumber Int,
	@dMovementOutDatetime Datetime

	SELECT	@iUnitNumber = Convert(Int, NULLIF(@UnitNumber,'')),
		@dMovementOutDatetime = Convert(Datetime, NULLIF(@MovementOutDatetime,'')),
		@MovementInDatetime = NULLIF(@MovementInDatetime,''),
		@KmIn = NULLIF(@KmIn,''),
		@ReceivingLoc = NULLIF(@ReceivingLoc,''),
		@RemarksIn = NULLIF(@RemarksIn,'')

	SELECT	@ReceivingLocId = Location_Id
	FROM	Location
	WHERE	Location = @ReceivingLoc

	Update	Vehicle_Movement
	Set	Movement_In = Convert(Datetime, @MovementInDatetime),
		Receiving_Location_ID = @ReceivingLocId,
		Km_In = Convert(int, @KmIn),
		Remarks_In = @RemarksIn
	Where
		Unit_Number		= @iUnitNumber
		And Movement_Out	= @dMovementOutDatetime
Return 1


GO
