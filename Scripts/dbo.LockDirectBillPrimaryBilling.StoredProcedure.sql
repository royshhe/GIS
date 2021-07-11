USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockDirectBillPrimaryBilling]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Direct Bill Primary Billing for a contract
AUTHOR: Niem Phan
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockDirectBillPrimaryBilling]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Direct_Bill_Primary_Billing WITH(UPDLOCK)
	 WHERE	contract_number = @nCtrctNum








GO
