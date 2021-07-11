USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateKMCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetNonGISRateKMCharge    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateKMCharge    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateKMCharge    Script Date: 1/11/99 1:03:16 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetNonGISRateKMCharge]
	@QuotedRateId Varchar(10)
AS
	DECLARE	@nQuotedRateId Integer
	SELECT	@nQuotedRateId = Convert(Int, NULLIF(@QuotedRateId,""))

	SELECT
		Per_KM_Charge
	FROM
		Quoted_Vehicle_Rate
	WHERE
		Quoted_Rate_ID = @nQuotedRateId
	RETURN @@ROWCOUNT













GO
