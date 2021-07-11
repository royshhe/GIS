USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockContractCustomer]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
PURPOSE: To lock the customer for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockContractCustomer]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	contract
	  JOIN	customer WITH(UPDLOCK)
	    ON	contract.customer_id = customer.customer_id
	 WHERE	contract_number = @nCtrctNum









GO
