USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[WipeVoucherStandardDescrip]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PROCEDURE NAME: WipeVoucherStandardDescrip
PURPOSE: To delete ALL standard descriptions for a voucher.
AUTHOR: Don Kirkby
DATE CREATED: Mar 17, 1999
CALLED BY: Contract
ENSURES: Child records have been dropped
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[WipeVoucherStandardDescrip]
	@CtrctNum varchar(20),
	@OrgID varchar(35)
AS
	Declare @BillingPartyID int,
		@nCtrctNum int
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))
	SELECT	@BillingPartyID =
		(Select
			Contract_Billing_Party_ID
		From
			Contract_Billing_Party
		Where
			Contract_Number = @nCtrctNum
			And Billing_Type = 'a'
			And Billing_Method = 'Voucher'
			And Customer_Code = @OrgID)

	DELETE
	  FROM	Voucher_Alt_Billing_Std_Des
	 WHERE	contract_number = @nCtrctNum
	   AND	contract_billing_party_id = @BillingPartyID











GO
