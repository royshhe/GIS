USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateChargeAmtByTimePeriod]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateChargeAmtByTimePeriod    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateChargeAmtByTimePeriod    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateChargeAmtByTimePeriod    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateChargeAmtByTimePeriod    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateChargeAmtByTimePeriod]
@RateID varchar(20),
@Level char(1)
AS
Set Rowcount 2000
Select
	RT.Time_Period,RT.Time_Period_Start,RT.Time_Period_End,RC.Amount
From
	Rate_Time_Period RT, Rate_Charge_Amount RC
Where
	RT.Rate_ID = Convert(int,@RateID)
        And RC.Rate_Level = @Level
	And RT.Termination_Date = 'Dec 31 2078 11:59PM'
	And RC.Termination_Date = 'Dec 31 2078 11:59PM'
        And RT.Rate_Time_Period_ID = RC.Rate_Time_Period_ID
	And RT.Type = 'Regular'
Return 1












GO
