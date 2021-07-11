USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllDirBillPayments]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PROCEDURE NAME: GetAllDirBillPayments
PURPOSE: To retrieve all direct bill payments for a contract.
AUTHOR: Don Kirkby
DATE CREATED: May 4, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllDirBillPayments]
	@ContractNumber varchar(11),
	@SkipSeq	varchar(6)
AS

	/* 10/1/99 - do type conversion and nullifs outside of select */

DECLARE	@nSkipSeq smallint, 
	@iCtrctNum Int

SELECT	@nSkipSeq = CAST(NULLIF(@SkipSeq, '') AS smallint), 
	@iCtrctNum = CONVERT(int, NULLIF(@ContractNumber, ''))

SELECT	CBP.Customer_Code,
	cpi.amount,
	DBPB.PO_Number,
	DBAB.PO_Number,
	LOUAB.Claim_Number,
	LOUAB.Adjuster_Last_Name,
	LOUAB.Adjuster_First_Name,
	CBP.Billing_Method,
	Convert(char(1),DBPB.Issue_Interim_Bills),
	CBP.Billing_Type
  FROM	Contract_Billing_Party CBP
  JOIN	ar_payment ap
    ON	ap.contract_number = cbp.contract_number
   AND	ap.contract_billing_party_id = cbp.contract_billing_party_id
  JOIN	contract_payment_item cpi
    ON	ap.contract_number = cpi.contract_number
   AND	ap.sequence = cpi.sequence
  LEFT
  JOIN	Direct_Bill_Primary_Billing DBPB
    ON	CBP.Contract_Number = DBPB.Contract_Number
   AND	CBP.Contract_Billing_Party_ID = DBPB.Contract_Billing_Party_ID
  LEFT
  JOIN	Direct_Bill_Alternate_Billing DBAB
    ON	CBP.Contract_Number = DBAB.Contract_Number
   AND	CBP.Contract_Billing_Party_ID = DBAB.Contract_Billing_Party_ID
  LEFT
  JOIN	Loss_Of_Use_Alternate_Billing LOUAB
    ON	CBP.Contract_Number = LOUAB.Contract_Number
   AND	CBP.Contract_Billing_Party_ID = LOUAB.Contract_Billing_Party_ID
 WHERE	CBP.Contract_Number = @iCtrctNum
   AND	(  cpi.sequence > @nSkipSeq
	OR @nSkipSeq IS NULL
	)








GO
