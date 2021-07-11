USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockInterimBill]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
PURPOSE: To lock the interim bills for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockInterimBill]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	interim_bill WITH(UPDLOCK)
	 WHERE	contract_number = @nCtrctNum









GO
