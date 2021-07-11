USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetProveRateDropOffLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetProveRateDropOffLoc    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetProveRateDropOffLoc    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetProveRateDropOffLoc    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetProveRateDropOffLoc    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetProveRateDropOffLoc]
@RateID varchar(10),
@PickupLoc varchar(30),
@DropOffLocID varchar(15)
AS
Declare @thisGroup smallint
Select @thisGroup = 	(Select
				Rate_Location_Set_ID
			From
				Rate_Location_Set_Member
			Where
				Rate_ID=Convert(int,@RateID)
				And Location_ID=Convert(smallint,@PickupLoc)
				And Termination_Date='Dec 31 2078 11:59PM')
Select
	Count(*)
From
	Rate_Location_Set RLS, Rate_Drop_Off_Location RDL
Where
	RLS.Rate_Location_Set_ID=RDL.Rate_Location_Set_ID
	And RLS.Rate_ID=RDL.Rate_ID
	And RLS.Rate_ID=Convert(int,@RateID)
	And RLS.Rate_Location_Set_ID=@thisGroup
	And RDL.Location_ID=Convert(int,@DropOffLocID)
	And RDL.Termination_Date='Dec 31 2078 11:59PM'
Return 1












GO
