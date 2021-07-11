USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateIncluded]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--exec GetRateIncluded '24383', '3/21/2011 1:29:22 PM'


/****** Object:  Stored Procedure dbo.GetRateIncluded    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateIncluded    Script Date: 2/16/99 2:05:42 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRateIncluded] --'5643', '2009-09-25'
	@RateId Varchar(10),
	@CurrDate Varchar(24)
AS
	/* used in interim bill and contract print */

	DECLARE	@nRateId Integer
	DECLARE	@dCurrDate DateTime

	SELECT	@nRateId = Convert(Int, NULLIF(@RateId,''))
	SELECT	@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,''))

	-- Get all Flags
	SELECT 	CONVERT(Char(1), GST_Included),
		CONVERT(Char(1), PST_Included),
		CONVERT(Char(1), PVRT_Included),
		CONVERT(Char(1), Location_Fee_Included),
		CONVERT(Char(1), Flex_Discount_Allowed),
		CONVERT(Char(1), Discount_Allowed),
		CONVERT(Char(1), License_Fee_Included),
	    CONVERT(Char(1),  FPO_Purchased),
		CONVERT(Char(1), isnull(ERF_Included,0))
	FROM	Vehicle_Rate
	WHERE	Rate_Id = @nRateId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date
	RETURN @@ROWCOUNT



--select * from Vehicle_rate
GO
