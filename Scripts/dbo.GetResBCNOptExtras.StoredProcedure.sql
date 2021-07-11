USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResBCNOptExtras]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO











CREATE PROCEDURE [dbo].[GetResBCNOptExtras]
	@VehClassCode Varchar(1),
	@CurrentDate Varchar(24),
	@LDW Char(1),
	@PAI Char(1),
	@PEC Char(1)
AS
DECLARE @CurrDatetime 	Datetime,	@LastDatetime 	Datetime,
	@LDWOptExtra   	Varchar(35), 	@LDWOptExtraId 	SmallInt,
	@LDWDailyRate  	Decimal(7,2), 	@LDWWeeklyRate 	Decimal(7,2),
	@LDWDeduct  	Varchar(10), 	@LDWOptExtraType Varchar(20),
	@LDWMaxQty 	SmallInt,
	@PAIOptExtra  	Varchar(35), 	@PAIOptExtraId 	SmallInt,
	@PAIDailyRate  	Decimal(7,2), 	@PAIWeeklyRate 	Decimal(7,2),
	@PAIOptExtraType Varchar(20), 	@PAIMaxQty 	SmallInt,
	@PECOptExtra   	Varchar(35), 	@PECOptExtraId 	SmallInt,
	@PECDailyRate  	Decimal(7,2), 	@PECWeeklyRate 	Decimal(7,2),
	@PECOptExtraType Varchar(20), 	@PECMaxQty 	SmallInt

	/* 2/23/99 - cpy bug fix - LDW not returning */
	/* 2/24/99 - cpy bug fix - return only 1 row of each type (ldw,pai,pec) */

	SELECT 	@VehClassCode = NULLIF(@VehClassCode,""),
		@CurrDatetime = Convert(Datetime, NULLIF(@CurrentDate, "")),
		@LastDatetime = Convert(Datetime, "31 Dec 2078 23:59")

	SET ROWCOUNT 1

	-- Get LDW with lowest deductible for this class
	SELECT	@LDWOptExtra = A.Optional_Extra,
		@LDWOptExtraId = A.Optional_Extra_ID,
		@LDWDailyRate = B.Daily_Rate,
		@LDWWeeklyRate = B.Weekly_Rate,
		@LDWDeduct = CONVERT(Varchar(10), C.LDW_Deductible),
		@LDWOptExtraType = A.Type,
		@LDWMaxQty = A.Maximum_Quantity
	FROM	LDW_Deductible C,
		Optional_Extra_Price B,
		Optional_Extra A
	WHERE	B.Optional_Extra_ID = C.Optional_Extra_ID
	AND	A.Optional_Extra_ID = B.Optional_Extra_ID
	AND	A.Delete_Flag = 0
	AND	@CurrDatetime BETWEEN B.Optional_Extra_Valid_From
		    AND ISNULL(B.Valid_To, @LastDatetime)
	AND	C.Vehicle_Class_Code = @VehClassCode
	AND	A.Type = 'LDW'
	AND	Convert(Bit, @LDW) = 1
	ORDER BY C.LDW_Deductible
	
	-- Get PAI; if > 1 PAI defined, get the one with lowest opt extra id
	SELECT	@PAIOptExtra = A.Optional_Extra,
		@PAIOptExtraId = A.Optional_Extra_ID,
		@PAIDailyRate = B.Daily_Rate,
		@PAIWeeklyRate = B.Weekly_Rate,
		@PAIOptExtraType = A.Type,
		@PAIMaxQty = A.Maximum_Quantity
	FROM	Optional_Extra_Price B,
		Optional_Extra A
	WHERE	A.Optional_Extra_ID = B.Optional_Extra_ID
	AND	A.Delete_Flag = 0
	AND	@CurrDatetime BETWEEN B.Optional_Extra_Valid_From
		   AND ISNULL(B.Valid_To, @LastDatetime)
	AND	A.Type = 'PAI'
	AND	Convert(Bit, @PAI) = 1
	ORDER BY A.Optional_Extra_Id

	-- Get PEC; if > 1 PEC defined, get the one with lowest opt extra id
	SELECT	@PECOptExtra = A.Optional_Extra,
		@PECOptExtraId = A.Optional_Extra_ID,
		@PECDailyRate = B.Daily_Rate,
		@PECWeeklyRate = B.Weekly_Rate,
		@PECOptExtraType = A.Type,
		@PECMaxQty = A.Maximum_Quantity
	FROM	Optional_Extra_Price B,
		Optional_Extra A
	WHERE	A.Optional_Extra_ID = B.Optional_Extra_ID
	AND	A.Delete_Flag = 0
	AND	@CurrDatetime BETWEEN B.Optional_Extra_Valid_From
		    AND ISNULL(B.Valid_To, @LastDatetime)
	AND	A.Type = 'PEC'
	AND	Convert(Bit, @PEC) = 1
	ORDER BY A.Optional_Extra_Id

	SET ROWCOUNT 0

	SELECT	@LDWOptExtra, @LDWOptExtraId, @LDWDailyRate, @LDWWeeklyRate,
		"1", "", @LDWDeduct, @LDWOptExtraType, @LDWMaxQty
	WHERE	@LDWOptExtraId IS NOT NULL
	UNION ALL
	SELECT	@PAIOptExtra, @PAIOptExtraId, @PAIDailyRate, @PAIWeeklyRate,
		"1", "", "", @PAIOptExtraType, @PAIMaxQty
	WHERE 	@PAIOptExtraId IS NOT NULL
	UNION ALL
	SELECT	@PECOptExtra, @PECOptExtraId, @PECDailyRate, @PECWeeklyRate,
		"1", "", "", @PECOptExtraType , @PECMaxQty
	WHERE	@PECOptExtraId IS NOT NULL

	RETURN @@ROWCOUNT





















GO
