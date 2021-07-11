USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllInterimBillPayments]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetAllInterimBillPayments
PURPOSE: To retrieve interim bill payments for a contract
AUTHOR: Niem Phan
DATE CREATED: ?
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
Don K	May 31 1999 Stopped excluding Payment_Type 'A/R'
*/
CREATE PROCEDURE [dbo].[GetAllInterimBillPayments]
@ContractNum Varchar(10)
AS
SELECT
	CPI.Amount
FROM
	Contract_Payment_Item CPI, AR_Payment ARP
WHERE
	CPI.Contract_Number = Convert(int, @ContractNum)
	And CPI.Contract_Number = ARP.Contract_Number
	And CPI.Sequence = ARP.Sequence
	And ARP.Interim_Bill_Date IS NOT NULL
RETURN 1














GO
