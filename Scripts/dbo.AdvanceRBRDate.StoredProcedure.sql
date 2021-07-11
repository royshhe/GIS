USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AdvanceRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PURPOSE: To update the latest RBR Date record with current date time and  insert a record into RBR Date table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[AdvanceRBRDate]
	@Username Varchar(35),
	@NewRBRDate Varchar(35)
	
AS

DECLARE @thisRBRDate datetime
DECLARE @thisDate datetime

Select @thisRBRDate =
	(Select
		Max(RBR_Date)
	From
		RBR_Date),
	@thisDate = getDate()

Update
	RBR_Date
Set
	Budget_Close_Datetime = @thisDate,
	Closed_By = @Username
Where
	RBR_Date = @thisRBRDate

Insert Into RBR_Date
	(RBR_Date, Budget_Start_Datetime, Date_Generated)
Values
	(Convert(datetime, @NewRBRDate), @thisDate, @thisDate)
RETURN 1















GO
