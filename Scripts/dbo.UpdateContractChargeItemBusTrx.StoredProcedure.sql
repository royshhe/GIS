USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContractChargeItemBusTrx]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: To update the Contract_Charge_Item table and set all the business
	transaction ids for a contract
AUTHOR: Don Kirkby
DATE CREATED: Jul 6, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[UpdateContractChargeItemBusTrx]
	@ContractNumber Varchar(11),
	@BusTrxID	Varchar(11)
AS
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(int, NULLIF(@ContractNumber, ''))

	UPDATE	Contract_Charge_Item
	   SET	Business_Transaction_ID = Convert(int, NULLIF(@BusTrxID, ''))
	 WHERE	Contract_Number = @iCtrctNum

	RETURN @@ROWCOUNT














GO
