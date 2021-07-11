USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetKMDropOffCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetKMDropOffCharge    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetKMDropOffCharge    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetKMDropOffCharge]
	@RateID 	VarChar(10),
	@RateDate	VarChar(24)
AS
	DECLARE @dRateDate 	DateTime
	DECLARE @nRateID		Integer
	
	SELECT @dRateDate = CONVERT(DateTime, NULLIF(@RateDate, ''))
	SELECT @nRateID = CONVERT(Int, NULLIF(@RateID , ''))

	SELECT	CASE KM_Drop_Off_Charge
			WHEN 1 THEN 'KM Charge'
			ELSE ''

		End
	
	FROM	Vehicle_Rate
	WHERE	Rate_ID = @nRateID
	AND	@dRateDate BETWEEN Effective_Date AND Termination_Date
	
	
RETURN @@ROWCOUNT














GO
