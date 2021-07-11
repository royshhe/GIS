USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRentBackRateInclusion]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRentBackRateInclusion    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRentBackRateInclusion    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRentBackRateInclusion    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetRentBackRateInclusion]
	@QuotedRateId Varchar(10)
AS
DECLARE @iRateId 	Integer
	SELECT 	@iRateId = Convert(Int, NULLIF(@QuotedRateId,""))
	-- Get all OTHER Included Optional Extras
	SELECT 	OE.Optional_Extra + " (" + Convert(Varchar, QIOE.Quantity) + ")"
	FROM	Optional_Extra OE,
		Quoted_Included_Optional_Extra QIOE
	WHERE	QIOE.Optional_Extra_ID = OE.Optional_Extra_ID
	AND	OE.Type = "OTHER"
	AND	OE.Delete_Flag = 0
	AND	QIOE.Quoted_Rate_ID = @iRateId
	RETURN @@ROWCOUNT












GO
