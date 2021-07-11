USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockContractPaymentItem]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the payment items for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockContractPaymentItem]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	contract_payment_item AS CPI WITH(UPDLOCK)
	JOIN		business_transaction AS BT WITH(UPDLOCK)
	ON		CPI.Business_Transaction_ID = BT.Business_Transaction_ID

	 WHERE	CPI.contract_number = @nCtrctNum








GO
