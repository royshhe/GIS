USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateIncludedSalesAccessory]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To create an optional extra included in a rate
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        Comments
Don K	Aug 5 1999  Added IncludedDailyAmount and IncludedWeeklyAmount
*/
CREATE PROCEDURE [dbo].[CreateIncludedSalesAccessory]
	@RateID varchar(7),
	@NewID varchar(25),
	@IncludedAmount varchar(11),
	@Quantity varchar(25),
	@ChangedBy varchar(20)
AS
Declare @thisDate datetime
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()
Insert Into Included_Sales_Accessory
	(
	Effective_Date,
	Termination_Date,
	Rate_ID,
	Sales_Accessory_ID,
	Included_Amount,
	Quantity
	)
Values
	(
	@thisDate,
	'Dec 31 2078 11:59PM',
	Convert(int,@RateID),
	Convert(smallint,@NewID),
	CAST(NULLIF(@IncludedAmount, '') AS decimal(9,2)),
	Convert(int,@Quantity)
	)
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
