USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAcctgBTCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: To see if CreateAcctgBT has been called for this RBR date.
AUTHOR: Don Kirkby
DATE CREATED: Aug 3 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAcctgBTCount]
	@RBRDate varchar(24)
AS

	SELECT	@RBRDate = NULLIF(@RBRDate , '')

	SELECT	COUNT(*)
	  FROM	business_transaction_export
	 WHERE	rbr_date = CAST(@RBRDate AS datetime)









GO
