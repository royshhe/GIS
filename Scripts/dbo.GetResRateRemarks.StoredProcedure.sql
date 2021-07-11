USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateRemarks]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResRateRemarks    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateRemarks    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateRemarks    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateRemarks    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetResRateRemarks]
	@RateId Varchar(10),
	@CurrDatetime Varchar(24)
AS
	DECLARE	@nRateId Integer
	DECLARE	@dCurrDatetime Datetime

	SELECT	@nRateId = Convert(Int, NULLIF(@RateId,""))
	SELECT	@dCurrDatetime = Convert(Datetime, NULLIF(@CurrDatetime,""))

	SELECT 	Other_Remarks, Contract_Remarks
	FROM	Vehicle_Rate
	WHERE	Rate_Id = @nRateId
	AND	@dCurrDatetime
			BETWEEN Effective_Date AND Termination_Date
	RETURN @@ROWCOUNT













GO
