USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintCheckPaymentExist]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*  PURPOSE:		if comparetype = 0,
			return 0 if there does NOT exist a contract payment
			that was collected on BEFORE CompareDate; else
			return 1 if a payment collected BEFORE comparedate exists

			if comparetype = 1,
			return 0 if there does NOT exist a contract payment
			that was collected on AFTER CompareDate; else
			return 1 if a payment collected AFTER comparedate exists 
     MOD HISTORY:
     Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetCtrctPrintCheckPaymentExist]
	@ContractNum Varchar(10),
	@CompareDate Varchar(24),
	@CCKey       Varchar(10),
	@CompareType Varchar(1)		-- 0 = before, 1 = after
AS
DECLARE @iContractNum Int,
	@dCompareDate Datetime,
	@iReturnVal Int,
	@iOwningCompId Int,
	@iCCKey Int

	/* 2/27/99 - cpy created - if comparetype = 0,
			return 0 if there does NOT exist a contract payment
			that was collected on BEFORE CompareDate; else
			return 1 if a payment collected BEFORE comparedate exists

		- if comparetype = 1,
			return 0 if there does NOT exist a contract payment
			that was collected on AFTER CompareDate; else
			return 1 if a payment collected AFTER comparedate exists */

	/* 3/30/99 - cpy modified - added CC Key param */

		/* this function used by SP GetCtrctPrintSignature Box */

	SELECT	@iContractNum = Convert(int, NULLIF(@ContractNum,'')),
		@dCompareDate = Convert(Datetime, NULLIF(@CompareDate,'')),
		@iCCKey = Convert(Int, NULLIF(@CCKey,'')),
		@iReturnVal = 0		-- by default

	SELECT	@iOwningCompId = Convert(Int, Code)
	FROM	Lookup_Table
	WHERE	Category = 'BudgetBC Company'

	IF @CompareType = "0"
	BEGIN
		SELECT	@iReturnVal = 1
		FROM	Credit_Card_Payment CCP,
			Location L,
			Contract_Payment_Item CPI
		WHERE	CCP.Contract_Number = CPI.Contract_Number
		AND	CCP.Sequence = CPI.Sequence
		AND	CCP.Credit_Card_Key = @iCCKey
		AND	CPI.Contract_Number = @iContractNum
		AND	CPI.Collected_On <= @dCompareDate
		AND	CPI.Collected_At_Location_Id = L.Location_Id
		AND	L.Owning_Company_Id = @iOwningCompId
	END
	ELSE
	BEGIN
		SELECT	@iReturnVal = 1
		FROM	Credit_Card_Payment CCP,
			Location L,
			Contract_Payment_Item CPI
		WHERE	CCP.Contract_Number = CPI.Contract_Number
		AND	CCP.Sequence = CPI.Sequence
		AND	CCP.Credit_Card_Key = @iCCKey
		AND	CPI.Contract_Number = @iContractNum
		AND	CPI.Collected_On > @dCompareDate
		AND	CPI.Collected_At_Location_Id = L.Location_Id
		AND	L.Owning_Company_Id = @iOwningCompId
	END
		
	RETURN @iReturnVal


















GO
