USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedOptExtraQuantity]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetIncludedOptExtraQuantity    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetIncludedOptExtraQuantity    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetIncludedOptExtraQuantity]
	@OptionalExtraID	VarChar(10),
	@RateID			VarChar(10),
	@RateAssignedDate	VarChar(24)
AS
	DECLARE	@dRateAssignedDate DateTime
	DECLARE 	@nOptionalExtraID SmallInt
	DECLARE	@nRateID Integer
	
	SELECT	@dRateAssignedDate = CONVERT(DateTime, NULLIF(@RateAssignedDate, ''))
	SELECT	@nOptionalExtraID = CONVERT(SmallInt, NULLIF(@OptionalExtraID, ''))
	SELECT	@nRateID = CONVERT(Int, NULLIF(@RateID, ''))

	SELECT	DISTINCT Quantity
	FROM	Included_Optional_Extra
	WHERE	Optional_Extra_ID = @nOptionalExtraID
	AND		Rate_ID = @nRateID
	AND		@dRateAssignedDate BETWEEN Effective_Date AND ISNULL(Termination_Date, CONVERT(DateTime, '2078 Dec 31 23:59'))

RETURN @@ROWCOUNT















GO
