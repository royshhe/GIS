USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateValidDates]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/****** Object:  Stored Procedure dbo.UpdateValidDates    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateValidDates    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateValidDates    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateValidDates    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Rate_Availability table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateValidDates]
@RateID varchar(7),@OldFromDate varchar(25),@OldFromTime varchar(25),
@NewFromDate varchar(25),@NewFromTime varchar(25),@NewToDate varchar(25),
@NewToTime varchar(25),@ChangedBy varchar(20)
AS
Declare @thisDate datetime
Declare @OldFrom datetime
Declare @NewFrom datetime
Declare @NewTo datetime

Declare @nRateID Integer
Select @nRateID = Convert(int, NULLIF(@RateID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = (getDate())
Select @OldFrom = Convert(datetime, (@OldFromDate + " " + @OldFromTime))
Select @NewFrom = Convert(datetime, (@NewFromDate + " " + @NewFromTime))
Select @NewTo = Convert(datetime, (@NewToDate + " " + @NewToTime))
If @NewTo = 'Jan 1 1900'
	Select @NewTo = (null)

-- Set Rate Availability to expire
Update
	Rate_Availability
Set
	Termination_Date=@thisDate
Where
	Rate_ID=@nRateID
	And Termination_Date='Dec 31 2078 11:59PM'
	And Valid_From=@OldFrom

--Create a record for Rate Availability, the current has been expired
Insert Into Rate_Availability
	(Effective_Date,Termination_date,Rate_ID,Valid_From,Valid_To)
Values
	(DateAdd(second,1,@thisDate),'Dec 31 2078 11:59PM',
	@nRateID,@NewFrom,@NewTo)

--Update audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID=@nRateID
	And Termination_Date='Dec 31 2078 11:59PM'

Return 1





GO
