USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateInclusion]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/****** Object:  Stored Procedure dbo.GetResRateInclusion    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateInclusion    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetResRateInclusion]
	@RateId Varchar(10),
	@CurrDate Varchar(24)
AS
DECLARE @iRateId 	Integer
DECLARE @dCurrDate 	Datetime
DECLARE @GST 	Bit
DECLARE @PST 	Bit
DECLARE @PVRT 	Bit
DECLARE @LocFee Bit
DECLARE @FPO	Bit
DECLARE @ERF    Bit
DECLARE @LicFee	Bit
DECLARE @CFC    Bit

	/* 6/17/99 - added optional extra id and type columns */

	/* 981110 - cpy - modified to remove use of temp table */
	SELECT 	@iRateId = Convert(Int, NULLIF(@RateId,"")),
 		@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,""))

	-- Get all Flags
	SELECT 	@GST = GST_Included, @PST = PST_Included,
		@PVRT = PVRT_Included, @LocFee = Location_Fee_Included,
		@FPO = FPO_Purchased,  @LicFee = License_Fee_Included,
		@ERF = ERF_Included, @CFC=CFC_Included
	FROM	Vehicle_Rate
	WHERE	Rate_Id = @iRateId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date

	-- Get Included Optional Extras (non-OTHER eg. LDW)
	SELECT 	A.Optional_Extra,
		A.Optional_Extra_Id, A.Type
	FROM	Optional_Extra A,
		Included_Optional_Extra B
	WHERE	B.Optional_Extra_ID = A.Optional_Extra_ID
	AND	A.Type <> "OTHER"
	-- AND	A.Type <> 'TPI'		-- 2/25/99 - cpy bug fix
	AND	A.Delete_Flag = 0
	AND	B.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN B.Effective_Date AND B.Termination_Date

	UNION ALL

	-- Get all OTHER Included Optional Extras
	SELECT 	A.Optional_Extra + " (" + Convert(Varchar, B.Quantity) + ")",
		A.Optional_Extra_Id, A.Type
	FROM	Optional_Extra A,
		Included_Optional_Extra B
	WHERE	B.Optional_Extra_ID = A.Optional_Extra_ID
	AND	A.Type = "OTHER"
	AND	A.Delete_Flag = 0
	AND	B.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN B.Effective_Date AND B.Termination_Date

	UNION ALL
		
	-- Get all Included Sales Accessories
	SELECT 	A.Sales_Accessory + " (" + Convert(Varchar, B.Quantity) + ")",
		null, null
	FROM	Sales_Accessory A,
		Included_Sales_Accessory B
	WHERE	B.Sales_Accessory_ID = A.Sales_Accessory_ID
	AND	A.Delete_Flag = 0
	AND	B.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN B.Effective_Date AND B.Termination_Date

	UNION ALL

	( SELECT 	"GST Included", null, null
	  WHERE	@GST = 1
	  UNION ALL
	  SELECT	"PST Included", null, null
	  WHERE 	@PST = 1
	  UNION ALL
	  SELECT	"PVRT Included", null, null
	  WHERE	@PVRT = 1
	  UNION ALL
	  SELECT	"Location Fee Included", null, null
	  WHERE	@LocFee = 1
	  UNION ALL
	  SELECT	"FPO Included", null, null
	  WHERE @FPO = 1 
	  UNION ALL
	  SELECT	"ERF Included", null, null
	  WHERE @ERF = 1 
	  UNION ALL
	  SELECT	"CFC Included", null, null
	  WHERE @CFC = 1 
	  UNION ALL
	  SELECT	"License Fee Included", null, null
	  WHERE	@LicFee = 1)

	RETURN @@ROWCOUNT






SET ANSI_NULLS ON
GO
