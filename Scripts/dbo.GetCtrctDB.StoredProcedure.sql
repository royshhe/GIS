USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDB]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetCtrctDB
PURPOSE: To retrieve the amount that has already been billed to a direct bill
        customer on a contract.
AUTHOR: Don Kirkby
DATE CREATED: May 20 1999
CALLED BY: Contract
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctDB]
        @ContractNumber varchar(11),
        @CustCode varchar(8),
        @BillingType varchar(1),
        @BillingMethod varchar(20)
AS
	/* 10/06/99 - do type conversion and nullif outside of select */
DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CAST(NULLIF(@ContractNumber, '') AS int), 
		@CustCode = NULLIF(@CustCode, ''),
		@BillingType = NULLIF(@BillingType, ''),
		@BillingMethod = NULLIF(@BillingMethod, '')

        SELECT  SUM(cpi.amount) AS amt_billed
          FROM  contract_payment_item AS cpi WITH(NOLOCK)
          JOIN  ar_payment AS ap
            ON  ap.contract_number = cpi.contract_number
           AND  ap.sequence = cpi.sequence
          JOIN  contract_billing_party AS cbp
            ON  cbp.contract_number = ap.contract_number
           AND  cbp.contract_billing_party_id = ap.contract_billing_party_id
         WHERE  cbp.contract_number = @iCtrctNum
           AND  cbp.billing_type = @CustCode
           AND  cbp.billing_method = @BillingType
           AND  cbp.customer_code = @BillingMethod











GO
