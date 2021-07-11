USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllDirBillAuths]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetAllDirBillAuths
PURPOSE: To retrieve all direct bill billing parties for a contract.
AUTHOR: ?
DATE CREATED: ?
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
Don K   Apr 12 1999 Added Billing Type
Don K   May 4 1999  Renamed from GetAllDirBillDepositsRefunds and removed
		    unused fields
*/
CREATE PROCEDURE [dbo].[GetAllDirBillAuths]
@ContractNumber Varchar(10)
AS
Select
	CBP.Customer_Code,
	CBP.Billing_Method,
	CBP.Billing_Type
From
	Contract_Billing_Party CBP
Where
	CBP.Contract_Number = Convert(int, @ContractNumber)
	And CBP.Billing_Method In ('Direct Bill', 'Loss Of Use', 'Voucher')
RETURN 1















GO
