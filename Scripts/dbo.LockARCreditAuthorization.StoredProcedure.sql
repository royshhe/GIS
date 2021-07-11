USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockARCreditAuthorization]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the A/R Credit authorization records used by a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockARCreditAuthorization]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	contract_billing_party cbp WITH(UPDLOCK)
	  JOIN	ar_credit_authorization aca WITH(UPDLOCK) 
	    ON	cbp.customer_code = aca.customer_code
	 WHERE	contract_number = @nCtrctNum











GO
