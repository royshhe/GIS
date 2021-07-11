USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsForeignLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.IsForeignLocation    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.IsForeignLocation    Script Date: 2/16/99 2:05:43 PM ******/
/*
PURPOSE: To check if the given location is a budgetBC location.
	        If so return 1 and 0 otherwise.
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[IsForeignLocation]
@LocationID	VarChar(10)
AS
Declare @ret int
Declare @nLocationID Integer
select @nLocationID = Convert(int, NULLIF(@LocationID, ''))

Select
	Location_ID
From
	Location L, Lookup_Table LT
Where
	L.Location_ID = @nLocationID
	And L.Owning_Company_ID <> Convert(int, LT.Code)
	And LT.Category = 'BudgetBC Company'

If @@ROWCOUNT = 0
	Select @ret = 0
Else
	Select @ret = 1
RETURN @ret















GO
