USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerCode]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCustomerCode    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetCustomerCode    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve the customer code for the given parameters.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustomerCode]
@ContractNumber varchar(35),
@BillingPartyID varchar(35)
AS
DECLARE	 @nContractNumber Integer
DECLARE	@nBillingPartyID Integer

SELECT	@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))
SELECT	@nBillingPartyID = CONVERT(Int, NULLIF(@BillingPartyID, ''))

SELECT	DISTINCT Customer_Code
FROM	Contract_Billing_Party
WHERE	Contract_Number = @nContractNumber
AND	Contract_Billing_Party_ID = @nBillingPartyID
Return 1














GO
