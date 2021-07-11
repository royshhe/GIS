USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateFeatures]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResRateFeatures    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateFeatures    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateFeatures    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateFeatures    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetResRateFeatures]
	@RateId Varchar(10),
	@CurrDate Varchar(24),
	@VehClassCode Varchar(1)
AS
DECLARE @iRateId Int
DECLARE @dCurrDate Datetime
DECLARe @OptExtraId SmallInt
DECLARE @LdwIncluded Varchar(13)
DECLARE @LdwDeductible Varchar(10)
DECLARE @ThirdPartyIns Varchar(13)
	SET ROWCOUNT 1
	SELECT 	@iRateId = Convert(Int, NULLIF(@RateId,"")),
		@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,"")),
		@LdwIncluded = "Not included",
		@ThirdPartyIns = "Not included",
		@VehClassCode = NULLIF(@VehClassCode,"")
	/* check if ldw is included */
	SELECT	@OptExtraId = A.Optional_Extra_ID, @LdwIncluded = "Included"
	FROM	Included_Optional_Extra B,
		Optional_Extra A
	WHERE	A.Optional_Extra_ID = B.Optional_Extra_ID
	AND	B.Rate_Id = @iRateId
	AND	@dCurrDate BETWEEN B.Effective_Date and B.Termination_Date
	AND	A.Delete_Flag = 0
	AND	A.Type = "LDW"
	IF @LdwIncluded = "Included"
		/* get ldw deductible */
		SELECT	@LdwDeductible = Convert(Varchar(10), Ldw_deductible)
		FROM	LDW_Deductible
		WHERE	Vehicle_Class_Code = @VehClassCode
		AND	Optional_Extra_Id = @OptExtraId
	/* check if 3rd party insurance is included */		
	SELECT 	@ThirdPartyIns = "Included"
	FROM	Included_Optional_Extra B,
		Optional_Extra A
	WHERE	A.Optional_Extra_ID = B.Optional_Extra_ID
	AND	B.Rate_Id = @iRateId
	AND	@dCurrDate BETWEEN B.Effective_Date and B.Termination_Date
	AND	A.Delete_Flag = 0
	AND	A.Type = "TPI"	
	SELECT 	@LdwIncluded, @LdwDeductible, @ThirdPartyIns
	WHERE @iRateId IS NOT NULL
	RETURN @@ROWCOUNT













GO
