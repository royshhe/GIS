USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AllowAllDropOffLocs]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.AllowAllDropOffLocs    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.AllowAllDropOffLocs    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.AllowAllDropOffLocs    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.AllowAllDropOffLocs    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To Return 1 if the group which includes the pick up location for the rate allows all drop off locations, else return 0.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[AllowAllDropOffLocs]
@RateID varchar(10),
@PickupLoc varchar(30)
AS
Declare @ret int
Declare @thisGroup smallint
Select @thisGroup = 	(Select
				Rate_Location_Set_ID
			From
				Rate_Location_Set_Member
			Where
				Rate_ID = Convert(int,@RateID)
				And Location_ID = Convert(smallint,@PickupLoc)
				And Termination_Date = 'Dec 31 2078 23:59')
Select @ret =	(Select
			Count(*)
		From
			Rate_Location_Set
		Where
			Rate_ID = Convert(int,@RateID)
			And Rate_Location_Set_ID = @thisGroup
			And Termination_Date = 'Dec 31 2078 23:59'
			And Allow_All_Auth_Drop_Off_Locs = 1)
If @ret > 1
	Select @ret = 1
Select @ret
Return 1













GO
