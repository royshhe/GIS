USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTaxRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PROCEDURE NAME: CreateAcctgGL
PURPOSE: To summarize the Sales Journal for an RBR date
REQUIRES: CreateAcctgBT has already been called for this RBR date.
AUTHOR: Don Kirkby
DATE CREATED: Dec 23, 1998
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Jan 5 1999  Changed from a retrieve to an insert
Don K	Apr 23 1999 Don't export twice for the same rbr date.
Don K	Jun 21 1999 Exclude unbalanced transactions
Don K	Aug 3 1999  Use business_transaction_export table
*/
create PROCEDURE [dbo].[CreateTaxRate]
	@Valid_From varchar(40),
	@Valid_To varchar(40),
	@Tax_Type varchar(5),
    @Tax_Rate varchar(15),
	@Rate_Type varchar(10),
	@Last_Changed_By varchar(20),
	@Payables_Clearing_Account varchar(20)
AS
	INSERT
	  INTO	Tax_Rate
		(Valid_From,
		 Valid_To,
		 Tax_Type,
		 Tax_Rate,
         Rate_Type,
         Last_Changed_By,
         Last_Changed_On,
         Payables_Clearing_Account
		)
	  VALUES
        (convert(datetime, @Valid_From),
		 convert(datetime, @Valid_To),
		 @Tax_Type,
		 convert(decimal(7,4), @Tax_Rate),
		 @Rate_Type,
		 @Last_Changed_By,
		 getdate(),
		 @Payables_Clearing_Account
         )
 Return 1
GO
