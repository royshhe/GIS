USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintCheckAuthExist]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*  PURPOSE:		if comparetype = 0,
			return 0 if there does NOT exist a CC authorization
			that was authorized BEFORE CompareDate; else
			return 1 if CC authorization is BEFORE comparedate

			if comparetype = 1,
			return 0 if there does NOT exist a CC authorization
			that was collected on AFTER CompareDate; else
			return 1 if CC authorization is AFTER comparedate 
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintCheckAuthExist]
	@ContractNum Varchar(10),
	@CompareDate Varchar(24),
	@CCKey 	     Varchar(10),
	@CompareType Varchar(1)		-- 0 = before, 1 = after
AS
--Standard settings (DO NOT EDIT!)
DECLARE @iContractNum Int,
	@dCompareDate Datetime,
	@iReturnVal Int,
	@iOwningCompId Int,
	@iCCKey Int

	/* 2/27/99 - cpy created - if comparetype = 0,
			return 0 if there does NOT exist a CC authorization
			that was authorized BEFORE CompareDate; else
			return 1 if CC authorization is BEFORE comparedate

		- if comparetype = 1,
			return 0 if there does NOT exist a CC authorization
			that was collected on AFTER CompareDate; else
			return 1 if CC authorization is AFTER comparedate  */

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
		FROM	Location L,
			Credit_Card_Authorization CCA
		WHERE	CCA.Contract_Number = @iContractNum
		AND	CCA.Authorized_On <= @dCompareDate
		AND	CCA.Authorized_At_Location_Id = L.Location_Id
		AND	CCA.Credit_Card_Key = @iCCKey
		AND	L.Owning_Company_Id = @iOwningCompId
	END
	ELSE
	BEGIN
		SELECT	@iReturnVal = 1
		FROM	Location L,
			Credit_Card_Authorization CCA
		WHERE	CCA.Contract_Number = @iContractNum
		AND	CCA.Authorized_On > @dCompareDate
		AND	CCA.Authorized_At_Location_Id = L.Location_Id
		AND	CCA.Credit_Card_Key = @iCCKey
		AND	L.Owning_Company_Id = @iOwningCompId
	END
		
	RETURN @iReturnVal
GO
