USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockRenterPrimaryBilling]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the renter primary billings for a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockRenterPrimaryBilling]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	renter_primary_billing AS RPB WITH(UPDLOCK)
	JOIN		credit_card AS CC WITH(UPDLOCK)
	ON		RPB.Credit_Card_Key = CC.Credit_Card_Key

	 WHERE	RPB.contract_number = @nCtrctNum








GO
