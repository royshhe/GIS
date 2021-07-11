USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockContractReimburAndDiscount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the reimbursements and discounts for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 2 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockContractReimburAndDiscount]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	contract_reimbur_and_discount WITH(UPDLOCK)
	 WHERE	contract_number = @nCtrctNum








GO
