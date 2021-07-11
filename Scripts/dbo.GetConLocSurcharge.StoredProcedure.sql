USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConLocSurcharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.GetConLocSurcharge    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetConLocSurcharge    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConLocSurcharge    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConLocSurcharge    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the location surcharges information from rate location set and rate location set member tables.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetConLocSurcharge]
	@PULocId Varchar(5),
	@RateId Varchar(10),
	@CurrDate Varchar(24)
AS
	/* 10/21/99 - do type conversion and nullif outside of SQL statements */

DECLARE @dCurrDate Datetime, 
	@iRateId Int,
	@iPULocId Int

	SELECT 	@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,"")),
		@iRateId = Convert(Int, NULLIF(@RateID,"")),
		@iPULocId = Convert(smallint, NULLIF(@PULocID,""))

	SELECT	Flat_Surcharge, Daily_Surcharge, Per_Km_Charge,
		RLS.Km_Cap
	FROM	Rate_Location_Set RLS,
		Rate_Location_Set_Member RLSM
	WHERE	RLSM.Location_ID = @iPULocId
	AND	RLSM.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN RLSM.Effective_Date
			AND RLSM.Termination_Date
	AND	RLSM.Rate_Location_Set_ID = RLS.Rate_Location_Set_ID
	AND	RLS.Rate_ID = RLSM.Rate_ID
	AND	@dCurrDate BETWEEN RLS.Effective_Date
			AND RLS.Termination_Date
	
	RETURN @@ROWCOUNT




GO
