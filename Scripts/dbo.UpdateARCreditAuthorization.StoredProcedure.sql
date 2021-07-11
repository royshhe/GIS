USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateARCreditAuthorization]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.UpdateARCreditAuthorization    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateARCreditAuthorization    Script Date: 2/16/99 2:05:43 PM ******/
/*
PURPOSE: To update a record in AR_Credit_Authorization table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateARCreditAuthorization]
@ContractNumber varchar(35),
@BillingPartyID varchar(35),
@Amount varchar(24)
AS
DECLARE	@CustomerCode VarChar(8)
Declare	@nContractNumber Integer
Declare	@nBillingPartyID Integer

Select		@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))
Select		@nBillingPartyID = CONVERT(Int, NULLIF(@BillingPartyID, ''))
Select		@CustomerCode = NULLIF(@CustomerCode, '')

-- Get The Customer Code
SELECT	@CustomerCode = Customer_Code
FROM	Contract_Billing_Party
WHERE	Contract_Number = @nContractNumber
AND	Contract_Billing_Party_ID = @nBillingPartyID

-- Updating the AR Credit Authorization
UPDATE	AR_Credit_Authorization
SET	Daily_Contract_Total = Daily_Contract_Total + CONVERT(Decimal(9,2), NULLIF(@Amount, '')),
	Expected_Open_Contract_Charges = Expected_Open_Contract_Charges - CONVERT(Decimal(9,2), NULLIF(@Amount, ''))
WHERE	Customer_Code = @CustomerCode

Return 1




GO
