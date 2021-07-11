USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateIncludedSalesAccessory]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To update a sales accessory included in a rate
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        	Comments
Don K	Aug 5 1999	Added IncludedAmount
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateIncludedSalesAccessory]
	@RateID varchar(7),
	@OldID varchar(25),
	@NewID varchar(25),
	@IncludedAmount varchar(11),
	@Quantity varchar(25),
	@ChangedBy varchar(20)
AS
Declare 	@thisDate datetime
Declare	@nRateID Integer
Declare	@nOldID SmallInt

Select		@nRateID = Convert(int, NULLIF(@RateID, ''))
Select		@nOldID = Convert(smallint, NULLIF(@OldID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = (getDate())

Update
	Included_Sales_Accessory
Set
	Termination_Date=@thisDate
Where
	Rate_ID = @nRateID
	And Termination_Date='Dec 31 2078 11:59PM'
	And Sales_Accessory_ID = @nOldID

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
	DateAdd(second,1,@thisDate),
	'Dec 31 2078 11:59PM',
	@nRateID,
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
	Rate_ID = @nRateID
	And Termination_Date='Dec 31 2078 11:59PM'

Return @nRateID



GO
