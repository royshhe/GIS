USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateInclusion]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetNonGISRateInclusion    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateInclusion    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateInclusion    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetNonGISRateInclusion]
	@QuotedRateId Varchar(10)
AS
DECLARE @iRateId 	Integer
DECLARE @GST 	Bit
DECLARE @PST 	Bit
DECLARE @PVRT 	Bit
DECLARE @LocFee Bit
DECLARE @LicFee	Bit
DECLARE @ERF	Bit

	SELECT 	@iRateId = Convert(Int, NULLIF(@QuotedRateId,""))
	-- Get all Flags
	SELECT 	@GST = GST_Included, @PST = PST_Included,
		@PVRT = PVRT_Included, @LocFee = Location_Fee_Included,
		@LicFee = License_Fee_Included,
		@ERF= ISNULL(License_Fee_Included, 0)

	FROM	Quoted_Vehicle_Rate
	WHERE	Quoted_Rate_Id = @iRateId
	-- Get Included Optional Extras (non-OTHER eg. LDW)
	SELECT 	OE.Optional_Extra
	FROM	Optional_Extra OE,
		Quoted_Included_Optional_Extra QIOE
	WHERE	QIOE.Optional_Extra_ID = OE.Optional_Extra_ID
	AND	OE.Type <> "OTHER"
	AND	OE.Delete_Flag = 0
	AND	QIOE.Quoted_Rate_ID = @iRateId
	UNION ALL
	-- Get all OTHER Included Optional Extras
	SELECT 	OE.Optional_Extra + " (" + Convert(Varchar, QIOE.Quantity) + ")"
	FROM	Optional_Extra OE,
		Quoted_Included_Optional_Extra QIOE
	WHERE	QIOE.Optional_Extra_ID = OE.Optional_Extra_ID
	AND	OE.Type = "OTHER"
	AND	OE.Delete_Flag = 0
	AND	QIOE.Quoted_Rate_ID = @iRateId

	UNION ALL
	( SELECT 	"GST included"
	  WHERE	@GST = 1
	  UNION ALL
	  SELECT	"PST included"
	  WHERE 	@PST = 1
	  UNION ALL
	  SELECT	"PVRT included"
	  WHERE	@PVRT = 1
	  UNION ALL
	  SELECT	"Location Fee included"
	  WHERE	@LocFee = 1 
	  UNION ALL
	  SELECT	"License Fee Included"
	  WHERE	@LicFee =1
	  UNION ALL
	  SELECT	 "ERF Included"
	  WHERE	@ERF =1)
	RETURN @@ROWCOUNT
GO
