USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsMaestroRateSource]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To check if the given rate id is a Maestro rate.
	        If so return rowcount and 0 otherwise.
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[IsMaestroRateSource] -- '1473369'
	@QuotedRateID	VarChar(10)
AS
	Declare	@nQuotedRateID Integer
	Select		@nQuotedRateID = CONVERT(Int, NULLIF(@QuotedRateID, ''))

	SELECT	Count(*)

	FROM		Quoted_Vehicle_Rate

	WHERE	Quoted_Rate_Id = @nQuotedRateID
	AND		(Rate_Source = 'Maestro' )
	--AND		(Rate_Source = 'Maestro' or Rate_Source = 'BCDMatrix')

RETURN 1

--select * from reservation where confirmation_Number=1655397
--
--select * from Quoted_Vehicle_Rate where Quoted_Rate_Id='1473369'
--SELECT	Count(*)
--
--	FROM		Quoted_Vehicle_Rate
--
--	WHERE	Quoted_Rate_Id = '1473369'
--	AND		Rate_Source = 'Maestro' or Rate_Source = 'BCDMatrix'
GO
