USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyIncludedSalesAccessory]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyIncludedSalesAccessory    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.CopyIncludedSalesAccessory    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyIncludedSalesAccessory    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyIncludedSalesAccessory    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Included_Sales_Accessory info from the current rate into the new rate.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyIncludedSalesAccessory]
@OldRateID int,
@NewRateID int
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */
	/* 8/13/99 - copy new column included_amount */

Declare @thisDate datetime
Declare @dEndDate Datetime
Declare @SalesAccessoryID smallint
Declare @Quantity smallint
Declare @InclAmount Decimal(9,2)
	
	Select 	@thisDate = getDate(),
		@dEndDate = Cast('Dec 31 2078 23:59' AS Datetime)
	
Declare thisCursor Cursor FAST_FORWARD For
	(Select	Sales_Accessory_ID, Quantity, Included_Amount
	 From	Included_Sales_Accessory
	 Where	Rate_ID = Convert(int,@OldRateID)
	 And 	Termination_Date = @dEndDate)
	
Open thisCursor
Fetch Next From thisCursor Into @SalesAccessoryID, @Quantity, @InclAmount
	
While (@@Fetch_Status = 0)
	Begin
		Insert Into Included_Sales_Accessory
			(Rate_ID,
			 Effective_Date,
			 Termination_Date,
			 Sales_Accessory_ID,
			 Quantity,
			 Included_Amount)
		Values
			(@NewRateID,
			 @thisDate,
			 @dEndDate,
			 @SalesAccessoryID,
			 @Quantity,
			 @InclAmount)
	
		Fetch Next From thisCursor Into @SalesAccessoryID,
						@Quantity, @InclAmount
	End
	
Close thisCursor
Deallocate thisCursor

Return 1















GO
