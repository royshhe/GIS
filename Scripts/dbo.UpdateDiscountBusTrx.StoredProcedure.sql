USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDiscountBusTrx]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: To update the Contract_Reimbur_And_Discount table and set all the business
	transaction ids for a contract
AUTHOR: Don Kirkby
DATE CREATED: Jul 6, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateDiscountBusTrx]
@ContractNumber varchar(11),
@BusTrxID	varchar(11)

AS
Declare	@nContractNumber Integer
Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
Update
	Contract_Reimbur_And_Discount
Set
	Business_Transaction_ID = Convert(int, NULLIF(@BusTrxID, ''))
Where
	Contract_Number = @nContractNumber

















GO
