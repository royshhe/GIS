USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableLocationsData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PURPOSE: 	To retrieve a list of location that are in the rate location set member table.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAvailableLocationsData]
@RateID varchar(20), @RateLocationSetID varchar(20)
AS
Set Rowcount 2000
Select Distinct
	L.Location
From
	Location L, Pick_Up_Drop_Off_Location PUDOL
Where
	L.Location_ID = PUDOL.Pick_Up_Location_ID
	And L.Resnet = 1
	And L.Delete_Flag = 0
	And L.Location Not In (	Select
					L2.Location
				From
					Location L2, Rate_Location_Set_Member RLSM
				Where
					L2.Location_ID = RLSM.Location_ID
					And RLSM.Rate_ID = Convert(int,@RateID)
					And RLSM.Termination_Date = 'Dec 31 2078 11:59PM'
					And L2.Delete_Flag=0)
Return 1
















GO
