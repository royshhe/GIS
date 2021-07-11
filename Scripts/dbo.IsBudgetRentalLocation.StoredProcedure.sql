USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsBudgetRentalLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
PURPOSE: To check if the given  location is BudgetBC location. If so return 1and 0 otherwise.
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[IsBudgetRentalLocation]
	@LocationID	VarChar(10)
AS
	/* 7/20/99 - return 1 if LocationId is a BudgetBC and rental location
		   - else return 0 */
	Declare @ret int
	Declare @nLocationID Integer

	Select @nLocationID = Convert(int, NULLIF(@LocationID, ''))

	Select	Location_ID
	From	Location L, Lookup_Table LT
	Where	L.Location_ID = @nLocationID
	And 	L.Owning_Company_ID = Convert(int, LT.Code)
	And 	LT.Category = 'BudgetBC Company'
	AND	L.Rental_Location = 1

	If @@ROWCOUNT = 0
		Select @ret = 0
	Else
		Select @ret = 1

	RETURN @ret













GO
