USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRentBackRateFeatures]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO














/****** Object:  Stored Procedure dbo.GetRentBackRateFeatures    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRentBackRateFeatures    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRentBackRateFeatures    Script Date: 1/11/99 1:03:16 PM ******/
/* Nov 05 1999 np - replaced  OE.Type = "LDWM" with OE.Type = "LDW" */
CREATE PROCEDURE [dbo].[GetRentBackRateFeatures]  --2742159
	@QuotedRateId Varchar(10)
AS
DECLARE @iRateId Int
DECLARE @OptExtraId SmallInt
DECLARE @LDWIncluded char(1)
DECLARE @LDWDeductible Varchar(10)
DECLARE @PAEIncluded char(1)
DECLARE @PECIncluded char(1)
DECLARE @ELIIncluded char(1)
	SET ROWCOUNT 1
	SELECT 	@iRateId = Convert(Int, NULLIF(@QuotedRateId,"")),
		@LDWIncluded = '0',
		@PAEIncluded = '0',
		@PECIncluded = '0',
		@ELIIncluded = '0'
	/* check if ldw is included */
	SELECT
		@OptExtraId = OE.Optional_Extra_ID, @LDWIncluded = '1'
	FROM
		Quoted_Included_Optional_Extra QIOE,
		Optional_Extra OE
	WHERE
		OE.Optional_Extra_ID = QIOE.Optional_Extra_ID
		And QIOE.Quoted_Rate_Id = @iRateId
		And OE.Delete_Flag = 0
		And OE.Type = "LDW"
	IF @LDWIncluded = '1'
		/* get ldw deductible */
		SELECT
			@LDWDeductible = Convert(Varchar(10), LDW_Deductible)
		FROM
			Quoted_Included_Optional_Extra QIOE
		WHERE
			Optional_Extra_Id = @OptExtraId
			And QIOE.Quoted_Rate_Id = @iRateId
	/* check if pai is included */
	SELECT
		@PAEIncluded = '1'
	FROM
		Quoted_Included_Optional_Extra QIOE,
		Optional_Extra OE
	WHERE
		OE.Optional_Extra_ID = QIOE.Optional_Extra_ID
		And QIOE.Quoted_Rate_Id = @iRateId
		And OE.Delete_Flag = 0
		And OE.Type = "PAE"
	/* check if pec is included */
	SELECT
		@PECIncluded = '1'
	FROM
		Quoted_Included_Optional_Extra QIOE,
		Optional_Extra OE
	WHERE
		OE.Optional_Extra_ID = QIOE.Optional_Extra_ID
		And QIOE.Quoted_Rate_Id = @iRateId
		And OE.Delete_Flag = 0
		And OE.Type = "PEC"
	/* check if ELI is included */
	SELECT
		@ELIIncluded = '1'
	FROM
		Quoted_Included_Optional_Extra QIOE,
		Optional_Extra OE
	WHERE
		OE.Optional_Extra_ID = QIOE.Optional_Extra_ID
		And QIOE.Quoted_Rate_Id = @iRateId
		And OE.Delete_Flag = 0
		And OE.Type = "ELI"

	SELECT 	@LdwIncluded, @LdwDeductible, @PAEIncluded, @PECIncluded, @ELIIncluded
	WHERE @iRateId IS NOT NULL
	RETURN @@ROWCOUNT
















GO
