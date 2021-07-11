USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateFeatures]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetNonGISRateFeatures    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateFeatures    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateFeatures    Script Date: 1/11/99 1:03:16 PM ******/

/* Don K - Mar 15 1999 - Restricted LDW deductible query to qrate_id. */
/* Nov 05 1999 np - replaced  OE.Type = "LDWM" with OE.Type = "LDW" */
CREATE PROCEDURE [dbo].[GetNonGISRateFeatures]
	@QuotedRateId Varchar(10)
AS
DECLARE @iRateId Int
DECLARE @OptExtraId SmallInt
DECLARE @LdwIncluded Varchar(13)
DECLARE @LdwDeductible Varchar(10)
DECLARE @ThirdPartyIns Varchar(13)
	SET ROWCOUNT 1
	SELECT 	@iRateId = Convert(Int, NULLIF(@QuotedRateId,"")),
		@LdwIncluded = "Not included",
		@ThirdPartyIns = "Not included"
	/* check if ldw is included */
	SELECT
		@OptExtraId = OE.Optional_Extra_ID, @LdwIncluded = "Included"
	FROM
		Quoted_Included_Optional_Extra QIOE,
		Optional_Extra OE
	WHERE
		OE.Optional_Extra_ID = QIOE.Optional_Extra_ID
		AND	QIOE.Quoted_Rate_Id = @iRateId
		AND	OE.Delete_Flag = 0
		AND	OE.Type = "LDW"
	IF @LdwIncluded = "Included"
		/* get ldw deductible */
		SELECT
			@LdwDeductible = Convert(Varchar(10), Ldw_deductible)
		FROM
			Quoted_Included_Optional_Extra QIOE
		WHERE
			Optional_Extra_Id = @OptExtraId
		AND QIOE.Quoted_Rate_Id = @iRateId
	/* check if 3rd party insurance is included */		
	SELECT
		@ThirdPartyIns = "Included"
	FROM	
		Quoted_Included_Optional_Extra QIOE,
		Optional_Extra OE
	WHERE
		OE.Optional_Extra_ID = QIOE.Optional_Extra_ID
		AND QIOE.Quoted_Rate_Id = @iRateId
		AND OE.Delete_Flag = 0
		AND OE.Type = "TPI"	
	SELECT 	@LdwIncluded, @LdwDeductible, @ThirdPartyIns
	WHERE @iRateId IS NOT NULL
	RETURN @@ROWCOUNT














GO
