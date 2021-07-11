USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRateLocationSet]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteRateLocationSet    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.DeleteRateLocationSet    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteRateLocationSet    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteRateLocationSet    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Rate_Location_Set and Rate_Location_Set_Member and Rate_Drop_Off_Location table by setting the Termination Date
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteRateLocationSet]
@RateID varchar(7),@RateLocationSetId varchar(7)
AS
Declare @thisDate datetime
Select @thisDate = getDate()

Update
	Rate_Location_Set
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Rate_Location_Set_Id=Convert(int,@RateLocationSetId)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Location_Set_Member
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Rate_Location_Set_Id=Convert(int,@RateLocationSetId)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Drop_Off_Location
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Rate_Location_Set_Id=Convert(int,@RateLocationSetId)
	And Termination_Date='Dec 31 2078 11:59PM'
Return 1













GO
