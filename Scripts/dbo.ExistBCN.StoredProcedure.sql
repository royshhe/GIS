USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExistBCN]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PURPOSE: To check whether or not a given @BCNNumber is attached to a customer
	 other than @CustID
MOD HISTORY:
Name	Date		Comment
5/12/99 - cpy bug fix - apply nullif check on @BCNNumber
				- apply default if @CustId is null 
10/10/99 - do type conversion and nullif outside of sql statement 
CPY 	Dec 20 1999	renamed local vars to be more accurate
*/
CREATE PROCEDURE [dbo].[ExistBCN]
	@BCNNumber Varchar(35),
	@CustID Varchar(35)
AS
DECLARE @iCustId Int

	SELECT	@iCustId = ISNULL(Convert(int, NULLIF(@CustID, '')), -1),
		@BCNNumber = NULLIF(@BCNNumber,'')

Select
	Program_Number
From
	Customer
Where
	Program_Number = @BCNNumber
	And Customer_ID <> @iCustId
	AND Inactive = 0
Return 1
















GO
