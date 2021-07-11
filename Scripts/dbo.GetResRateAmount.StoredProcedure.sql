USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateAmount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResRateAmount    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateAmount    Script Date: 2/16/99 2:05:42 PM ******/

CREATE PROCEDURE [dbo].[GetResRateAmount]
	@RateID 	Varchar(10),
	@Level 		Varchar(1),
	@CurrDate	Varchar(24),	
	@VehClassCode	Varchar(1),	
	@ChargeType	Varchar(15),	-- Regular, Late
	@PULocId	VarChar(10),
	@Time_Period	VarChar(20) =''  -- NULL  
AS
DECLARE @iRateId	Int
DECLARE @dCurrDate	Datetime
DECLARE @iKmCap		Int
DECLARE @bOverrideFlag	bit
DECLARE	@iPULocId	SmallInt

	/* 3/05/99 - cpy modified - if RTP.KM_Cap is null, display the word 'Unlimited' */
	/* 6/23/99 - changed ordering of time periods returned
			(now order by rate time period id) */
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
/*1/25/05 updated to ver 80*/

	SELECT 	@iRateId = Convert(Int, NULLIF(@RateId,'')),
		@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,'')),
		@iPULocId = CONVERT(SmallInt, NULLIF(@PULocId,'')),
		@Level = NULLIF(@Level,''),
		@ChargeType = NULLIF(@ChargeType,''),
		@VehClassCode = NULLIF(@VehClassCode,'')

	SELECT 	@iKmCap = RLS.Km_Cap,
		@bOverrideFlag = RLS.Override_Km_Cap_Flag
	FROM	Rate_Location_Set RLS,
		Rate_Location_Set_Member RLSM
	WHERE	RLS.Rate_Location_Set_ID = RLSM.Rate_Location_Set_ID
	AND	RLS.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN RLS.Effective_Date AND RLS.Termination_Date
	AND	RLSM.Location_Id = @iPULocId

	IF (@iKmCap IS NULL) And (@bOverrideFlag = 0)

		Select @iKmCap = -1

	SELECT 	RTP.Time_period,
		RTP.Time_period_start,
		RTP.Time_period_end,
		RCA.Amount,
		Case
			When @iKmCap <> -1 Then
				Convert(Varchar(6), @iKmCap)
			WHEN RTP.Km_Cap IS NULL THEN
				'Unlimited'
			Else
				Convert(Varchar(5), RTP.Km_Cap)
			End
	FROM	Rate_Charge_Amount RCA,
		Rate_Time_Period   RTP,
		Rate_Vehicle_Class RVC
	WHERE	RCA.Rate_ID = @iRateId
	AND 	RCA.Rate_Level = @Level
	AND 	RCA.Type = @ChargeType
	AND	@dCurrDate BETWEEN RCA.Effective_Date AND RCA.Termination_Date
	AND	RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID
	AND 	RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID
	AND	RVC.Rate_Id = @iRateId
	AND	RVC.Vehicle_Class_Code = @VehClassCode
	AND	@dCurrDate BETWEEN RVC.Effective_Date AND RVC.Termination_Date
	AND	RTP.Rate_ID = @iRateId
	AND 	@dCurrDate BETWEEN RTP.Effective_Date AND RTP.Termination_Date
	AND	RTP.Time_Period Like '%' + @Time_Period
--	ORDER BY RTP.Time_Period, RTP.Time_Period_Start
	ORDER BY RTP.Rate_Time_Period_ID

	RETURN @@ROWCOUNT
GO
