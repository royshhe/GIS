USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockVoucherAlternateBilling]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the voucher alternate billing for a contract
AUTHOR: Cindy Yee
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockVoucherAlternateBilling]
	@CtrctNum varchar(11)
AS
	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	voucher_alternate_billing WITH(UPDLOCK)
	 WHERE	contract_number = @nCtrctNum






GO
