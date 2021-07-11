USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateValidDates]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateValidDates    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateValidDates    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateValidDates    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateValidDates    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Rate_Availability table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateValidDates]
@RateID varchar(7),@NewFromDate varchar(25),@NewFromTime varchar(25),@NewToDate varchar(25),
@NewToTime varchar(25),@ChangedBy varchar(25)
AS
Declare @thisdate datetime
Declare @NewFrom datetime
Declare @NewTo datetime
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()
Select @NewFrom = Convert(datetime, (@NewFromDate + " " + @NewFromTime))
Select @NewTo = Convert(datetime, (@NewToDate + " " + @NewToTime))
If @NewTo = 'Jan 1 1900' /* Means New Date was blank */
	Select @NewTo = (null)
Insert Into Rate_Availability
	(Effective_Date,Termination_Date,Rate_ID,Valid_From,Valid_To)
Values
	(@thisDate,'Dec 31 2078 11:59PM',
	Convert(int,@RateID),@NewFrom,@NewTo)

-- update vehicle rate audit info.
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
