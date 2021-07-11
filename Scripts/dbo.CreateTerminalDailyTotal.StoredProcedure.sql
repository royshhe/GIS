USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTerminalDailyTotal]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: CreateTerminalDailyTotal
PURPOSE: To insert a record into Terminal_Daily_Total table.
AUTHOR: Dan McMechan?
DATE CREATED: ?
CALLED BY: Eigen
MOD HISTORY:
Name    Date        	Comments
Don K	Apr 5 1999	Changed to look for last RBR date that's _closed_.
			Use Eigen Codes on Credit Card Types.
Don K	Apr 8 1999	Changed Terminal_Daily_Total to store Eigen's Credit Card code.
Don K	Oct 25 1999	Let you specify the RBR date to use.
*/
CREATE PROCEDURE [dbo].[CreateTerminalDailyTotal]
	@TerminalID Varchar(20),
	@EigenCCTCode Varchar(20),
	@EigenPurchaseAmount Varchar(20),
	@EigenPurchaseCount Varchar(20),
	@EigenReturnAmount Varchar(20),
	@EigenReturnCount Varchar(20),
	@BudgetPurchaseAmount Varchar(20),
	@BudgetReturnAmount Varchar(20),
	@BudgetPurchaseCount Varchar(20),
	@BudgetReturnCount Varchar(20),
	@RBRDate varchar(24)
AS
Declare @thisRBRDate datetime

IF @RBRDate = ''
	Select @thisRBRDate =
		(Select
			Max(RBR_Date)
		From
			RBR_Date
		Where
			Budget_Close_Datetime IS NOT NULL)
ELSE
	SELECT	@thisRBRDate = CAST(@RBRDate AS datetime)

INSERT INTO Terminal_Daily_Total
	(
	Terminal_ID,
	RBR_Date,
	Eigen_CCT_Code,
	Eigen_Purchase_Amount,
	Eigen_Purchase_Count,
	Budget_Purchase_Amount,
	Budget_Purchase_Count,
	Eigen_Return_Amount,
	Eigen_Return_Count,
	Budget_Return_Amount,
	Budget_Return_Count)
VALUES	(
	@TerminalID,
	@thisRBRDate,
	@EigenCCTCode,
	Convert(decimal(9,2), NULLIF(@EigenPurchaseAmount, "")),
	Convert(int, NULLIF(@EigenPurchaseCount, "")),
	Convert(decimal(9,2), NULLIF(@BudgetPurchaseAmount, "")),
	Convert(int, NULLIF(@BudgetPurchaseCount, "")),
	Convert(decimal(9,2), NULLIF(@EigenReturnAmount, "")),
	Convert(int, NULLIF(@EigenReturnCount, "")),
	Convert(decimal(9,2), NULLIF(@BudgetReturnAmount, "")),
	Convert(int, NULLIF(@BudgetReturnCount, ""))
	)
RETURN 1












GO
