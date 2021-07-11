USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptExtraPriceOverlapCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOptExtraPriceOverlapCount    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraPriceOverlapCount    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraPriceOverlapCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraPriceOverlapCount    Script Date: 11/23/98 3:55:33 PM ******/
/* 18/Oct/99 - Modified: Removed conversion to date part only before compare */

CREATE PROCEDURE [dbo].[GetOptExtraPriceOverlapCount]
	@OptionalExtraID	VarChar(20),
	@ValidFrom		VarChar(24),	
	@OldValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@MaxSmallDate		VarChar(24)
AS
	If @ValidTo = ''
		Select @ValidTo = @MaxSmallDate
	
	SELECT	Count(*)
	FROM	Optional_Extra_Price OEP

	WHERE	OEP.Optional_Extra_ID = CONVERT(SmallInt, @OptionalExtraID)
	AND	Optional_Extra_Valid_From <> CONVERT(DateTime, @OldValidFrom)
	AND	(
			(
			OEP.Optional_Extra_Valid_From >= CONVERT(DateTime, @ValidFrom)
		  AND	OEP.Optional_Extra_Valid_From <= CONVERT(DateTime, @ValidTo)
			)
		OR	
			(
			OEP.Valid_To >= CONVERT(DateTime, @ValidFrom)
		  AND	OEP.Valid_To <= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			OEP.Optional_Extra_Valid_From <= CONVERT(DateTime, @ValidFrom)
		  AND	OEP.Valid_To >= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			OEP.Optional_Extra_Valid_From <= CONVERT(DateTime, @ValidFrom)
		  AND	OEP.Valid_To Is Null
			)
		)
RETURN 1














GO
