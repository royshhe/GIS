USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustNoFF]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PURPOSE: To disconnect a frequent flyer membership from the customer's preferred FF
AUTHOR: Don Kirkby
DATE CREATED: Nov 23 1999
CALLED BY: Customer
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[UpdateCustNoFF]
	@CustId Varchar(10),
	@UserName varchar(20)
AS
DECLARE @nCustId integer
SELECT	@nCustId = Convert(integer, NULLIF(@CustId, ''))

UPDATE	customer
   SET	preferred_ff_plan_id = NULL,
	preferred_ff_member_number = NULL,
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
 WHERE	customer_id = @nCustId



GO
