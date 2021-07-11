USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateDirectBillAuth]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: CreateDirectBillAuth
PURPOSE: To create or update a Contract_Billing_Party
AUTHOR: Dan McMechan?
DATE CREATED: ?
CALLED BY: Contract
REQUIRES:
MOD HISTORY:
Name    Date        Comments
Don K	Apr 6 1999  Added @IsAdjustment
NP	Aug 24 1999 Added @InterimBillAmount
*/
CREATE PROCEDURE [dbo].[CreateDirectBillAuth]
	@ContractNumber 	varchar(20),
	@OrgID 		varchar(20),
	@Amount 		varchar(20),
	@ProcessedBy 		varchar(20),
	@BillingType 		varchar(20),
	@BillingMethod 		varchar(20),
	@IsAdjustment 		varchar(1), -- must be '0' or '1'
	@InterimBillAmount	VarChar(20)
AS
Declare @thisCreditRemoved decimal(9,2)
Declare @BillingPartyID int

Select @BillingPartyID =
	(Select
		Contract_Billing_Party_ID
	From
		Contract_Billing_Party
	Where
		Contract_Number = Convert(int, @ContractNumber)
		And Billing_Type = @BillingType
		And Billing_Method = @BillingMethod
		And Customer_Code = @OrgID)

Select @thisCreditRemoved =
	(Select
		Amt_Removed_From_Avail_Credit
	From
		Contract_Billing_Party
	Where
		Contract_Number = Convert(int, @ContractNumber)
		And Contract_Billing_Party_ID = @BillingPartyID)

If @thisCreditRemoved IS Null
	Select @thisCreditRemoved = 0

Update
	Contract_Billing_Party
Set
	-- When check in  Interim bill contract, @Amount is the outstanding balance not the total bill
             --note that null+decimal=null , following syntax may be a bug somehow. fixed on feb 14 2005
	Amt_Removed_From_Avail_Credit = isnull(Convert(decimal(9,2), NULLIF(@Amount, '')),0.0) +isnull( Convert(decimal(9,2), NULLIF(@InterimBillAmount, '')), 0.0)
Where
	Contract_Number = Convert(int, @ContractNumber)
	And Contract_Billing_Party_ID = @BillingPartyID

IF CAST(@IsAdjustment AS bit) = 0
	Update
		AR_Credit_Authorization
	Set
		Expected_Open_Contract_Charges =
		Expected_Open_Contract_Charges + Convert(decimal(9,2), @Amount) - (@thisCreditRemoved - isnull(Convert(decimal(9,2), NULLIF(@InterimBillAmount, '')),0.0) )
	Where
		Customer_Code = @OrgID
ELSE
	-- This is because @Amount = Outstanding Balance for @Billingtype = 'p' and @Amount = Outstanding Balance - Original Balance  for @Billingtype <> 'p'
	IF @Billingtype = 'p'
		Update
			AR_Credit_Authorization
		Set
			Daily_Contract_Total =
			Daily_Contract_Total + Convert(decimal(9,2), @Amount) - @thisCreditRemoved
	--		Daily_Contract_Total + Convert(decimal(9,2), @Amount)
		Where
			Customer_Code = @OrgID
	ELSE
		Update
			AR_Credit_Authorization
		Set
			Daily_Contract_Total =
	--		Daily_Contract_Total + Convert(decimal(9,2), @Amount) - @thisCreditRemoved
			Daily_Contract_Total + Convert(decimal(9,2), @Amount)
		Where
			Customer_Code = @OrgID
Return 1
GO
