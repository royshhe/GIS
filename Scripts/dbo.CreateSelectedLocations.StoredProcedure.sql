USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSelectedLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateSelectedLocations    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateSelectedLocations    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSelectedLocations    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSelectedLocations    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Rate_Location_Set_Member table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSelectedLocations]
@RateID varchar(25),@RateLocationSetID varchar(25),@Location varchar(25),
@ChangedBy varchar(20)
AS
Declare @thisDate datetime
Declare @ThisLocationID smallint
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()

Select @ThisLocationID = (Select Distinct Location_ID
			  From Location
			  Where Location=@Location)
Insert Into Rate_Location_Set_Member
	(Effective_Date,Termination_Date,Location_ID,Rate_ID,Rate_Location_Set_ID)
Values
	(getdate(),'Dec 31 2078 11:59PM',
	@ThisLocationID,Convert(int,@RateID),Convert(int,@RateLocationSetID))

--update vehicle audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
Return 1













GO
