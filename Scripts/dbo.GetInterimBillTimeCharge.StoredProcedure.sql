USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInterimBillTimeCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetInterimBillTimeCharge    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetInterimBillTimeCharge    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetInterimBillTimeCharge]
	@RateID			VarChar(10),
	@RateAssignedDate	VarChar(24),
	@RateLevel		Varchar(1),
	@VehicleClassCode	VarChar(1),
	@TimePeriod		VarChar(20),
	@Type			VarChar(20),
	@PeriodNumber		VarChar(10)
AS
	DECLARE @dRateAssignedDate DateTime
	DECLARE @nRateID Integer
	DECLARE @nPeriodNumber SmallInt

	SELECT @dRateAssignedDate = CONVERT(DateTime, NULLIF(@RateAssignedDate, ''))
	SELECT @nRateID = CONVERT(Int, NULLIF(@RateID, ''))
	SELECT @nPeriodNumber = CONVERT(SmallInt, NULLIF(@PeriodNumber, ''))
	SELECT @TimePeriod = NULLIF(@TimePeriod, '')
	SELECT @Type = NULLIF(@Type, '')
	SELECT @VehicleClassCode = NULLIF(@VehicleClassCode, '')
	SELECT @RateLevel = NULLIF(@RateLevel, '')

	SELECT	RCA.Amount
	FROM	Rate_Time_Period RTP,
		Rate_Vehicle_Class RVC,
		Rate_Charge_Amount RCA
	WHERE	RTP.Rate_ID = @nRateID
	AND	@dRateAssignedDate BETWEEN RTP.Effective_Date AND RTP.Termination_Date
	AND	RTP.Time_Period = @TimePeriod
	AND	RTP.Type = @Type
	AND	@nPeriodNumber BETWEEN RTP.Time_Period_Start AND RTP.Time_Period_End
	AND	RVC.Rate_ID = @nRateID
	AND	@dRateAssignedDate BETWEEN RVC.Effective_Date AND RVC.Termination_Date

	AND	RVC.Vehicle_Class_Code = @VehicleClassCode
	AND	RCA.Rate_ID = @nRateID
	AND	@dRateAssignedDate BETWEEN RCA.Effective_Date AND RCA.Termination_Date
	AND	RCA.Rate_Level = @RateLevel
	AND	RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID
	AND	RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID
	AND	RCA.Type = @Type














GO
